
extends Control

# Cache des nodes pour performance
@onready var camera = $SubViewportContainer/SubViewport/Camera2D
@onready var sub_viewport = $SubViewportContainer/SubViewport
@onready var pin_blue = $PinBlue
@onready var pin_point = $PinPoint
@onready var pin_red = $PinRed
@onready var pin_yellow = $PinYellow
@onready var pin_green = $PinGreen
@onready var position_label = $Position

# Point jaune dans la miniMap
var pin
var map = 4
var player

# Constantes pour optimiser les calculs
const MINIMAP_SIZE = Vector2(180, 180)
const MINIMAP_CENTER = MINIMAP_SIZE / 2
const MAP_SCALE = Vector2(0.2, 0.2)
const MINIMAP_MIN = Vector2(32, 32)
var minimap_max = MINIMAP_SIZE + Vector2(32, 32)



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
	if not Global.is_minimap or not player:
		return
	
	# Optimisation : une seule référence à player.position
	var player_pos = player.position
	camera.position = player_pos

	# Optimisation : utilise un dictionnaire avec les nodes cachés
	var pins_data = [
		{"node": pin_blue, "pos": Global.pinb},
		{"node": pin_point, "pos": Global.pin},
		{"node": pin_red, "pos": Global.pinr},
		{"node": pin_yellow, "pos": Global.piny},
		{"node": pin_green, "pos": Global.ping}
	]

	# Optimisation : boucle optimisée avec calculs réduits
	for pin_data in pins_data:
		if pin_data.node:
			var pin_global = Vector2(pin_data.pos.x, pin_data.pos.y) * 0.5
			var pin_relative = (pin_global - player_pos) * MAP_SCALE
			var pin_pos = pin_relative + MINIMAP_CENTER
			
			# Clamp en une seule ligne
			pin_data.node.position = pin_pos.clamp(MINIMAP_MIN, minimap_max)

	# Optimisation : mise à jour texte seulement si label existe
	if position_label:
		position_label.text = "X: %d | Y: %d" % [int(player_pos.x), int(player_pos.y)]



func change_pin(position):
	pin = position
	Global.pin = pin
	
