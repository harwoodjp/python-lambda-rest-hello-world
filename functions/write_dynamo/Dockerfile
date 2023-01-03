FROM public.ecr.aws/lambda/python:3.8
ENV PYTHONPATH ${LAMBDA_TASK_ROOT}:${PYTHONPATH}
COPY . ${LAMBDA_TASK_ROOT}/functions/write-dynamo
RUN pip3 install -r ${LAMBDA_TASK_ROOT}/functions/write-dynamo/requirements.txt
CMD [ "functions/write_dynamo/app.handler" ]