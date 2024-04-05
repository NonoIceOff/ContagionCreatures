extends Button


func _on_pressed():
	var scene_source = preload("res://Scenes/scene_Choose_ATT.tscn")
	var scene_instance = scene_source.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	get_parent().add_child(scene_instance)

func _on_button_pressed():
	var scene_source = preload("res://Scenes/scene_Choose_Items.tscn")
	var scene_instance = scene_source.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	get_parent().add_child(scene_instance)


func _on_button_2_pressed():
	var scene_source = preload("res://Scenes/leave_fight.tscn")
	var scene_instance = scene_source.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE) 
	get_parent().add_child(scene_instance)
