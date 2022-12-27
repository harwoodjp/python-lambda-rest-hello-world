Rough sketch of how to create a REST API from Lambda (using [Powertools](https://awslabs.github.io/aws-lambda-powertools-python/2.5.0/)), via ECR


Resources:
* Preferably use infra-as-code solution like [Terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) or [CloudFormation](https://aws.amazon.com/cloudformation/) to describe/apply application resources
* AWS components:
  * ECR repo for application container
  * Lambda sourced from (ECR) container image
  * API Gateway
  	* REST API
  		* Create method > ANY > Integration type: Lambda Function
  		* Add `/hello` resource
  		* Add `{proxy+}` resource


Commands:
* Build `hello-world`
  * `docker build -t hello-world .`
* Run `hello-world`
  * `docker run -p 9000:8080 hello-world`  
* Tag `hello-world:latest`
  * `docker tag hello-world:latest [ACCOUNT ID].dkr.ecr.us-east-1.amazonaws.com/hello-world:latest`
* Push to ECR
  * `docker push [ACCOUNT ID].dkr.ecr.us-east-1.amazonaws.com/hello-world:latest`
* Refresh Lambda with latest image
	* `aws lambda update-function-code --function-name [LAMBDA NAME/ARN] --image-uri [ACCOUNT ID].dkr.ecr.us-east-1.amazonaws.com/hello-world:latest`
* Deploy API to Stage `prod`
	* `aws apigateway create-deployment --region us-east-1 --rest-api-id [API ID] --stage-name prod`