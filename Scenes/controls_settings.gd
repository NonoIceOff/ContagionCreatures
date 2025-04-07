extends Node2D


func _on_controls_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")
