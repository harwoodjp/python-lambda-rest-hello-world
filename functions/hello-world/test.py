from app import hello

def test_hello_returns_dict_contains_message():
	response = hello()
	assert response.get("message") != None
