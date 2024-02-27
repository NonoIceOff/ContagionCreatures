extends Label

var hue = 0.0

func _physics_process(delta):
	set("theme_override_colors/font_outline_color", Color.from_hsv(hue, 1.0, 1.0, 1.0) )
	if hue < 1.0:
		hue += 0.001
	else:
		hue = 0.0

func _on_reprendre_pressed():
	pass # Replace with function body.
