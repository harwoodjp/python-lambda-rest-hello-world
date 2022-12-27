Rough sketch of how to create a REST API from Lambda (using [Powertools](https://awslabs.github.io/aws-lambda-powertools-python/2.5.0/)), via ECR

Local:
* Build `hello-world`
  * `docker build -t hello-world .`
* Run `hello-world`
  * `docker run -p 9000:8080 hello-world`  
* Tag `hello-world:latest`
  * `docker tag hello-world:latest [ACCOUNT ID].dkr.ecr.us-east-1.amazonaws.com/hello-world:latest`
* Push to ECR
  * `docker push [ACCOUNT ID].dkr.ecr.us-east-1.amazonaws.com/hello-world:latest`
* Refresh Lambda
	* `aws lambda update-function-code \
    --function-name [LAMBDA NAME/ARN] \
    --image-uri [ACCOUNT ID].dkr.ecr.us-east-1.amazonaws.com/hello-world:latest`