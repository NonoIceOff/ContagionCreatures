extends CanvasLayer

func _ready():
	if get_node_or_null("/root/main_map/ui") != null:
		get_node("Minimap").map = 1
		get_node("Minimap").change_map()
	elif get_node_or_null("/root/map2/ui") != null:
		get_node("Minimap").map = 2
		get_node("Minimap").change_map()
	elif get_node_or_null("/root/HomeOfHector/ui") != null:
		get_node("Minimap").map = 3
		get_node("Minimap").change_map()
