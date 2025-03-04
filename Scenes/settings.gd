extends Node2D

var selected_index = 0
var buttons = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buttons = [
		$Controls,
		$Languages,
		$Appearence,
		$Retour,
	]

func _process(delta):
	print(buttons)
	var joypads = Input.get_connected_joypads()
	if joypads.size() >= 1:
		if Input.is_action_just_pressed("ui_down"):
			selected_index = (selected_index + 1) % buttons.size()
			update_button_selection()
		if Input.is_action_just_pressed("ui_up"):
			selected_index = (selected_index - 1 + buttons.size()) % buttons.size()
			update_button_selection()
		if Input.is_action_just_pressed(Controllers.a_input):
			pressed_button(buttons[selected_index])

func update_button_selection() -> void:
	for i in range(buttons.size()):
		if i == selected_index:
			buttons[i].modulate = Color(1, 1, 1, 1)  # Highlight selected button
		else:
			buttons[i].modulate = Color(0.5, 0.5, 0.5, 1)  # Dim non-selected buttons


func pressed_button(button):
	button.emit_signal("pressed")


func _on_tree_entered() -> void:
	Global.selected_index = 0
