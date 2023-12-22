extends Node2D



func _ready():
	
	get_node("/root/main_map/CanvasLayer/Transition/AnimationPlayer").play("transition_to_screen")
	await get_tree().create_timer(0.05).timeout
	



