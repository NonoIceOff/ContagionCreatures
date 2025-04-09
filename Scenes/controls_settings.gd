extends Node2D

var change_key = ""
var change_key_state = 0

func _ready():
	show_keys()
	
func show_keys():
	var action_events = InputMap.action_get_events("ui_up")[0]
	var KeyCode = action_events.keycode
	var KeyString = OS.get_keycode_string(KeyCode)
	print(KeyString)
	get_node("ControlsSettingsScreenContainer/ControlsSettingsScreen/NinePatchRect/MarginContainer/ScrollContainer/ControlsSettingsButtonsContainer/ControlsUpContainer/ControlsUpButton").text = KeyString
	
	action_events = InputMap.action_get_events("ui_down")[0]
	KeyCode = action_events.keycode
	KeyString = OS.get_keycode_string(KeyCode)
	print(KeyString)
	get_node("ControlsSettingsScreenContainer/ControlsSettingsScreen/NinePatchRect/MarginContainer/ScrollContainer/ControlsSettingsButtonsContainer/ControlsDownContainer/ControlsDownButton").text = KeyString
	
	action_events = InputMap.action_get_events("ui_left")[0]
	KeyCode = action_events.keycode
	KeyString = OS.get_keycode_string(KeyCode)
	print(KeyString)
	get_node("ControlsSettingsScreenContainer/ControlsSettingsScreen/NinePatchRect/MarginContainer/ScrollContainer/ControlsSettingsButtonsContainer/ControlsLeftContainer/ControlsLeftButton").text = KeyString
	
	action_events = InputMap.action_get_events("ui_right")[0]
	KeyCode = action_events.keycode
	KeyString = OS.get_keycode_string(KeyCode)
	print(KeyString)
	get_node("ControlsSettingsScreenContainer/ControlsSettingsScreen/NinePatchRect/MarginContainer/ScrollContainer/ControlsSettingsButtonsContainer/ControlsRightContainer/ControlsRightButton").text = KeyString
	
	#action_events = InputMap.action_get_events("ui_interact")[0]
	#KeyCode = action_events.keycode
	#KeyString = OS.get_keycode_string(KeyCode)
	#print(KeyString)
	#get_node("ControlsSettingsScreenContainer/ControlsSettingsScreen/NinePatchRect/MarginContainer/ScrollContainer/ControlsSettingsButtonsContainer/ControlsInteractContainer/ControlsInteractButton").text = KeyString

func _input(event):
	if event is InputEventKey:
		if change_key_state == 1:
			if change_key == "ui_up":
				var KeyCode = event.keycode
				var KeyString = OS.get_keycode_string(KeyCode)
				get_node("ControlsSettingsScreenContainer/ControlsSettingsScreen/NinePatchRect/MarginContainer/ScrollContainer/ControlsSettingsButtonsContainer/ControlsUpContainer/ControlsUpButton").text = str(KeyString)
				InputMap.action_erase_events("ui_up")
				InputMap.action_add_event("ui_up", event)
			elif change_key == "ui_down":
				var KeyCode = event.keycode
				var KeyString = OS.get_keycode_string(KeyCode)
				get_node("ControlsSettingsScreenContainer/ControlsSettingsScreen/NinePatchRect/MarginContainer/ScrollContainer/ControlsSettingsButtonsContainer/ControlsDownContainer/ControlsDownButton").text = str(KeyString)
				InputMap.action_erase_events("ui_down")
				InputMap.action_add_event("ui_down", event)
			elif change_key == "ui_left":
				var KeyCode = event.keycode
				var KeyString = OS.get_keycode_string(KeyCode)
				get_node("ControlsSettingsScreenContainer/ControlsSettingsScreen/NinePatchRect/MarginContainer/ScrollContainer/ControlsSettingsButtonsContainer/ControlsLeftContainer/ControlsLeftButton").text = str(KeyString)
				InputMap.action_erase_events("ui_left")
				InputMap.action_add_event("ui_left", event)
			elif change_key == "ui_right":
				var KeyCode = event.keycode
				var KeyString = OS.get_keycode_string(KeyCode)
				get_node("ControlsSettingsScreenContainer/ControlsSettingsScreen/NinePatchRect/MarginContainer/ScrollContainer/ControlsSettingsButtonsContainer/ControlsRightContainer/ControlsRightButton").text = str(KeyString)
				InputMap.action_erase_events("ui_right")
				InputMap.action_add_event("ui_right", event)
			#elif change_key == "ui_interact":
				#var KeyCode = event.keycode
				#var KeyString = OS.get_keycode_string(KeyCode)
				#get_node("ControlsSettingsScreenContainer/ControlsSettingsScreen/NinePatchRect/MarginContainer/ScrollContainer/ControlsSettingsButtonsContainer/ControlsInteractContainer/ControlsInteractButton").text = str(KeyString)
				#InputMap.action_erase_events("ui_interact")
				#InputMap.action_add_event("ui_interact", event)
			change_key_state = 0



func _on_controls_up_button_pressed() -> void:
	get_node("ControlsSettingsScreenContainer/ControlsSettingsScreen/NinePatchRect/MarginContainer/ScrollContainer/ControlsSettingsButtonsContainer/ControlsUpContainer/ControlsUpButton").text = "_"
	change_key = "ui_up"
	change_key_state = 1
	

func _on_controls_down_button_pressed() -> void:
	get_node("ControlsSettingsScreenContainer/ControlsSettingsScreen/NinePatchRect/MarginContainer/ScrollContainer/ControlsSettingsButtonsContainer/ControlsDownContainer/ControlsDownButton").text = "_"
	change_key = "ui_down"
	change_key_state = 1


func _on_controls_left_button_pressed() -> void:
	get_node("ControlsSettingsScreenContainer/ControlsSettingsScreen/NinePatchRect/MarginContainer/ScrollContainer/ControlsSettingsButtonsContainer/ControlsLeftContainer/ControlsLeftButton").text = "_"
	change_key = "ui_left"
	change_key_state = 1


func _on_controls_right_button_pressed() -> void:
	get_node("ControlsSettingsScreenContainer/ControlsSettingsScreen/NinePatchRect/MarginContainer/ScrollContainer/ControlsSettingsButtonsContainer/ControlsRightContainer/ControlsRightButton").text = "_"
	change_key = "ui_right"
	change_key_state = 1


func _on_controls_interact_button_pressed() -> void:
	get_node("ControlsSettingsScreenContainer/ControlsSettingsScreen/NinePatchRect/MarginContainer/ScrollContainer/ControlsSettingsButtonsContainer/ControlsInteractContainer/ControlsInteractButton").text = "_"
	change_key = "ui_interact"
	change_key_state = 1


func _on_controls_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")
