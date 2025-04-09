extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in TranslationServer.get_loaded_locales():
		var button = Button.new()
		button.text = TranslationServer.get_language_name(i)
		button.add_theme_stylebox_override("normal",load("res://Thème/normal_button.tres"))
		button.add_theme_stylebox_override("hover",load("res://Thème/hover_button.tres"))
		button.add_theme_stylebox_override("pressed",load("res://Thème/pressed_button.tres"))
		#button.add_theme_stylebox_override("disabled",load("res://Thème/button_disabled.tres"))
		button.custom_minimum_size = Vector2(280,64)
		button.position = Vector2(100,100)
		button.add_theme_font_size_override("font_size", 32)
		button.name = str(i)
		button.add_to_group("buttons")
		get_node("ScrollContainer/VBoxContainer").add_child(button)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in TranslationServer.get_loaded_locales():
		if get_node("ScrollContainer/VBoxContainer/"+str(i)).button_pressed == true:
			TranslationServer.set_locale(i)
			Global.save_localisation()


func _on_tree_entered() -> void:
	Global.selected_index = 0
