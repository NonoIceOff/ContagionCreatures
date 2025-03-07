extends Node

var a_input = "ui_interact"
var b_input = "ui_cancel"
var x_input = "ui_x"

var a_texture = "res://Textures/Buttons/joypads/joybar_a.png"
var b_texture = "res://Textures/Buttons/joypads/joybar_b.png"
var x_texture = "res://Textures/Buttons/joypads/joybar_x.png"
var y_texture = "res://Textures/Buttons/joypads/joybar_y.png"

func _ready() -> void:
	var joypads = Input.get_connected_joypads()
	if joypads.size() >= 1:
		var joy_name = Input.get_joy_name(joypads[0])
		if joy_name.contains("Xbox"):
			b_input = "ui_interact"
			a_input = "ui_cancel"
			x_input = "ui_select"
		if joy_name.contains("PS"):
			a_texture = "res://Textures/Buttons/joypads/joybars_o.png"
			b_texture = "res://Textures/Buttons/joypads/joybars_xps.png"
			x_texture = "res://Textures/Buttons/joypads/joybars_triangle.png"
			y_texture = "res://Textures/Buttons/joypads/joybars_square.png"




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
