extends Node2D

func _ready() -> void:
	SaveSystem.load_other_parameters()
	get_node("MusicsAndSoundsSettingsScreenContainer/MusicsAndSoundsSettingsScreen/NinePatchRect/MarginContainer/ScrollContainer/MusicsAndSoundsContainer/ChronoSpeedrun").button_pressed = Global.is_speedrun_timer
	get_node("MusicsAndSoundsSettingsScreenContainer/MusicsAndSoundsSettingsScreen/NinePatchRect/MarginContainer/ScrollContainer/MusicsAndSoundsContainer/MiniMap").button_pressed = Global.is_minimap
	get_node("MusicsAndSoundsSettingsScreenContainer/MusicsAndSoundsSettingsScreen/NinePatchRect/MarginContainer/ScrollContainer/MusicsAndSoundsContainer/EternalDay").button_pressed = Global.is_eternal_day
	get_node("MusicsAndSoundsSettingsScreenContainer/MusicsAndSoundsSettingsScreen/NinePatchRect/MarginContainer/ScrollContainer/MusicsAndSoundsContainer/DayCycle").button_pressed = Global.is_daycycle

func _process(delta: float) -> void:
	Global.is_speedrun_timer = get_node("MusicsAndSoundsSettingsScreenContainer/MusicsAndSoundsSettingsScreen/NinePatchRect/MarginContainer/ScrollContainer/MusicsAndSoundsContainer/ChronoSpeedrun").button_pressed
	Global.is_minimap = get_node("MusicsAndSoundsSettingsScreenContainer/MusicsAndSoundsSettingsScreen/NinePatchRect/MarginContainer/ScrollContainer/MusicsAndSoundsContainer/MiniMap").button_pressed
	Global.is_eternal_day = get_node("MusicsAndSoundsSettingsScreenContainer/MusicsAndSoundsSettingsScreen/NinePatchRect/MarginContainer/ScrollContainer/MusicsAndSoundsContainer/EternalDay").button_pressed
	Global.is_daycycle = 	get_node("MusicsAndSoundsSettingsScreenContainer/MusicsAndSoundsSettingsScreen/NinePatchRect/MarginContainer/ScrollContainer/MusicsAndSoundsContainer/DayCycle").button_pressed

func _on_musics_and_sounds_back_button_pressed() -> void:
	SaveSystem.save_other_parameters()
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")
