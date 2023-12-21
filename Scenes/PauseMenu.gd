extends Node2D


@onready var main = $"../../../../"  #path vers main_map 


func _on_reprendre_pressed():
	main.PauseMenu()



func _on_paramètres_pressed():
	var scene_source = preload("res://Scenes/settings.tscn")
	var scene_instance = scene_source.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE) 
	add_child(scene_instance)



func _on_quitter_pressed():
	get_tree().quit()
