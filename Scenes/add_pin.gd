extends Panel

func _on_add_blue_pressed() -> void:
	Global.pinb = Global.pin_temp*2+Vector2(316,316)
	get_node("../../SubViewportContainer/SubViewport/Camera2D/PinBlue").position = Global.pinb
	get_node("../../SubViewportContainer/SubViewport/Camera2D/PinBlue").visible = true
	visible = false
	get_node("../../CanvasLayer/PinBlue").modulate = Color(0.2,0.2,0.2,1)
	get_node("../../CanvasLayer/PinBlue/CPUParticles2D").visible = false
	get_node("../../Sound").playing = true


func _on_add_red_pressed() -> void:
	Global.pinr = Global.pin_temp*2+Vector2(316,316)
	get_node("../../SubViewportContainer/SubViewport/Camera2D/PinRed").position = Global.pinr
	get_node("../../SubViewportContainer/SubViewport/Camera2D/PinRed").visible = true
	visible = false
	get_node("../../CanvasLayer/PinRed").modulate = Color(0.2,0.2,0.2,1)
	get_node("../../CanvasLayer/PinRed/CPUParticles2D").visible = false
	get_node("../../Sound").playing = true


func _on_add_yellow_pressed() -> void:
	Global.piny = Global.pin_temp*2+Vector2(316,316)
	get_node("../../SubViewportContainer/SubViewport/Camera2D/PinYellow").position = Global.piny
	get_node("../../SubViewportContainer/SubViewport/Camera2D/PinYellow").visible = true
	visible = false
	get_node("../../CanvasLayer/PinYellow").modulate = Color(0.2,0.2,0.2,1)
	get_node("../../CanvasLayer/PinYellow/CPUParticles2D").visible = false
	get_node("../../Sound").playing = true


func _on_add_green_pressed() -> void:
	Global.ping = Global.pin_temp*2+Vector2(316,316)
	get_node("../../SubViewportContainer/SubViewport/Camera2D/PinGreen").position = Global.ping
	get_node("../../SubViewportContainer/SubViewport/Camera2D/PinGreen").visible = true
	visible = false
	get_node("../../CanvasLayer/PinGreen").modulate = Color(0.2,0.2,0.2,1)
	get_node("../../CanvasLayer/PinGreen/CPUParticles2D").visible = false
	get_node("../../Sound").playing = true
