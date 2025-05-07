extends MarginContainer

@export var pause_menu = VBoxContainer
@export var craft_menu = VBoxContainer
@export var settings_menu = VBoxContainer
@export var controls_settings = VBoxContainer
@export var languages_settings = VBoxContainer
@export var musicsandsounds_settings = VBoxContainer
#@export var appearance_settings = VBoxContainer
@export var save_confirmation = ConfirmationDialog

# Fais apparaître / disparaitre les différents menus
func toggle_visibility(object):
	if object.visible:
		object.visible = false
	else:
		object.visible = true


#func uppercase_all_buttons(node):
	#for child in node.get_children():
		#if child is Button:
			#child.text = child.text.to_upper()
		#elif child.get_child_count() > 0:
			#uppercase_all_buttons(child)


func _ready():
	
	#uppercase_all_buttons(self)


# Languages menu
	
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
		get_node("LanguagesSettingsScreenContainer/LanguagesSettingsScreen/NinePatchRect/MarginContainer/ScrollContainer/LanguagesSettingsButtonsContainer").add_child(language_button)


func _on_languages_back_button_pressed() -> void:
	toggle_visibility(languages_settings)
	toggle_visibility(settings_menu)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in TranslationServer.get_loaded_locales():
		if get_node("LanguagesSettingsScreenContainer/LanguagesSettingsScreen/NinePatchRect/MarginContainer/ScrollContainer/LanguagesSettingsButtonsContainer/"+str(i)).button_pressed == true:
			TranslationServer.set_locale(i)
			SaveSystem.save_localisation()


# Pause menu

func _on_resume_button_pressed() -> void:
	pause_menu.visible = false
	Engine.time_scale = 1


func _on_save_button_pressed() -> void:
	save_confirmation.visible = true
	
	
func _on_save_confirmed() -> void:
	save_confirmation.visible = false
	SaveSystem.save()
	print("Sauvegarde effectuée !")


func _on_settings_button_pressed() -> void:
	toggle_visibility(pause_menu)
	toggle_visibility(settings_menu)


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")



# Settings menu

func _on_controls_button_pressed() -> void:
	toggle_visibility(settings_menu)
	toggle_visibility(controls_settings)


func _on_music_and_sounds_button_pressed() -> void:
	toggle_visibility(musicsandsounds_settings)
	toggle_visibility(settings_menu)


func _on_language_button_pressed() -> void:
	toggle_visibility(languages_settings)
	toggle_visibility(settings_menu)


func _on_settings_menu_back_button_pressed() -> void:
	toggle_visibility(settings_menu)
	toggle_visibility(pause_menu)



# Controls menu

func _on_controls_back_button_pressed() -> void:
	toggle_visibility(controls_settings)
	toggle_visibility(settings_menu)



# Musics and sounds menu

func _on_musics_and_sounds_back_button_pressed() -> void:
	toggle_visibility(musicsandsounds_settings)
	toggle_visibility(settings_menu)
