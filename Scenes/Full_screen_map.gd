extends Control

@onready var camera = get_node("SubViewportContainer/SubViewport/Camera2D")

#Point jaune dans la miniMap
var pin
var points_stock: Array = []
var point_placed = false
var point_sprite = ColorRect.new() 
var point_pos

func _ready():
	pin = Global.pin
	
	if Global.pinb != Vector2(0,0):
		get_node("SubViewportContainer/SubViewport/Camera2D/PinBlue").position = Global.pinb
		get_node("SubViewportContainer/SubViewport/Camera2D/PinBlue").visible = true
		get_node("CanvasLayer/PinBlue").modulate = Color(0.2,0.2,0.2,1)
		get_node("CanvasLayer/PinBlue/CPUParticles2D").visible = false
	if Global.pinr != Vector2(0,0):
		get_node("SubViewportContainer/SubViewport/Camera2D/PinRed").position = Global.pinr
		get_node("SubViewportContainer/SubViewport/Camera2D/PinRed").visible = true
		get_node("CanvasLayer/PinRed").modulate = Color(0.2,0.2,0.2,1)
		get_node("CanvasLayer/PinRed/CPUParticles2D").visible = false
	if Global.piny != Vector2(0,0):
		get_node("SubViewportContainer/SubViewport/Camera2D/PinYellow").position = Global.piny
		get_node("SubViewportContainer/SubViewport/Camera2D/PinYellow").visible = true
		get_node("CanvasLayer/PinYellow").modulate = Color(0.2,0.2,0.2,1)
		get_node("CanvasLayer/PinYellow/CPUParticles2D").visible = false
	if Global.ping != Vector2(0,0):
		get_node("SubViewportContainer/SubViewport/Camera2D/PinGreen").position = Global.ping
		get_node("SubViewportContainer/SubViewport/Camera2D/PinGreen").visible = true
		get_node("CanvasLayer/PinGreen").modulate = Color(0.2,0.2,0.2,1)
		get_node("CanvasLayer/PinGreen/CPUParticles2D").visible = false


	var map_to_display_grass = "../../TileMap/grass"
	var map_to_display_ground = "../../TileMap/Ground"
	var map_to_display_bush = "../../TileMap/bush"
	var map_to_display_tree = "../../TileMap/tree"
	var map_to_display_house = "../../TileMap/house"
	# Liste des maps à afficher
	var maps_to_display = [
		map_to_display_ground,
		map_to_display_grass,
		map_to_display_bush,
		map_to_display_tree,
		map_to_display_house
	]

	var sub_viewport = $SubViewportContainer/SubViewport/Camera2D/Map
	
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
	
	
func _physics_process(delta):
	if get_node("CanvasLayer/AddPin").visible == false:
		if Input.is_action_pressed("droite") and get_node("SubViewportContainer/SubViewport/Camera2D").offset.x < 1000:
			get_node("SubViewportContainer/SubViewport/Camera2D").offset.x += 5
		if Input.is_action_pressed("gauche") and get_node("SubViewportContainer/SubViewport/Camera2D").offset.x > -200:
			get_node("SubViewportContainer/SubViewport/Camera2D").offset.x -= 5
		if Input.is_action_pressed("haut") and get_node("SubViewportContainer/SubViewport/Camera2D").offset.y > 0:
			get_node("SubViewportContainer/SubViewport/Camera2D").offset.y -= 5
		if Input.is_action_pressed("bas") and get_node("SubViewportContainer/SubViewport/Camera2D").offset.y < 500:
			get_node("SubViewportContainer/SubViewport/Camera2D").offset.y += 5
		
	get_node("AnimationPlayer").current_animation = "pin"
	camera.position = get_node("../../TileMap/Player_One").position
	point_pos = pin - camera.position
	get_node("SubViewportContainer/SubViewport/Camera2D/PinPoint").position =pin*2+get_node("SubViewportContainer/SubViewport/Camera2D/Map").position
	get_node("SubViewportContainer/SubViewport/Camera2D/PlayerPoint").position = get_node("../../TileMap/Player_One").position*2+get_node("SubViewportContainer/SubViewport/Camera2D/Map").position
		
	get_node("CanvasLayer/Position").text = "X: "+str(int(get_node("../../TileMap/Player_One").position.x))+"  |  Y: "+str(int(get_node("../../TileMap/Player_One").position.y))
	var postest = get_node("SubViewportContainer/SubViewport/Camera2D").offset*2
	

func change_pin(position):
	pin = position
	Global.pin = pin
	
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if get_node("CanvasLayer/AddPin").visible == false:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed and get_node("SubViewportContainer/SubViewport/Camera2D").zoom.x < 4:
				get_node("SubViewportContainer/SubViewport/Camera2D").zoom *= 1.1
				get_node("SubViewportContainer/SubViewport/Camera2D/PlayerPoint").size *= 0.95
				get_node("SubViewportContainer/SubViewport/Camera2D/PinPoint").size *= 0.95
				
				get_node("SubViewportContainer/SubViewport/Camera2D/PinBlue").scale *= 0.95
				get_node("SubViewportContainer/SubViewport/Camera2D/PinBlue/CPUParticles2D").scale_amount_min *= 0.95
				get_node("SubViewportContainer/SubViewport/Camera2D/PinBlue/CPUParticles2D").scale_amount_max *= 0.95
				
				get_node("SubViewportContainer/SubViewport/Camera2D/PinRed").scale *= 0.95
				get_node("SubViewportContainer/SubViewport/Camera2D/PinRed/CPUParticles2D").scale_amount_min *= 0.95
				get_node("SubViewportContainer/SubViewport/Camera2D/PinRed/CPUParticles2D").scale_amount_max *= 0.95
				
				get_node("SubViewportContainer/SubViewport/Camera2D/PinYellow").scale *= 0.95
				get_node("SubViewportContainer/SubViewport/Camera2D/PinYellow/CPUParticles2D").scale_amount_min *= 0.95
				get_node("SubViewportContainer/SubViewport/Camera2D/PinYellow/CPUParticles2D").scale_amount_max *= 0.95
				
				get_node("SubViewportContainer/SubViewport/Camera2D/PinGreen").scale *= 0.95
				get_node("SubViewportContainer/SubViewport/Camera2D/PinGreen/CPUParticles2D").scale_amount_min *= 0.95
				get_node("SubViewportContainer/SubViewport/Camera2D/PinGreen/CPUParticles2D").scale_amount_max *= 0.95
				
				
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed and get_node("SubViewportContainer/SubViewport/Camera2D").zoom.x > 1:
				get_node("SubViewportContainer/SubViewport/Camera2D").zoom *= 0.9
				get_node("SubViewportContainer/SubViewport/Camera2D/PlayerPoint").size *= 1.05
				get_node("SubViewportContainer/SubViewport/Camera2D/PinPoint").size *= 1.05
				
				get_node("SubViewportContainer/SubViewport/Camera2D/PinBlue").scale *= 1.05
				get_node("SubViewportContainer/SubViewport/Camera2D/PinBlue/CPUParticles2D").scale_amount_min *= 1.05
				get_node("SubViewportContainer/SubViewport/Camera2D/PinBlue/CPUParticles2D").scale_amount_max *= 1.05
				
				get_node("SubViewportContainer/SubViewport/Camera2D/PinRed").scale *= 1.05
				get_node("SubViewportContainer/SubViewport/Camera2D/PinRed/CPUParticles2D").scale_amount_min *= 1.05
				get_node("SubViewportContainer/SubViewport/Camera2D/PinRed/CPUParticles2D").scale_amount_max *= 1.05
				
				get_node("SubViewportContainer/SubViewport/Camera2D/PinYellow").scale *= 1.05
				get_node("SubViewportContainer/SubViewport/Camera2D/PinYellow/CPUParticles2D").scale_amount_min *= 1.05
				get_node("SubViewportContainer/SubViewport/Camera2D/PinYellow/CPUParticles2D").scale_amount_max *= 1.05
				
				get_node("SubViewportContainer/SubViewport/Camera2D/PinGreen").scale *= 1.05
				get_node("SubViewportContainer/SubViewport/Camera2D/PinGreen/CPUParticles2D").scale_amount_min *= 1.05
				get_node("SubViewportContainer/SubViewport/Camera2D/PinGreen/CPUParticles2D").scale_amount_max *= 1.05
			
			
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if get_node("CanvasLayer/AddPin").visible == true:
				get_node("CanvasLayer/AddPin").visible = false
				get_node("CanvasLayer/AddPin").position = event.position
			elif get_node("CanvasLayer/AddPin").visible == false:
				get_node("CanvasLayer/AddPin").visible = true
				get_node("CanvasLayer/AddPin").position = event.position
