from unittest.mock import Mock
import json
from app import write, DynamoClient

def test_write_returns_item():
  dynamo_client = Mock(DynamoClient)
  dynamo_client.put_item.return_value = None
  response = write(
    body={"message": "Hello!"},
    dynamo_client=dynamo_client
  )
  assert response.get("id") and response.get("message")
  assert response.get("message") == "Hello!"
