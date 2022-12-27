aws lambda update-function-code \
    --function-name  python-hello-world-arm64 \
    --image-uri $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/hello-world:latest
