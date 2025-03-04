extends Node

var a_input = "ui_interact"
var b_input = "ui_cancel"
var x_input = "ui_x"
func _ready() -> void:
	var joypads = Input.get_connected_joypads()
	if joypads.size() >= 1:
		var joy_name = Input.get_joy_name(joypads[0])
		if joy_name.contains("Xbox"):
			b_input = "ui_interact"
			a_input = "ui_cancel"
			x_input = "ui_select"




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
