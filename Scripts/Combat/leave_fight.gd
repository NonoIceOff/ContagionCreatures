extends Node2D



func YesLeave():
	get_tree().change_scene_to_file("res://Scenes/Maps/main_map.tscn")
	

func _on_button_2_pressed():
	queue_free()
	
	

