FROM public.ecr.aws/lambda/python:3.8
ENV PYTHONPATH ${LAMBDA_TASK_ROOT}:${PYTHONPATH}
COPY . ${LAMBDA_TASK_ROOT}/functions/write_dynamo
RUN find -name requirements.txt | xargs pip3 install -r $1
CMD [ "functions/write_dynamo/app.handler" ]