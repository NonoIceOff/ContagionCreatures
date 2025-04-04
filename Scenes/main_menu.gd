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


func _on_profile_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/profil.tscn")


func _on_instagram_button_pressed() -> void:
	OS.shell_open("https://www.instagram.com/contagion_creatures/")


func _on_discord_button_pressed() -> void:
	OS.shell_open("https://discord.gg/JSyQFFEqaS")
