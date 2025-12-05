#SCRIPT INUTILE A SUPPRIMER PLUS TARD

extends Area2D
var entered = false
var Key = false

var trade_scene = preload("res://Scenes/trade.tscn")

func _ready():
	get_node("Label_E_Home").visible = false
	var joypads = Input.get_connected_joypads()
	if joypads.size() < 1:
		get_node("Label_E_Home").texture = load("res://Textures/Buttons/keyboard/keyboard_e.png")
	else:
		get_node("Label_E_Home").texture = load(Controllers.a_texture)

func _Zone_Entered(body):
	if body.is_in_group("Player_One"):
		entered = true
		get_node("Label_E_Home").visible = true

func _Zone_Exit(body):
	if body.is_in_group("Player_One"):
		entered = false
		get_node("Label_E_Home").visible = false

func _process(delta):
	if entered == true and Key == false:
		if Input.is_action_just_pressed(Controllers.a_input):
			Key = true
			var instance = trade_scene.instantiate()
			get_node("../../ui").add_child(instance)
			Key = false
