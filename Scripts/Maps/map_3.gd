extends Node2D

@onready var transition_scene = $ui/Transition/AnimationPlayer
@onready var soundEffect = $SoundEffectFx
@onready var label_home = $TileMap/house/AreaHome/Label_E_Home
@onready var player_light = $TileMap/Player_One/PointLight2D
@onready var shineStar1 = $AnimatedShineStar



var entered = false
var Key = false
var scene_load = false
var camera = []

func _ready() -> void:
	shineStar1.play()
	
	Global.current_map = self.name
	SaveSystem.load_position()
	
	Quests.init_pnj("Map3")
	
	label_home.visible = false
	transition_scene.play("transition_to_screen")
	await get_tree().create_timer(0.3).timeout
	soundEffect.play()
	camera = get_tree().get_nodes_in_group("camera")
	#Global.smooth_zoom(camera[0], 1.5, Vector2(1150, 650),0.01)

var camera_id = 0
func _process(_delta: float) -> void:
	camera = get_tree().get_nodes_in_group("camera")

	
	
	match Global.tutorial_stade:
		6:
			await get_tree().create_timer(2).timeout
			Global.tutorial_stade = 7
		7:
			await get_tree().create_timer(2).timeout
			Global.tutorial_stade = 8
			
				
	if Global.current_hour == 20 and Global.current_minute == 0:
		soundEffect.stream = load("res://Sounds/music/night_sound.mp3")
		soundEffect.play()
	if Global.current_hour == 6 and Global.current_minute == 0:
		soundEffect.stream = load("res://Sounds/Kings_Castle_-_Fantasy_Music_Musique_Fantastique_Musique_Libre_de_Droit.mp3")
		soundEffect.play()
	var joypads = Input.get_connected_joypads()
	# Interaction avec la maison
	if Input.is_action_just_pressed("M"):
		if scene_load == false:
			var load_scene = preload("res://Scenes/Full_Screen_map.tscn")
			var load_instance = load_scene.instantiate()
			load_instance.position = Vector2(0,0)
			get_node("ui/Minimap").visible = false
			get_node("ui").add_child(load_instance)
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			
			scene_load = true

		elif scene_load == true:
			get_node("ui/Full_Screen_map").queue_free()
			get_node("ui/Minimap").visible = true
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
