extends Node2D

@onready var transition_scene = $ui/Transition/AnimationPlayer
@onready var soundEffect = $SoundEffectFx
@onready var label_home = $TileMap/house/AreaHome/Label_E_Home
@onready var player_light = $TileMap/Player_One/PointLight2D
@onready var shineStar1 = $AnimatedShineStar
@onready var canvas_jour_nuit = $CanvasJour_Nuit
@onready var ui_minimap = $ui/Minimap
@onready var ui_node = $ui

var entered = false
var Key = false
var scene_load = false
var camera = []
var last_hour = -1
var last_minute = -1
var tutorial_timer_started = false

func _ready() -> void:
	if Global.is_tutorial == false:
		Global.tutorial_stade = 20
	shineStar1.play()
	soundEffect.play()
	Global.current_map = self.name
	SaveSystem.load_position()
	
	Quests.init_pnj("Map3")
	
	label_home.visible = false
	transition_scene.play("transition_to_screen")
	await get_tree().create_timer(0.3).timeout
	soundEffect.play()
	camera = get_tree().get_nodes_in_group("camera")
	#Global.smooth_zoom(camera[0], 1.5, Vector2(1150, 650),0.01)
	
	await get_tree().process_frame
	if Global.party_timer_seconds == 0:
		SaveSystem.save()

var camera_id = 0
func _process(_delta: float) -> void:
	if canvas_jour_nuit:
		var should_be_visible = !Global.is_eternal_day
		if canvas_jour_nuit.visible != should_be_visible:
			canvas_jour_nuit.visible = should_be_visible
	
	if camera.is_empty():
		camera = get_tree().get_nodes_in_group("camera")
	
	if Global.tutorial_stade == 6 and not tutorial_timer_started:
		tutorial_timer_started = true
		get_tree().create_timer(2).timeout.connect(func(): Global.tutorial_stade = 7)
	elif Global.tutorial_stade == 7 and tutorial_timer_started:
		tutorial_timer_started = false
		get_tree().create_timer(2).timeout.connect(func(): Global.tutorial_stade = 8)
	
	if Global.current_hour != last_hour or Global.current_minute != last_minute:
		if Global.current_hour == 20 and Global.current_minute == 0:
			soundEffect.stream = load("res://Sounds/music/night_sound.mp3")
			soundEffect.play()
		elif Global.current_hour == 6 and Global.current_minute == 0:
			soundEffect.stream = load("res://Sounds/Kings_Castle_-_Fantasy_Music_Musique_Fantastique_Musique_Libre_de_Droit.mp3")
			soundEffect.play()
		last_hour = Global.current_hour
		last_minute = Global.current_minute
	
	var joypads = Input.get_connected_joypads()
	# Interaction avec la maison - optimisé avec cache
	if Input.is_action_just_pressed("M"):
		if not scene_load:
			var load_scene = preload("res://Scenes/Full_Screen_map.tscn")
			var load_instance = load_scene.instantiate()
			load_instance.position = Vector2.ZERO
			if ui_minimap:
				ui_minimap.visible = false
			if ui_node:
				ui_node.add_child(load_instance)
			if joypads.size() >= 1:
				Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			scene_load = true
		else:
			var fullscreen_map = ui_node.get_node_or_null("Full_Screen_map")
			if fullscreen_map:
				fullscreen_map.queue_free()
			if ui_minimap:
				ui_minimap.visible = true
			scene_load = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if entered == true and Key == false:
		if Input.is_action_just_pressed(Controllers.a_input):
			SaveSystem.save()
			Key = true
			transition_scene.play("screen_to_transition")
			await get_tree().create_timer(3).timeout
			SceneLoader.load_scene("res://Scenes/home_of_hector.tscn")
			Key = false

func _Zone_Entered(body):
	if body.is_in_group("Player_One"):
		entered = true
		label_home.visible = true

func _Zone_Exit(body):
	if body.is_in_group("Player_One"):
		entered = false
		label_home.visible = false
