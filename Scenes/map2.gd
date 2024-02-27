extends Node2D

var entered = false


func _ready():
	get_node("/root/map2/ui/Transition/AnimationPlayer").play("transition_to_screen")
	await get_tree().create_timer(0.05).timeout



func _process(delta):
	pass


func _on_leave_to_map_1_body_entered(body):
	entered = false
	if body.is_in_group("Player_One"):
		entered = true
		get_node("ui/Transition/AnimationPlayer").play("screen_to_transition")
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://Scenes/main_map.tscn")


func _on_enter_home_map_2_body_entered(body):
	pass # change scene to the house of the Map2


func _on_enter_donjon_body_entered(body):
	entered = false
	if body.is_in_group("Player_One"):
		entered = true
		get_node("/root/map2/ui/Transition/AnimationPlayer").play("screen_to_transition")
		await get_tree().create_timer(0.2).timeout
		var random = randi_range(0,1)
		if random == 0:
			get_tree().change_scene_to_file("res://Scenes/dungeon1.tscn")
		if random == 1:
			get_tree().change_scene_to_file("res://Scenes/dungeon_enigme.tscn")
	
