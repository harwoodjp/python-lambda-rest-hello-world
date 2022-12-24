from aws_lambda_powertools.event_handler import APIGatewayRestResolver

app = APIGatewayRestResolver()

@app.get("/hello")
def hello():
    return {"message": "Hello!"}

@app.get("/hello/<name>")
def hello_name(name):
    return {"message": f"Hello, {name}!"}

def handler(event, context):
    return app.resolve(event, context)