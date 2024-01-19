extends Node2D

var entered = false


func _ready():
	get_node("/root/map2/CanvasLayer2/Transition/AnimationPlayer").play("transition_to_screen")
	await get_tree().create_timer(0.05).timeout



func _process(delta):
	pass


func _on_leave_to_map_1_body_entered(body):
	entered = false
	if body.is_in_group("Player_One"):
		entered = true
		get_node("/root/main_map/CanvasLayer/Transition/AnimationPlayer").play("screen_to_transition")
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://Scenes/main_map.tscn")


func _on_enter_home_map_2_body_entered(body):
	pass # change scene to the house of the Map2


func _on_enter_donjon_body_entered(body):
	entered = false
	if body.is_in_group("Player_One"):
		entered = true
		get_node("/root/map2/CanvasLayer2/Transition/AnimationPlayer").play("screen_to_transition")
		await get_tree().create_timer(0.2).timeout
		get_tree().change_scene_to_file("res://Scenes/home_of_hector.tscn")
	
