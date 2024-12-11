extends Node2D

@onready var transition_scene = $ui/Transition/AnimationPlayer
@onready var soundEffect = $SoundEffectFx

@onready var label_home = $TileMap/house/AreaHome/Label_E_Home
var entered = false
var Key = false
var scene_load = false

func _ready() -> void:
	label_home.visible = false
	transition_scene.play("transition_to_screen")
	await get_tree().create_timer(0.3).timeout
	soundEffect.play()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("M"):
		print("test")
		if scene_load == false:
			var load_scene = preload("res://Scenes/Full_screen_map.tscn")
			var load_instance = load_scene.instantiate()
			load_instance.position = Vector2(0,0)
			get_node("ui/Minimap").visible = false
			get_node("ui").add_child(load_instance)
			
			scene_load = true

		elif scene_load == true:
			get_node("ui/Full_Screen_map").queue_free()
			get_node("ui/Minimap").visible = true
			scene_load = false

	if entered == true and Key == false:
		if Input.is_action_just_pressed("ui_interact"):
			Global.save()
			Key = true
			transition_scene.play("screen_to_transition")
			await get_tree().create_timer(3).timeout
			get_tree().change_scene_to_file("res://Scenes/home_of_hector.tscn")
			Key = false

func _Zone_Entered(body):
	if body.is_in_group("Player_One"):
		entered = true
		label_home.visible = true

func _Zone_Exit(body):
	if body.is_in_group("Player_One"):
		entered = false
		label_home.visible = false
