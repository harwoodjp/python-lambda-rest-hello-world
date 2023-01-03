from aws_lambda_powertools import Logger
from aws_lambda_powertools.event_handler import APIGatewayRestResolver
from aws_lambda_powertools.utilities.typing import LambdaContext

logger = Logger()
app = APIGatewayRestResolver()


@app.post("/reverse/<string>")
def reverse(string: str) -> dict:
    response = {"result": string[::-1]}
    return response


def handler(event: dict, context: LambdaContext) -> dict:
    return app.resolve(event, context)
