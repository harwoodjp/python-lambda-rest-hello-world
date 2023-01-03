import json
import os
from functions.string_reverser.app import handler, reverse

path = os.path.dirname(os.path.realpath(__file__))
file = open(f"{path}/events/success.json", "r")
event = json.loads(file.read())


def test_handler():
    response = handler(event, None)
    body = json.loads(response.get("body"))
    result = body.get("result")
    assert result == "sdrawkcab"


def test_reverse_string_response():
    response = reverse("backwards")
    assert response.get("result") == "sdrawkcab"
