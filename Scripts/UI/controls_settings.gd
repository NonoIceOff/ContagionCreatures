extends Node2D

var change_key: String = ""
var change_key_state: bool = false

# Liste des touches modifiables
var can_modify_keys := [
	"ui_interact", "i", "haut", "bas", "droite", "gauche",
	"chat", "échap", "q", "Spell_1", "Spell_2", "Spell_3",
	"Spell_4", "attack_barre", "Space", "ui_x", "Sprint", "ui_p"
]

func _ready():
	var container = get_node("ControlsSettingsScreenContainer/ControlsSettingsScreen/NinePatchRect/MarginContainer/ScrollContainer/ControlsSettingsButtonsContainer")
	
	for action_name in InputMap.get_actions():
		if action_name in can_modify_keys:
			var key_strings := _get_action_display_key(action_name)
			

			# Crée une ligne avec un bouton pour chaque événement
			var hbox := HBoxContainer.new()
			hbox.name = action_name + "Container"
			hbox.custom_minimum_size = Vector2(1280, 0)
			hbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
			hbox.size_flags_horizontal = Control.SIZE_EXPAND
			container.add_child(hbox)

			var label := Label.new()
			label.name = action_name + "Label"
			label.text = action_name
			label.add_theme_font_size_override("font_size", 64)
			hbox.add_child(label)

			var spacer := Control.new()
			spacer.size_flags_horizontal = Control.SIZE_EXPAND
			hbox.add_child(spacer)

			# Crée un bouton pour chaque événement associé à l'action
			for key_string in key_strings:
				var button := Button.new()
				button.name = action_name + "Button_" + key_string
				button.text = key_string
				button.add_theme_font_size_override("font_size", 46)
				button.pressed.connect(_on_key_button_pressed.bind(button))
				button.set_meta("action_name", action_name)
				button.set_meta("key_string", key_string)
				hbox.add_child(button)

func _get_action_display_key(action_name: String) -> Array:
	var events := InputMap.action_get_events(action_name)
	if events.is_empty():
		return ["[None]"]
	
	var key_strings := []

	for e in events:
		# Pour les touches du clavier
		if e is InputEventKey and e.keycode > 0:
			var key_name = OS.get_keycode_string(e.keycode)
			var display_name = "[" + key_name + "]"
			key_strings.append(display_name)

		# Pour les boutons de manette
		elif e is InputEventJoypadButton:
			var button_name = "Joypad Button " + str(e.button_index)
			var device_name = Input.get_joy_name(e.device) if e.device > 0 else "Tous les périphériques"
			var display_name = "[" + button_name + " (" + device_name + ")]"
			key_strings.append(display_name)

		# Pour les boutons de souris
		elif e is InputEventMouseButton:
			var mouse_button_name = "Mouse Button " + str(e.button_index)
			key_strings.append("[" + mouse_button_name + "]")

		# Pour les mouvements d'axe de joystick
		elif e is InputEventJoypadMotion:
			var axis_name = "Joypad Axis " + str(e.axis)
			key_strings.append("[" + axis_name + " (" + str(e.axis_value) + ")]")

	# Concatène toutes les touches/boutons associés en une seule chaîne
	if key_strings.is_empty():
		return ["[Unbound]"]
	
	# Joint tous les éléments dans un seul string avec espace
	return [" ".join(key_strings)]


func _on_key_button_pressed(button: Button) -> void:
	change_key = button.get_meta("action_name")
	change_key_state = true
	button.text = "_"

func _input(event):
	if change_key_state:
		var event_to_store: InputEvent = null
		var display_name := ""

		if event is InputEventKey and event.pressed and event.keycode > 0:
			event_to_store = event
			display_name = "Key " + OS.get_keycode_string(event.keycode)
		elif event is InputEventJoypadButton and event.pressed:
			event_to_store = event
			display_name = "Joypad Button " + str(event.button_index)
		elif event is InputEventMouseButton and event.pressed:
			event_to_store = event
			display_name = "Mouse Button " + str(event.button_index)
		elif event is InputEventJoypadMotion and event.pressed:
			event_to_store = event
			display_name = "Joypad Axis " + str(event.axis) + " (" + str(event.axis_value) + ")"

		if event_to_store != null:
			InputMap.action_erase_events(change_key)
			InputMap.action_add_event(change_key, event_to_store)

			# Met à jour tous les boutons pour cette action
			var container := get_node("ControlsSettingsScreenContainer/ControlsSettingsScreen/NinePatchRect/MarginContainer/ScrollContainer/ControlsSettingsButtonsContainer")
			for hbox in container.get_children():
				for button in hbox.get_children():
					if button is Button and button.get_meta("key_string") == display_name:
						button.text = display_name
						break

			change_key_state = false

func _on_controls_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")
