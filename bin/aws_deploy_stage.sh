 # $1: AWS REST API ID
 aws apigateway create-deployment \
   --region $AWS_REGION \
   --rest-api-id $1 \
   --stage-name $AWS_REST_API_STAGE