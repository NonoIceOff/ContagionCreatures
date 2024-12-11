extends Area2D


var entered = false
var Key = false

func _ready():
	get_node("Label_E_Home").visible = false

func _Zone_Entered(body):
	if body.is_in_group("Player_One"):
		entered = true
		get_node("Label_E_Home").visible = true

func _Zone_Exit(body):
	if body.is_in_group("Player_One"):
		entered = false
		get_node("Label_E_Home").visible = false

func _process(delta):
	if entered == true and Key == false:
		if Input.is_action_just_pressed("ui_interact"):
			Global.save()
			Key = true
			get_node("/root/Map3/ui/Transition/AnimationPlayer").play("screen_to_transition")
			await get_tree().create_timer(3).timeout
			get_tree().change_scene_to_file("res://Scenes/home_of_hector.tscn")
			Key = false
