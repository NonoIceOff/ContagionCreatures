extends Node2D



func _ready():
	
	get_node("/root/HomeOfHector/CanvasLayer/Transition/AnimationPlayer").play("transition_to_screen")
	await get_tree().create_timer(0.3).timeout
	get_node("Control").visible = true
	




