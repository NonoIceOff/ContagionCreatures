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
	get_node("ScrollContainer/VBoxContainer/Up/UpButton").text = KeyString
	
	action_events = InputMap.action_get_events("ui_down")[0]
	KeyCode = action_events.keycode
	KeyString = OS.get_keycode_string(KeyCode)
	print(KeyString)
	get_node("ScrollContainer/VBoxContainer/Down/DownButton").text = KeyString
	
	action_events = InputMap.action_get_events("ui_left")[0]
	KeyCode = action_events.keycode
	KeyString = OS.get_keycode_string(KeyCode)
	print(KeyString)
	get_node("ScrollContainer/VBoxContainer/Left/LeftButton").text = KeyString
	
	action_events = InputMap.action_get_events("ui_right")[0]
	KeyCode = action_events.keycode
	KeyString = OS.get_keycode_string(KeyCode)
	print(KeyString)
	get_node("ScrollContainer/VBoxContainer/Right/RightButton").text = KeyString

func _input(event):
	if event is InputEventKey:
		if change_key_state == 1:
			if change_key == "ui_up":
				var KeyCode = event.keycode
				var KeyString = OS.get_keycode_string(KeyCode)
				get_node("ScrollContainer/VBoxContainer/Up/UpButton").text = str(KeyString)
				InputMap.action_erase_events("ui_up")
				InputMap.action_add_event("ui_up", event)
			elif change_key == "ui_down":
				var KeyCode = event.keycode
				var KeyString = OS.get_keycode_string(KeyCode)
				get_node("ScrollContainer/VBoxContainer/Down/DownButton").text = str(KeyString)
				InputMap.action_erase_events("ui_down")
				InputMap.action_add_event("ui_down", event)
			elif change_key == "ui_left":
				var KeyCode = event.keycode
				var KeyString = OS.get_keycode_string(KeyCode)
				get_node("ScrollContainer/VBoxContainer/Left/LeftButton").text = str(KeyString)
				InputMap.action_erase_events("ui_left")
				InputMap.action_add_event("ui_left", event)
			elif change_key == "ui_right":
				var KeyCode = event.keycode
				var KeyString = OS.get_keycode_string(KeyCode)
				get_node("ScrollContainer/VBoxContainer/Right/RightButton").text = str(KeyString)
				InputMap.action_erase_events("ui_right")
				InputMap.action_add_event("ui_right", event)
			change_key_state = 0

func _on_up_button_pressed():
	get_node("ScrollContainer/VBoxContainer/Up/UpButton").text = "_"
	change_key = "ui_up"
	change_key_state = 1


func _on_down_button_pressed():
	get_node("ScrollContainer/VBoxContainer/Down/DownButton").text = "_"
	change_key = "ui_down"
	change_key_state = 1


func _on_left_button_pressed():
	get_node("ScrollContainer/VBoxContainer/Left/LeftButton").text = "_"
	change_key = "ui_left"
	change_key_state = 1


func _on_right_button_pressed():
	get_node("ScrollContainer/VBoxContainer/Right/RightButton").text = "_"
	change_key = "ui_right"
	change_key_state = 1
