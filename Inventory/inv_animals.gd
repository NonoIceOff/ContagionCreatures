extends Control

var is_open = false
var colonnes = 4
var creatures = []

func _ready():
	close()

	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_on_request_completed"))
	http_request.request("https://contagioncreaturesapi.vercel.app/api/creatures")

func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var response_text = body.get_string_from_utf8()
		var parse_result = JSON.parse_string(response_text)
		creatures = parse_result
		draw_inventory()
	else:
		print("Failed to fetch creatures: ", response_code)

func draw_inventory():
	get_node("CanvasLayer/Loading").visible = false
	for i in range(creatures.size()):
		var creature = creatures[i]
		
		var hbox = HBoxContainer.new()
		hbox.custom_minimum_size = Vector2(300, 264)
		get_node("CanvasLayer/GridContainer").add_child(hbox)
		
		var sprite = Sprite2D.new()
		sprite.scale = Vector2(6, 6)
		var placeable_scene = load("res://Scenes/Placables/placeable_invanimal.tscn").instantiate()
		placeable_scene.get_node("Name").text = creature["name"]
		if ResourceLoader.exists("res://Textures/Animals/" + creature["texture"]):
			placeable_scene.get_node("Animal").texture = load("res://Textures/Animals/" + creature["texture"])
		else:
			placeable_scene.get_node("Animal").texture = load("res://Textures/point_exclam.png")
		placeable_scene.data = creatures[i]
		hbox.add_child(placeable_scene)
		
func open():
	get_node("CanvasLayer").visible = true
	is_open = true

func close():
	get_node("CanvasLayer").visible = false
	is_open = false
