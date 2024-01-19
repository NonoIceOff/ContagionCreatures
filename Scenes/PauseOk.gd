extends Button


func _on_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	#var scene_source = preload("res://Scenes/PauseMenu.tscn")
	#var scene_instance = scene_source.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE) 
	#add_child(scene_instance)
