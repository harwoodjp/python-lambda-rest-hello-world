aws ecr get-login-password \
--region us-east-1 | docker login \
--username AWS \
--password-stdin [AWS ID].dkr.ecr.us-east-1.amazonaws.com