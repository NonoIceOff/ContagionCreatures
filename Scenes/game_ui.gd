extends MarginContainer

@export var pause_menu = VBoxContainer
@export var craft_menu = VBoxContainer
@export var settings_menu = VBoxContainer
@export var controls_settings = VBoxContainer


func toggle_visibility(object):
	if object.visible:
		object.visible = false
	else:
		object.visible = true




# Pause menu

func _on_play_button_pressed() -> void:
	pass


func _on_save_button_pressed() -> void:
	pass


func _on_settings_button_pressed() -> void:
	pass


func _on_mainmenu_button_pressed() -> void:
	pass



# Settings menu

func _on_controls_button_pressed() -> void:
	pass


func _on_appearance_button_pressed() -> void:
	pass


func _on_language_button_pressed() -> void:
	pass


func _on_settings_menu_back_button_pressed() -> void:
	pass



# Controls menu

func _on_controls_up_button_pressed() -> void:
	pass


func _on_controls_down_button_pressed() -> void:
	pass


func _on_controls_left_button_pressed() -> void:
	pass


func _on_controls_right_button_pressed() -> void:
	pass


func _on_controls_back_button_pressed() -> void:
	pass


func _on_controls_quests_button_pressed() -> void:
	pass


func _on_controls_map_button_pressed() -> void:
	pass


func _on_controls_inventory_button_pressed() -> void:
	pass


func _on_controls_interact_button_pressed() -> void:
	pass