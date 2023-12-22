extends Button


func _on_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_map.tscn")
	#var scene_source = preload("res://Scenes/pausesettings.tscn")
	#var scene_instance = scene_source.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE) 
	#add_child(scene_instance)
