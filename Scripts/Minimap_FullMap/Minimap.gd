
extends Control

@onready var camera = get_node("SubViewportContainer/SubViewport/Camera2D")

#Point jaune dans la miniMap
var pin
var map = 4
var player



func _ready() -> void:
	var maps_to_display = []
	if get_node_or_null("../../../Map3") != null:
		var map_to_display_grass = "../../TileMap/grass"
		var map_to_display_ground = "../../TileMap/Ground"
		var map_to_display_bush = "../../TileMap/bush"
		var map_to_display_tree = "../../TileMap/tree"
		var map_to_display_house = "../../TileMap/house"
		# Liste des maps à afficher
		maps_to_display = [
			map_to_display_ground,
			map_to_display_grass,
			map_to_display_bush,
			map_to_display_tree,
			map_to_display_house
		]
		
	if get_node_or_null("../../../HomeOfHector") != null:
		var map_to_display = "../../Control/TileMap"
		# Liste des maps à afficher
		maps_to_display = [
			map_to_display
		]

	var sub_viewport = $SubViewportContainer/SubViewport  # Référence au SubViewport dans Minimap

	# Parcourt chaque chemin de map et les ajoute au SubViewport
	for map_path in maps_to_display:
		if not map_path:
			print("Erreur : chemin de map manquant.")
			continue

		var map_node = get_node(map_path)
		if not map_node:
			print("Erreur : chemin de map invalide pour :", map_path)
			continue

		# Duplique la map et l'ajoute au SubViewport
		var map_copy = map_node.duplicate()
		sub_viewport.add_child(map_copy)
		print("Carte ajoutée à la minimap :", map_copy.name)

	change_map()
	
func change_map():
	pin = Vector2(0,0)
	if get_node_or_null("../../../Map3") != null:
		player = get_node("../../TileMap/Player_One")
	if get_node_or_null("../../../HomeOfHector") != null:
		player = get_node("../../Control/Player_One")

func _process(delta):
	if Global.is_minimap == true:
		camera.position = player.position

		var minimap_size = Vector2(180, 180) # Taille de la minimap
		var minimap_center = minimap_size / 2
		var map_scale = Vector2(0.2, 0.2) # Échelle de la caméra

		# Liste des pins et de leurs positions globales respectives
		var pins = {
			"PinBlue": Global.pinb,
			"PinPoint": Global.pin,
			"PinRed": Global.pinr,
			"PinYellow": Global.piny,
			"PinGreen": Global.ping
		}

		for pin_name in pins.keys():
			var pin_global = Vector2(pins[pin_name][0],pins[pin_name][1])/2
			var pin_relative = (pin_global - camera.position) * map_scale
			var pin_minimap_pos = pin_relative + minimap_center

			var pin_node = get_node(pin_name)
			pin_node.position = pin_minimap_pos

			# Garder les pins dans les limites de la minimap
			pin_node.position.x = clamp(pin_node.position.x, 32, minimap_size.x+32)
			pin_node.position.y = clamp(pin_node.position.y, 32, minimap_size.y+32)

		# Mise à jour des coordonnées du joueur
		get_node("Position").text = "X: " + str(int(player.position.x)) + " | Y: " + str(int(player.position.y))





func clamp_to_minimap(pin_node, minimap_size):
	pin_node.position.x = clamp(pin_node.position.x, 0, minimap_size.x)
	pin_node.position.y = clamp(pin_node.position.y, 0, minimap_size.y)


func change_pin(position):
	pin = position
	Global.pin = pin
	
