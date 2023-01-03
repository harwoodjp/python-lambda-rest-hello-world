
How to create a (testable, monitorable) Python REST API with Lambda, Docker, and Terraform. The example functions use [AWS Lambda Powertools](https://awslabs.github.io/aws-lambda-powertools-python/2.5.0/) for API Gateway and CloudWatch integration.

1. [Setup](#setup)
2. [Terraform](#terraform)
3. [Project](#project)
4. [Development](#development)
5. [Testing](#testing)
6. [Debugging](#debugging)
7. [Monitoring](#monitoring)

### Setup
* Install and configure [Docker](https://docs.docker.com/desktop/install/mac-install/)
* Install and configure the [`aws`](https://aws.amazon.com/cli) CLI
* Install and configure [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started) CLI
* Execute the following to register Docker with ECR:
	* ```
	    aws ecr get-login-password \
	    --region [REGION] | docker login \
	    --username AWS \
	    --password-stdin [ACCOUNT ID].dkr.ecr.us-east-1.amazonaws.com
	    ```
* For Terraform development, ensure the following environmental variables are in your path:

| Variable               | Description                                   |
|------------------------|-----------------------------------------------|
| AWS_ACCESS_KEY_ID      | Access key for Terraform development          |
| AWS_SECRET_ACCESS_KEY  | Secret key for Terraform development          |


### Terraform
* We're using the following AWS components:

| Resource               | Description                                   |
|------------------------|-----------------------------------------------|
| IAM      | Roles/permissions for execution          |
| [ECR](https://us-east-1.console.aws.amazon.com/ecr/repositories)  | Repository for Lambda images          |
| [Lambda](https://us-east-1.console.aws.amazon.com/lambda/)  | Serverless function built from ECR image          |
| [API Gateway](https://us-east-1.console.aws.amazon.com/apigateway/main/apis)  | Lambda proxy integration and stage          |

* It's recommended to use infra-as-code solution like [Terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) to describe/apply application (AWS) resources, though I'll provide manual steps also
* To initialize AWS resources via Terraform:
	* Navigate to `terraform/` in the project root
	* `cd` to a function folder and run `terraform init`
	* Review `terraform plan`, then `terraform apply`
	* On first `apply`, the ECR repository is empty, so you'll see `InvalidParameterValueException: [...] Provide a valid source image`:
	* Push an image to your new ECR repo and run `terraform apply` again
	* All components should be present in your AWS environment now
* Or manually initialize components in AWS Console by doing the following:
	* Create ECR repository for your function
	* Push application image to your new ECR repository
	* Create Lambda function with "Container image" option
		* "Browse images", then select the image you just pushed
		* `arm64` architecture if you built the image on a silicon Mac 
	* Create API Gateway REST API
		* Create resource
		* Configure as proxy resource
		* Integration type: Lambda Function Proxy
		* Select your Lambda Function
	* Deploy API to Stage for production endpoint


### Project
Directory structure:

| Folder               | Description                                   |
|------------------------|-----------------------------------------------|
| bin      | Scripts for development, deployment, and CI/CD          |
| functions  | Containerized lambda functions          |
| lib  | Library code for use in functions          |
| terraform  | AWS infrastructure-as-code          |
| tests  | Tests for functions and lib          |

Example functions:
* `hello_world`, `string_reverser`
	* Demonstrates basic application structure
	* CloudWatch integration via AWS Lambda Powertools
* `write_dynamo`
	* Writes to DynamoDB, `boto3` configured from `.env`
	* Imports `dynamo_client` from `lib/` 
	    * Using DI (method) for testability (see `tests/functions/write_dynamo/test_app.py`)
	

### Development
* Basic development workflow
    * Start container
	* Make modifications to function
	* Test locally (via `pytest` and RIE requests)
	* Build image
	* Tag image
	* Push to ECR
	* Refresh Lambda with latest image
	* Deploy API to stage
* Commands (also in `bin/`)
	* Build image and run container
  	    * ```
    	    docker-compose up --build  
    	    ```
	* Tag image with ECR URL
	  * ```
	    docker tag [FUNCTION NAME]:latest \
	    [ACCOUNT ID].dkr.ecr.us-east-1.amazonaws.com/[FUNCTION NAME]:latest
	    ```
	* Push image to ECR
	  * ```
	    docker push [ACCOUNT ID].dkr.ecr.us-east-1.amazonaws.com/[FUNCTION NAME]:latest
	    ```
	* Refresh Lambda with latest image
		* ```
	    	aws lambda update-function-code \
	        --function-name [FUNCTION NAME] \
	        --image-uri [ACCOUNT ID].dkr.ecr.us-east-1.amazonaws.com/string-reverser:latest
	      ```
	* Deploy API to API Gateway Stage
		* ``` 
		    aws apigateway create-deployment \
		   --region [REGION] \
		   --rest-api-id [REST API ID] \
		   --stage-name [REST API STAGE NAME]
	       ```

### Testing
* Run unit tests
	* `pytest` for assertions/coverage
	* `docker exec -it [FUNCTION NAME] sh -c "pytest"`
* Invoke HTTP event (request) locally with [RIE](https://docs.aws.amazon.com/lambda/latest/dg/images-test.html)
	* curl: `bin/request_local.sh`
	* Event body: `bin/request_local_body.json`
* Tip: use method injection (S3, Dynamo, MySQL, etc. clients) for easy mocking (`unittest.Mock`)

### Debugging
* We can set breakpoints, watches, and step through code with [`pudb`](https://pypi.org/project/pudb/)
* Debug unit tests
	* `import pudb; pu.db`
* Debug RIE invocations
	* Use this when sending requests via Postman, curl, etc. 
	* `from pudb.remote import set_trace; set_trace(term_size=(160, 40), host='0.0.0.0', port=6900)`
	* `telnet 127.0.0.1 6900` 

### Monitoring
* Use `aws_lambda_powertools.Logger` for CloudWatch integration
* Tail production logs with `aws logs tail "/aws/lambda/[FUNCTION NAME]" --follow`