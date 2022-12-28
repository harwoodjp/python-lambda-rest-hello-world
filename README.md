
How to create a (testable, monitorable) Python REST API with Lambda and Docker using [AWS Lambda Powertools](https://awslabs.github.io/aws-lambda-powertools-python/2.5.0/).

### Prerequisites
* Install and configure `aws` CLI
* Execute `bin/aws_ecr_docker_login.sh` to register Docker with ECR
* Ensure the following environmental variables are in your path:

| Variable           | Description                                   |
|--------------------|-----------------------------------------------|
| AWS_ACCOUNT_ID     | Account ID for AWS user                       |
| AWS_FUNCTION_NAME  | Name of your Lambda function                  |
| AWS_REGION         | Region your AWS resources are associated with |
| AWS_REST_API_ID    | API Gateway ID for your REST API              |
| AWS_REST_API_STAGE | Name of stage your API will deploy to         |

### Initialize AWS resources
* It's recommended to use infra-as-code solution like [Terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) or [CloudFormation](https://aws.amazon.com/cloudformation/) to describe/apply application (AWS) resources
* We'll need to initialize AWS with appropriate components for our application:
	* Create [ECR](https://us-east-1.console.aws.amazon.com/ecr/repositories) repository for your function
	* Push application image to your new ECR repository
	* Create [Lambda](https://us-east-1.console.aws.amazon.com/lambda/) function with "Container image" option
		* "Browse images", select the image you just pushed
		* `arm64` architecture if you built the image on an M1 Mac 
	* Create [API Gateway](https://us-east-1.console.aws.amazon.com/apigateway/main/apis) REST API
		* Create resource
		* Configure as proxy resource
		* Integration type: Lambda Function Proxy
		* Select your Lambda Function

### Development workflow
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
	   --region [AWS REGION] \
	   --rest-api-id [AWS REST API ID] \
	   --stage-name [AWS REST API STAGE NAME]
	```

### Testing
* Run unit tests
	* `pytest` for assertions/coverage
	* `docker exec -it [FUNCTION NAME] sh -c "pytest test.py"`
* Invoke HTTP event (request) locally with [RIE](https://docs.aws.amazon.com/lambda/latest/dg/images-test.html)
	* curl: `bin/request_local.sh`
	* Event body: `bin/request_local_body.json`
* Tip: use method injection (S3, Dynamo, MySQL, etc. clients) for easy mocking (`unittest.Mock`)

### Debugging
* We can set breakpoints, watches, and step through code with [`pudb`](https://pypi.org/project/pudb/)
* Debug unit tests
	* `import pudb; pu.db` or `pu.db`
* Debug RIE invocations
	* Use this when sending requests via Postman, curl, etc. 
	* `from pudb.remote import set_trace; set_trace(term_size=(160, 40), host='0.0.0.0', port=6900)`
	* `telnet 127.0.0.1 6900` 

### Monitoring
* Use `aws_lambda_powertools.Logger` for CloudWatch integration
* Tail production logs with `aws logs tail "/aws/lambda/[FUNCTION NAME]" --follow`