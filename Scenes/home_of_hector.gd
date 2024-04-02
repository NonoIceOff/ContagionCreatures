extends Node2D

var scene = preload("res://Scenes/piano.tscn")

func _ready():
	get_node("/root/HomeOfHector/ui/Transition/AnimationPlayer").play("transition_to_screen")
	await get_tree().create_timer(0.3).timeout
	get_node("Control").visible = true
	




func _process(delta):
	if Input.is_action_just_pressed("ui_interact"):
		var instance = scene.instantiate()
		get_node("ui").add_child(instance)
		


func _on_interact_area_body_entered(body):
	if body.is_in_group("Player_One"):
		get_node("InteractArea/Interact").visible = true



func _on_interact_area_body_exited(body):
	if body.is_in_group("Player_One"):
		get_node("InteractArea/Interact").visible = false
