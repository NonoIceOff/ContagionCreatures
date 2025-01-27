extends CanvasLayer

var http_request: HTTPRequest

func _ready():
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_on_request_completed"))
	check_internet_connection()

func check_internet_connection():
	var error = http_request.request("http://www.google.com")
	if error != OK:
		print("Error making HTTP request: ", error)

func _on_request_completed(_result, response_code, _headers, _body):
	if response_code == 200:
		get_node("Label").visible = false
	else:
		get_node("Label").visible = true
