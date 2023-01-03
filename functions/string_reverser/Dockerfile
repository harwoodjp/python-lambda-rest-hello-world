FROM public.ecr.aws/lambda/python:3.8
ENV PYTHONPATH ${LAMBDA_TASK_ROOT}:${PYTHONPATH}
COPY . ${LAMBDA_TASK_ROOT}/functions/string_reverser
RUN pip3 install -r $(find -name requirements.txt)
CMD [ "functions/string_reverser/app.handler" ]