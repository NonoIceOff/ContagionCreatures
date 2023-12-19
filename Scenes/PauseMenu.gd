extends Node2D


@onready var main = $"../"  #path vers main_map 

func _on_reprendre_pressed():
	main.PauseMenu()



func _on_paramètres_pressed():
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")



func _on_quitter_pressed():
	get_tree().quit()
