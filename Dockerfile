FROM public.ecr.aws/lambda/python:3.8
COPY . ${LAMBDA_TASK_ROOT}/app
WORKDIR ${LAMBDA_TASK_ROOT}/app
RUN pip3 install -r requirements.txt
CMD [ "app.handler" ]