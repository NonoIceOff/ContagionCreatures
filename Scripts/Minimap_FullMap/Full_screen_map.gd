extends Control

@onready var camera = $SubViewportContainer/SubViewport/Camera2D
@onready var sub_viewport = $SubViewportContainer/SubViewport
@onready var canvas_layer = $CanvasLayer
@onready var add_pin_menu = $CanvasLayer/AddPin
@onready var info_carte = $CanvasLayer/InfoTouches/Carte

@onready var cam_pin_blue = $SubViewportContainer/SubViewport/Camera2D/PinBlue
@onready var cam_pin_blue_particles = $SubViewportContainer/SubViewport/Camera2D/PinBlue/CPUParticles2D
@onready var cam_pin_red = $SubViewportContainer/SubViewport/Camera2D/PinRed
@onready var cam_pin_red_particles = $SubViewportContainer/SubViewport/Camera2D/PinRed/CPUParticles2D
@onready var cam_pin_yellow = $SubViewportContainer/SubViewport/Camera2D/PinYellow
@onready var cam_pin_yellow_particles = $SubViewportContainer/SubViewport/Camera2D/PinYellow/CPUParticles2D
@onready var cam_pin_green = $SubViewportContainer/SubViewport/Camera2D/PinGreen
@onready var cam_pin_green_particles = $SubViewportContainer/SubViewport/Camera2D/PinGreen/CPUParticles2D
@onready var cam_pin_point = $SubViewportContainer/SubViewport/Camera2D/PinPoint
@onready var cam_player_point = $SubViewportContainer/SubViewport/Camera2D/PlayerPoint
@onready var cam_map = $SubViewportContainer/SubViewport/Camera2D/Map

@onready var canvas_pin_blue = $CanvasLayer/PinBlue
@onready var canvas_pin_blue_particles = $CanvasLayer/PinBlue/CPUParticles2D
@onready var canvas_pin_red = $CanvasLayer/PinRed
@onready var canvas_pin_red_particles = $CanvasLayer/PinRed/CPUParticles2D
@onready var canvas_pin_yellow = $CanvasLayer/PinYellow
@onready var canvas_pin_yellow_particles = $CanvasLayer/PinYellow/CPUParticles2D
@onready var canvas_pin_green = $CanvasLayer/PinGreen
@onready var canvas_pin_green_particles = $CanvasLayer/PinGreen/CPUParticles2D
@onready var cross_sprite = $CanvasLayer/Cross

var pin
var points_stock: Array = []
var point_placed = false
var point_sprite = ColorRect.new() 
var point_pos
var pin_menu = false
var player_node = null
var zoom_tween: Tween = null

# Pas de limites de déplacement - liberté totale
const CAMERA_MOVE_SPEED = 15
const CAMERA_MOVE_SPEED_FAST = 30
const ZOOM_MIN = 0.3  # Permet de voir TOUTE la map
const ZOOM_MAX = 4.0
const ZOOM_DEFAULT = 1.0  # Démarre plus dézoomé
const ZOOM_FACTOR_IN = 1.2  # Augmenté de 1.1 à 1.2 (zoom plus rapide)
const ZOOM_FACTOR_OUT = 0.8  # Diminué de 0.9 à 0.8 (dezoom plus rapide)
const ZOOM_FACTOR_TRIGGER = 0.05  # Pour zoom progressif manette
const SCALE_FACTOR_IN = 0.9  # Augmenté de 0.95 à 0.9
const SCALE_FACTOR_OUT = 1.1  # Augmenté de 1.05 à 1.1
const DOUBLE_CLICK_TIME = 0.3
const PIN_INACTIVE_COLOR = Color(0.2, 0.2, 0.2, 1)

var last_click_time = 0.0
var camera_lerp_speed = 10.0

func setup_pin(cam_pin, canvas_pin, canvas_particles, global_pos: Vector2) -> void:
	if global_pos != Vector2.ZERO:
		if cam_pin:
			cam_pin.position = global_pos
			cam_pin.visible = true
		if canvas_pin:
			canvas_pin.modulate = PIN_INACTIVE_COLOR
		if canvas_particles:
			canvas_particles.visible = false

func _ready():
	# Configure cette node pour qu'elle fonctionne pendant la pause
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Pause le jeu (mais pas l'UI)
	get_tree().paused = true
	
	if camera:
		camera.zoom = Vector2(ZOOM_DEFAULT, ZOOM_DEFAULT)
		camera.offset = Vector2.ZERO
		if camera.scale == Vector2(0.1, 0.1):
			camera.scale = Vector2(1, 1)
	
	if cross_sprite:
		cross_sprite.visible = false
	
	if cam_player_point:
		cam_player_point.size = Vector2(16, 16)
		cam_player_point.color = Color(0, 1, 0, 0.8)
	
	if cam_pin_point:
		cam_pin_point.size = Vector2(16, 16)
		cam_pin_point.color = Color(1, 1, 0, 1)
	
	var pins_to_scale = [cam_pin_blue, cam_pin_red, cam_pin_yellow, cam_pin_green]
	for pin_sprite in pins_to_scale:
		if pin_sprite and pin_sprite.scale.x > 10:
			pin_sprite.scale = Vector2(5, 5)
	
	if info_carte:
		info_carte.texture = load(Controllers.x_texture)
	
	pin = Global.pin
	
	setup_pin(cam_pin_blue, canvas_pin_blue, canvas_pin_blue_particles, Global.pinb)
	setup_pin(cam_pin_red, canvas_pin_red, canvas_pin_red_particles, Global.pinr)
	setup_pin(cam_pin_yellow, canvas_pin_yellow, canvas_pin_yellow_particles, Global.piny)
	setup_pin(cam_pin_green, canvas_pin_green, canvas_pin_green_particles, Global.ping)


	# Utiliser get_tree().current_scene pour accéder à la scène principale
	var main_scene = get_tree().current_scene
	var sub_viewport = $SubViewportContainer/SubViewport/Camera2D/Map
	
	# Chercher le TileMap dans la scène principale
	var tilemap = main_scene.get_node_or_null("TileMap")
	if tilemap:
		var map_copy = tilemap.duplicate()
		sub_viewport.add_child(map_copy)
	else:
		# Ancienne méthode pour compatibilité
		var map_to_display_grass = "../../TileMap/grass"
		var map_to_display_ground = "../../TileMap/Ground"
		var map_to_display_bush = "../../TileMap/bush"
		var map_to_display_tree = "../../TileMap/tree"
		var map_to_display_house = "../../TileMap/house"
		var maps_to_display = [
			map_to_display_ground,
			map_to_display_grass,
			map_to_display_bush,
			map_to_display_tree,
			map_to_display_house
		]
		
		for map_path in maps_to_display:
			if not map_path:
				continue
			var map_node = get_node_or_null(map_path)
			if map_node:
				var map_copy = map_node.duplicate()
				sub_viewport.add_child(map_copy)
	

func scale_pins(scale_factor: float, particles_scale_factor: float) -> void:
	var pins = [
		{"sprite": cam_pin_blue, "particles": cam_pin_blue_particles},
		{"sprite": cam_pin_red, "particles": cam_pin_red_particles},
		{"sprite": cam_pin_yellow, "particles": cam_pin_yellow_particles},
		{"sprite": cam_pin_green, "particles": cam_pin_green_particles}
	]
	
	for pin_data in pins:
		if pin_data.sprite:
			pin_data.sprite.scale *= scale_factor
		if pin_data.particles:
			pin_data.particles.scale_amount_min *= particles_scale_factor
			pin_data.particles.scale_amount_max *= particles_scale_factor
	
	if cam_player_point:
		cam_player_point.size *= particles_scale_factor
	if cam_pin_point:
		cam_pin_point.size *= particles_scale_factor
	
func _physics_process(delta):
	if not player_node:
		var players = get_tree().get_nodes_in_group("Player_One")
		if players.size() > 0:
			player_node = players[0]
		else:
			player_node = get_node_or_null("../../TileMap/Player_One")
		
		if not player_node:
			return
	
	if add_pin_menu and not add_pin_menu.visible:
		var move_speed = CAMERA_MOVE_SPEED
		if Input.is_action_pressed("Sprint"):
			move_speed = CAMERA_MOVE_SPEED_FAST
		
		var movement = Vector2.ZERO
		# Déplacement sans limites
		if Input.is_action_pressed("droite"):
			movement.x += move_speed
		if Input.is_action_pressed("gauche"):
			movement.x -= move_speed
		if Input.is_action_pressed("haut"):
			movement.y -= move_speed
		if Input.is_action_pressed("bas"):
			movement.y += move_speed
		
		if movement != Vector2.ZERO:
			camera.offset += movement
		
		if Input.get_connected_joypads().size() > 0:
			var zoom_input = Input.get_action_strength("ui_page_down") - Input.get_action_strength("ui_page_up")
			if abs(zoom_input) > 0.1:
				var new_zoom = camera.zoom.x + zoom_input * ZOOM_FACTOR_TRIGGER
				if new_zoom >= ZOOM_MIN and new_zoom <= ZOOM_MAX:
					var zoom_ratio = new_zoom / camera.zoom.x
					camera.zoom *= zoom_ratio
					var scale_factor = 1.0 / zoom_ratio
					scale_pins(scale_factor, scale_factor)
	
	var player_pos = player_node.position
	camera.position = player_pos
	point_pos = pin - player_pos
	
	# Le Map node a scale=2 et position=(250,250) dans la scène
	# Pour convertir coordonnées monde -> coordonnées Map:
	# map_local = (world_pos * map_scale) + map_offset
	var map_scale = Vector2(2, 2)
	var map_offset = Vector2(250, 250)
	
	# Mise à jour des positions des pins et du joueur dans la map
	if cam_pin_point:
		cam_pin_point.position = (pin * map_scale) + map_offset
	if cam_player_point:
		cam_player_point.position = (player_pos * map_scale) + map_offset
	
	# Mise à jour des pins colorés depuis Global
	if cam_pin_blue and Global.pinb != Vector2.ZERO:
		cam_pin_blue.position = (Global.pinb * map_scale) + map_offset
	if cam_pin_red and Global.pinr != Vector2.ZERO:
		cam_pin_red.position = (Global.pinr * map_scale) + map_offset
	if cam_pin_yellow and Global.piny != Vector2.ZERO:
		cam_pin_yellow.position = (Global.piny * map_scale) + map_offset
	if cam_pin_green and Global.ping != Vector2.ZERO:
		cam_pin_green.position = (Global.ping * map_scale) + map_offset
func change_pin(position):
	pin = position
	Global.pin = pin

func _process(delta: float) -> void:
	var has_joypad = Input.get_connected_joypads().size() >= 1
	
	if has_joypad:
		if Input.is_action_just_pressed(Controllers.x_input) and add_pin_menu:
			pin_menu = not pin_menu
			add_pin_menu.visible = pin_menu
			if pin_menu:
				add_pin_menu.position = Vector2(992, 544)
		
		if Input.is_action_just_pressed(Controllers.y_input):
			reset_zoom()
		
		if cross_sprite:
			cross_sprite.visible = true
	else:
		if cross_sprite:
			cross_sprite.visible = false
	
func reset_zoom() -> void:
	if camera:
		var current_zoom = camera.zoom.x
		var zoom_ratio = ZOOM_DEFAULT / current_zoom
		
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(camera, "zoom", Vector2(ZOOM_DEFAULT, ZOOM_DEFAULT), 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(camera, "offset", Vector2.ZERO, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		
		var scale_factor = 1.0 / zoom_ratio
		await tween.finished
		scale_pins(scale_factor, scale_factor)

func _unhandled_input(event):
	if not event is InputEventMouseButton:
		return
	
	if add_pin_menu and not add_pin_menu.visible:
		var current_zoom = camera.zoom.x
		
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed and current_zoom < ZOOM_MAX:
			# Zoom smooth avec tween
			if zoom_tween:
				zoom_tween.kill()
			var target_zoom = camera.zoom * ZOOM_FACTOR_IN
			zoom_tween = create_tween()
			zoom_tween.tween_property(camera, "zoom", target_zoom, 0.15).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			scale_pins(SCALE_FACTOR_IN, SCALE_FACTOR_IN)
		
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed and current_zoom > ZOOM_MIN:
			# Dezoom smooth avec tween
			if zoom_tween:
				zoom_tween.kill()
			var target_zoom = camera.zoom * ZOOM_FACTOR_OUT
			zoom_tween = create_tween()
			zoom_tween.tween_property(camera, "zoom", target_zoom, 0.15).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			scale_pins(SCALE_FACTOR_OUT, SCALE_FACTOR_OUT)
		
		elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var current_time = Time.get_ticks_msec() / 1000.0
			if current_time - last_click_time < DOUBLE_CLICK_TIME:
				reset_zoom()
			last_click_time = current_time
		
		elif event.button_index == MOUSE_BUTTON_MIDDLE and event.pressed:
			reset_zoom()
			
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		if add_pin_menu:
			pin_menu = not add_pin_menu.visible
			add_pin_menu.visible = pin_menu
			# Position du menu dans l'espace écran
			add_pin_menu.position = event.position
			
			# Convertir la position souris en position monde pour placer le pin
			if camera:
				# Position souris dans le viewport
				var viewport_pos = event.position
				# Convertir en position monde en tenant compte du zoom et offset de la caméra
				var world_pos = camera.position + (viewport_pos - get_viewport_rect().size / 2) / camera.zoom + camera.offset
				# Stocker dans Global.pin_temp pour que add_pin.gd l'utilise
				Global.pin_temp = world_pos
				change_pin(world_pos)
