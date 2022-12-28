from aws_lambda_powertools.event_handler import APIGatewayRestResolver
from aws_lambda_powertools import Logger
from aws_lambda_powertools.utilities.typing import LambdaContext

logger = Logger()
app = APIGatewayRestResolver()

@app.get("/hello")
def hello() -> dict:
    response = {"message": "Hola!" }
    logger.info(response)
    return response

@app.get("/hello/<name>")
def hello_name(name: str) -> dict:
    response = {"message": f"Hola, {name}!"}
    logger.info(response)
    return response

def handler(event: dict, context: LambdaContext) -> dict:
    return app.resolve(event, context)