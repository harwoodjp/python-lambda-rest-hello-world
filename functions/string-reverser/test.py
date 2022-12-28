from app import reverse

def test_reverse_string_response():
	response = reverse("backwards")
	assert response.get("result") == "sdrawkcab"