extends Node2D

func _ready():

	for i in TranslationServer.get_loaded_locales():
			var language_button = Button.new()
			var color = Color(0, 0, 0) # black
			language_button.text = TranslationServer.get_language_name(i)
			language_button.add_theme_stylebox_override("normal",load("res://Thème/normal_button.tres"))
			language_button.add_theme_stylebox_override("hover",load("res://Thème/hover_button.tres"))
			language_button.add_theme_stylebox_override("pressed",load("res://Thème/pressed_button.tres"))
			#button.add_theme_stylebox_override("disabled",load("res://Thème/button_disabled.tres"))
			language_button.custom_minimum_size = Vector2(285,80)
			language_button.position = Vector2(100,100)
			language_button.add_theme_font_size_override("font_size", 40)
			language_button.add_theme_color_override("font_color", color)
			language_button.add_theme_color_override("font_hover_color", color)
			language_button.add_theme_color_override("font_focus_color", color)
			language_button.add_theme_color_override("font_pressed_color", color)
			language_button.name = str(i)
			language_button.add_to_group("buttons")
			get_node("LanguagesSettingsScreen/NinePatchRect/MarginContainer/ScrollContainer/LanguagesSettingsButtonsContainer").add_child(language_button)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in TranslationServer.get_loaded_locales():
		if get_node("LanguagesSettingsScreen/NinePatchRect/MarginContainer/ScrollContainer/LanguagesSettingsButtonsContainer/"+str(i)).button_pressed == true:
			TranslationServer.set_locale(i)
			SaveSystem.save_localisation()


func _on_languages_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")
