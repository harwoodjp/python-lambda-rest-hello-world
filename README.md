Rough sketch of how to create a REST API from Lambda (using [Powertools](https://awslabs.github.io/aws-lambda-powertools-python/2.5.0/)) via ECR

Workflow:
* Create Lambda from Docker image
* Create API Gateway REST API with Lambda proxy
* Develop locally with `request.sh` and `body.json`
* Tag image `latest`
* Push image to ECR
* Refresh Lambda with new image

Commands:
* `aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin [AWS_ID].dkr.ecr.us-east-1.amazonaws.com`
* `docker tag  hello-world:latest [AWS_ID].dkr.ecr.us-east-1.amazonaws.com/hello-world:latest`
* `docker push [AWS_ID].dkr.ecr.us-east-1.amazonaws.com/hello-world:latest`
