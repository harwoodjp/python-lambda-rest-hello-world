aws lambda update-function-code \
    --function-name $AWS_FUNCTION_NAME \
    --image-uri $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/hello-world:latest