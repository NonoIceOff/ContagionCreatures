
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

func _physics_process(delta):
	
	get_node("AnimationPlayer").current_animation = "pin"
	camera.position = player.position
	var point_pos = Global.pin - camera.position
	get_node("PinPoint").position = point_pos *0.1 + get_node("PlayerPoint").position
	
	if get_node("PinPoint").position.x < 20:
		get_node("PinPoint").position.x = 20
		
	if get_node("PinPoint").position.y < 20:
		get_node("PinPoint").position.y = 20
		
	if get_node("PinPoint").position.x > 32+180:
		get_node("PinPoint").position.x = 32+180
		
	if get_node("PinPoint").position.y > 32+180:
		get_node("PinPoint").position.y = 32+180
		
	get_node("Position").text = "X: "+str(int(player.position.x))+"  |  Y: "+str(int(player.position.y))

func change_pin(position):
	pin = position
	Global.pin = pin

	
	
	
	
#func draw_point(position: Vector2):
	#Global.point_sprite.color = Color(1,1,0)
	#Global.point_sprite.size = Vector2i(11.0, 11.0)
	#Global.point_sprite.position = position.round()
	#add_child(Global.point_sprite)
	
	
#func showPoint_miniMap():
	#if Global.saved_point_position != Vector2.ZERO:
		#print("aaaaaaaaaaaah")
		#draw_point(Global.saved_point_position)
	
