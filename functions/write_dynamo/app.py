import os
import uuid

from aws_lambda_powertools import Logger
from aws_lambda_powertools.event_handler import APIGatewayRestResolver
from aws_lambda_powertools.utilities.typing import LambdaContext

from lib.dynamo_client import DynamoClient

logger = Logger()
app = APIGatewayRestResolver()


@app.post("/write")
def write(body: dict = None, dynamo_client: DynamoClient = None) -> dict:
    body = body or app.current_event.json_body
    dynamo_client = dynamo_client or DynamoClient("table")
    item = {"id": str(uuid.uuid4()), "message": body.get("message")}
    dynamo_client.put_item(item)
    return item


def handler(event: dict, context: LambdaContext) -> dict:
    return app.resolve(event, context)
