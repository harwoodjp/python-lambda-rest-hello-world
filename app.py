from aws_lambda_powertools.event_handler import APIGatewayRestResolver

app = APIGatewayRestResolver()

@app.get("/hello")
def hello():
    return {"message": "Hola!"}

@app.get("/hello/<name>")
def hello_name(name):
    return {"message": f"Hola, {name}!"}

def handler(event, context):
    return app.resolve(event, context)