extends Node2D

var scene = preload("res://Scenes/piano.tscn")
var piano_in = false

var creatures = []
var creatures_starter = []

@onready var interact_piano = $Piano1/Interact
@onready var transition_scene = $ui/Transition/AnimationPlayer
@onready var ui_node = $ui
@onready var control = $Control

func _ready():
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_on_request_completed"))
	http_request.request("https://contagioncreaturesapi.vercel.app/api/creatures")
	
	Global.current_map = "HomeOfHector"
	Quests.init_pnj("HomeOfHector")
	
	
	var joypads = Input.get_connected_joypads()
	if joypads.size() < 1:
		get_node("Area2D/Label_E").texture = load("res://Textures/Buttons/keyboard/keyboard_e.png")
		get_node("Piano1/Interact").texture = load("res://Textures/Buttons/keyboard/keyboard_e.png")
	else:
		get_node("Area2D/Label_E").texture = load(Controllers.a_texture)
		get_node("Piano1/Interact").texture = load(Controllers.a_texture)
		
	transition_scene.play("transition_to_screen")


	$ui/Transition/AnimationPlayer.play("transition_to_screen")

	await get_tree().create_timer(0.3).timeout
	control.visible = true
	
	


func _process(_delta: float) -> void:
	get_node("CanvasJour_Nuit").visible = false
	if Input.is_action_just_pressed(Controllers.a_input) and piano_in == true:
		var instance = scene.instantiate()
		instance.piano_id = 0
		ui_node.add_child(instance)
		
	match int(Global.tutorial_stade):
		10:
			get_node("Control/MobChoose").visible = true
		11:
			get_node("Control/MobChoose").visible = false

func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var response_text = body.get_string_from_utf8()
		var parse_result = JSON.parse_string(response_text)
		creatures = parse_result
		for i in range(1,4):
			var random = randi_range(0,creatures.size()-1)
			creatures_starter.append(creatures[random]["id"])
			get_node("Control/MobChoose/"+str(i)).texture = load("res://Textures/Animals/"+str(creatures[random]["texture"]))
			print("res://Textures/Animals/"+str(creatures[random]["texture"]))
		Global.starters_id = creatures_starter
	else:
		print("Failed to fetch creatures: ", response_code)
		
func _on_piano_1_body_entered(body):
	if body.is_in_group("Player_One"):
		interact_piano.visible = true
		piano_in = true

func _on_piano_1_body_exited(body):
	if body.is_in_group("Player_One"):
		interact_piano.visible = false
		piano_in = false
