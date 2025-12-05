extends Node2D

func _on_tree_entered() -> void:
	Global.selected_index = 0


func _on_controls_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/controls_settings.tscn")


func _on_language_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/languages.tscn")


func _on_appearance_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/videosettings.tscn")


func _on_music_and_sound_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/musicsandsounds.tscn")


func _on_settings_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
