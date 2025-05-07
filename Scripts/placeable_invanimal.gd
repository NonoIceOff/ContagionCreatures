extends Panel

var data = {}

func _on_click_pressed() -> void:
	$AudioStreamPlayer.play()
	print(" data de la créature :", data)
	var placeable_scene = load("res://Inventory/invanimal_info.tscn").instantiate()
	placeable_scene.get_node("CanvasLayer/Name").text = data["name"]
	placeable_scene.get_node("CanvasLayer/Description").text = data["description"]
	placeable_scene.get_node("CanvasLayer/HPMax").text = "HP : "+str(data["hp"])
	placeable_scene.get_node("CanvasLayer/Speed").text = "Vitesse : "+str(data["speed"])
	placeable_scene.get_node("CanvasLayer/Element1").text = "Element 1 : "+str(data["element1"])
	placeable_scene.get_node("CanvasLayer/Element2").text = "Element 2 : "+str(data["element2"])
	placeable_scene.get_node("CanvasLayer/Animal").texture = get_node("Animal").texture
	placeable_scene.set_creature_data(data)
	get_tree().get_current_scene().add_child(placeable_scene)
	add_child(placeable_scene)

func set_data(creature_data: Dictionary) -> void:
	data = creature_data
