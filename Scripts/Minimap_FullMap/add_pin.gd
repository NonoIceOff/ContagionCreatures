extends Panel

var selected_index = 0
var buttons = []

func _ready() -> void:
	buttons = [
		$AddBlue,
		$AddRed,
		$AddYellow,
		$AddGreen
	]
	update_button_selection()

func _process(delta: float) -> void:
	var joypads = Input.get_connected_joypads()
	if joypads.size() >= 1:
		if Input.is_action_just_pressed("ui_down"):
			selected_index = (selected_index + 1) % buttons.size()
			update_button_selection()
		if Input.is_action_just_pressed("ui_up"):
			selected_index = (selected_index - 1 + buttons.size()) % buttons.size()
			update_button_selection()
		if Input.is_action_just_pressed(Controllers.a_input):
			buttons[selected_index].emit_signal("pressed")

func update_button_selection() -> void:
	for i in range(buttons.size()):
		if i == selected_index:
			buttons[i].modulate = Color(1, 1, 1, 1)  # Highlight selected button
		else:
			buttons[i].modulate = Color(0.5, 0.5, 0.5, 1)  # Dim non-selected buttons

func _on_add_blue_pressed() -> void:
	print("blue")
	Global.pinb = Global.pin_temp * 2 + Vector2(316, 316)
	get_node("../../SubViewportContainer/SubViewport/Camera2D/PinBlue").position = Global.pinb
	get_node("../../SubViewportContainer/SubViewport/Camera2D/PinBlue").visible = true
	get_node("../../CanvasLayer/PinBlue").modulate = Color(0.2, 0.2, 0.2, 1)
	get_node("../../CanvasLayer/PinBlue/CPUParticles2D").visible = false
	get_node("../../Sound").playing = true
	hide()  # Hide the menu

func _on_add_red_pressed() -> void:
	Global.pinr = Global.pin_temp * 2 + Vector2(316, 316)
	get_node("../../SubViewportContainer/SubViewport/Camera2D/PinRed").position = Global.pinr
	get_node("../../SubViewportContainer/SubViewport/Camera2D/PinRed").visible = true
	visible = false
	get_node("../../CanvasLayer/PinRed").modulate = Color(0.2, 0.2, 0.2, 1)
	get_node("../../CanvasLayer/PinRed/CPUParticles2D").visible = false
	get_node("../../Sound").playing = true
	hide()  # Hide the menu

func _on_add_yellow_pressed() -> void:
	Global.piny = Global.pin_temp * 2 + Vector2(316, 316)
	get_node("../../SubViewportContainer/SubViewport/Camera2D/PinYellow").position = Global.piny
	get_node("../../SubViewportContainer/SubViewport/Camera2D/PinYellow").visible = true
	visible = false
	get_node("../../CanvasLayer/PinYellow").modulate = Color(0.2, 0.2, 0.2, 1)
	get_node("../../CanvasLayer/PinYellow/CPUParticles2D").visible = false
	get_node("../../Sound").playing = true
	hide()  # Hide the menu

func _on_add_green_pressed() -> void:
	Global.ping = Global.pin_temp * 2 + Vector2(316, 316)
	get_node("../../SubViewportContainer/SubViewport/Camera2D/PinGreen").position = Global.ping
	get_node("../../SubViewportContainer/SubViewport/Camera2D/PinGreen").visible = true
	visible = false
	get_node("../../CanvasLayer/PinGreen").modulate = Color(0.2, 0.2, 0.2, 1)
	get_node("../../CanvasLayer/PinGreen/CPUParticles2D").visible = false
	get_node("../../Sound").playing = true
	hide()  # Hide the menu
