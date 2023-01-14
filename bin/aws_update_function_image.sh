# $1: AWS FUNCTION NAME
aws lambda update-function-code \
    --function-name $1 \
    --image-uri $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/$1:latest