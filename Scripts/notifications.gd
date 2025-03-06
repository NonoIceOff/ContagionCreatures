extends CanvasLayer

var http_request: HTTPRequest

func _ready():
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_on_request_completed"))
	check_internet_connection()
	Input.connect("joy_connection_changed", Callable(self, "_on_joy_connection_changed"))

func check_internet_connection():
	var error = http_request.request("http://www.google.com")
	if error != OK:
		print("Error making HTTP request: ", error)

func _on_request_completed(_result, response_code, _headers, _body):
	if response_code == 200:
		get_node("Internet").visible = false
	else:
		get_node("Internet").visible = true

func _on_joy_connection_changed(device_id: int, connected: bool):
	if connected:
		notification_controller(Input.get_joy_name(device_id), true)
	else:
		notification_controller(Input.get_joy_name(device_id), false)

func notification_controller(controller_name: String, connected: bool):
	get_node("AudioStreamPlayer2D").play()
	get_node("ColorRect").visible = true
	if connected:
		get_node("ColorRect/Label").text = "Manette '" + controller_name + "' connectée."
	else:
		get_node("ColorRect/Label").text = "Manette déconnectée."
	
	await get_tree().create_timer(5.0).timeout
	get_node("ColorRect").visible = false
