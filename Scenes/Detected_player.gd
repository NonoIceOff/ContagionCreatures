extends Area2D

<<<<<<< HEAD
=======

>>>>>>> 7106966d40a904464f65641079c7f09d727ec6cd
var entered = false
var Key = false

func _ready():
	get_node("Label_E_Home").visible = false

<<<<<<< HEAD
=======


>>>>>>> 7106966d40a904464f65641079c7f09d727ec6cd
func _Zone_Entered(body):
	if body.is_in_group("Player_One"):
		entered = true
		get_node("Label_E_Home").visible = true


func _Zone_Exit(body):
	if body.is_in_group("Player_One"):
		entered = false
		get_node("Label_E_Home").visible = false

<<<<<<< HEAD
=======

>>>>>>> 7106966d40a904464f65641079c7f09d727ec6cd
func _process(delta):
	if entered == true and Key == false:
		if Input.is_action_just_pressed("ui_interact"): #and $Collision_Home.is_in_group("Player_One"):
			Global.save()
			Key = true
			get_node("/root/main_map/CanvasLayer/Transition/AnimationPlayer").play("screen_to_transition")
			print("pou")
			await get_tree().create_timer(3).timeout
			get_tree().change_scene_to_file("res://Scenes/home_of_hector.tscn")
			Key = false
<<<<<<< HEAD
=======
	
			
>>>>>>> 7106966d40a904464f65641079c7f09d727ec6cd
