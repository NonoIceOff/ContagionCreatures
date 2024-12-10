extends Node2D


var piano_in = false
var scene = preload("res://Scenes/piano.tscn")
@onready var interact_piano = $Piano1/Interact
@onready var transition_scene = $ui/Transition/AnimationPlayer
@onready var ui_node = $ui

func _ready():
	Global.current_map = "HomeOfHector"
	$ui/Transition/AnimationPlayer.play("transition_to_screen")
	await get_tree().create_timer(0.3).timeout
	get_node("Control").visible = true
	


func _process(delta):
	if Input.is_action_just_pressed("ui_interact") and piano_in == true:
		var instance = scene.instantiate()
		instance.piano_id = 0
		ui_node.add_child(instance)

func _on_piano_1_body_entered(body):
	if body.is_in_group("Player_One"):
		interact_piano.visible = true
		piano_in = true

func _on_piano_1_body_exited(body):
	if body.is_in_group("Player_One"):
		interact_piano.visible = false
		piano_in = false
