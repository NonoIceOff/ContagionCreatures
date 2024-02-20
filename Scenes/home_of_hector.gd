extends Node2D

<<<<<<< HEAD
=======


>>>>>>> 7106966d40a904464f65641079c7f09d727ec6cd
func _ready():
	
	get_node("/root/HomeOfHector/CanvasLayer/Transition/AnimationPlayer").play("transition_to_screen")
	await get_tree().create_timer(0.3).timeout
<<<<<<< HEAD
	get_node("Control").visible = true	
=======
	get_node("Control").visible = true
	



>>>>>>> 7106966d40a904464f65641079c7f09d727ec6cd

func _process(delta):
	pass
