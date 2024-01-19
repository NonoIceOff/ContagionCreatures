extends Node2D


@onready var main = get_node_or_null("/root/main_map")    #path vers node map_main
#path vers main_map 
func _on_reprendre_pressed():
	main.PauseMenu()


func _on_paramètres_pressed():
	pass
	#var scene_source = preload("res://Scenes/pausesettings.tscn")
	#var scene_instance = scene_source.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE) 
	#add_child(scene_instance)


func _on_menu_principal_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func _on_quitter_pressed():
	get_tree().quit()
