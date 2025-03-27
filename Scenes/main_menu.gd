extends Node2D



func _on_multiplayer_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/multiplayer/multiplayer.tscn")


func _on_solo_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_map.tscn")


func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")


func _on_ost_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/music_playlist.tscn")


func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Credit_of_the_game.tscn")
