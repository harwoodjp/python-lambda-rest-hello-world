# $1: AWS FUNCTION NAME
aws logs tail "/aws/lambda/$1" --follow