import json

from app import handler, hello


def test_handler():
    event = {"resource": "/hello", "path": "/hello/Justin", "httpMethod": "GET"}
    response = handler(event, None)
    body = json.loads(response.get("body"))
    result = body.get("message")
    assert result == "Hola, Justin!"


def test_hello_returns_dict_contains_message():
    response = hello()
    assert response.get("message") == "Hola!"
