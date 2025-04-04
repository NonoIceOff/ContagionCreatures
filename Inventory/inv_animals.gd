extends Control

var is_open = false
var colonnes = 4
var creatures = []
var creatures_captured = []

func _ready():
	close()

	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_on_request_completed"))
	http_request.request("https://contagioncreaturesapi.vercel.app/api/creatures")
	_load_creatures_data()

func _load_creatures_data():
	var file = FileAccess.open("res://Constantes/creatures.json", FileAccess.READ)
	if file:
		var json_data = JSON.parse_string(file.get_as_text())
		if json_data is Array:
			creatures_captured = json_data
		else:
			print("Erreur : données JSON invalides.")
	else:
		print("Erreur : impossible d'ouvrir le fichier JSON.")

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
	var grid_container = get_node("CanvasLayer/GridContainer")

	for child in grid_container.get_children():
		child.queue_free()

	for creature in creatures:
		print(creature)
		var is_captured = false 
		
		print(creatures_captured)

		for captured in creatures_captured:
			print("Captured :",creature)
			print("aaaaaaaaaa")
			if int(creature["id"]) == int(captured["id"]):
				is_captured = true
				break 

		var hbox = HBoxContainer.new()
		hbox.custom_minimum_size = Vector2(300, 264)
		grid_container.add_child(hbox)

		var placeable_scene = load("res://Scenes/Placables/placeable_invanimal.tscn").instantiate()
		placeable_scene.get_node("Name").text = creature["name"]

		var texture_path = "res://Textures/Animals/" + creature["texture"]
		if ResourceLoader.exists(texture_path):
			placeable_scene.get_node("Animal").texture = load(texture_path)
		else:
			placeable_scene.get_node("Animal").texture = load("res://Textures/point_exclam.png")

		placeable_scene.modulate = Color(1,1,1,0.5)
		if is_captured:
			placeable_scene.get_node("Name").text += " ✅"
			placeable_scene.modulate = Color(1,1,1,1)
			placeable_scene.self_modulate = Color(0.5, 1, 0.5)

		placeable_scene.data = creature
		hbox.add_child(placeable_scene)

		
func open():
	get_node("CanvasLayer").visible = true
	is_open = true

func close():
	get_node("CanvasLayer").visible = false
	is_open = false
