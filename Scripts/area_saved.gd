extends Area2D

signal save_triggered
signal saved_triggered
signal saved_outside_area

var entered = false

func _ready() -> void:
	pass

func _on_torchBody_entered(body: Node2D) -> void:
	if body.is_in_group("Player_One"):
		entered = true
		emit_signal("saved_triggered")
		var labelsaved = get_node("LabelETorcheSaved")
		if labelsaved:
			labelsaved.visible = true
		else:
			print("LabelETorcheSaved not found in areaTorche")

func _on_torchBody_exited(body: Node2D) -> void:
	if body.is_in_group("Player_One"):
		entered = false
		emit_signal("saved_outside_area")
		var label = get_node("LabelETorcheSaved")
		if label:
			label.visible = false
		else:
			print("LabelETorcheSaved not found in areaTorche")

func _process(delta: float) -> void:
	if entered:
		if Input.is_action_just_pressed(Controllers.a_input):
			SaveSystem.save()
			if Global.save:
				emit_signal("save_triggered")
