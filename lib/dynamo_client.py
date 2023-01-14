import boto3


class DynamoClient:
    def __init__(self, table: str):
        dynamo = boto3.resource("dynamodb")
        self.table = dynamo.Table(table)

    def put_item(self, item: dict) -> dict:
        self.table.put_item(Item=item)
