extends Control

var dialogue_scene = preload("res://Scenes/dialogue.tscn") 
var in_area = false
var enemy_instance = null
var pnj_name = ""
var quest_id = 0
var quest_stade = 0

var over_texture = ""
var under_texture = ""

var dialogue_data = []

func _ready() -> void:
	get_node("Area2D/CharacterBody2D/Over").texture = load(over_texture)
	get_node("Area2D/CharacterBody2D/Over/Under").texture = load(under_texture)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player_One":
		Global.interact = true
		get_node("Area2D/Interact").visible = true
		in_area = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player_One":
		Global.interact = false
		get_node("Area2D/Interact").visible = false
		in_area = false
		
func _process(delta: float) -> void:
	var joypads = Input.get_connected_joypads()
	if joypads.size() < 1:
		get_node("Area2D/Interact").texture = load("res://Textures/Buttons/keyboard/keyboard_e.png")
	else:
		get_node("Area2D/Interact").texture = load(Controllers.a_texture)
	if Quests.quests.get(quest_id).stade == Quests.quests.get(quest_id).descriptions.size():
		queue_free()
	if Input.is_action_just_pressed(Controllers.a_input) and in_area == true and enemy_instance == null:
		Quests.current_quest_id = quest_id
		enemy_instance = dialogue_scene.instantiate()
		enemy_instance.pnj_name = pnj_name
		enemy_instance.dialogues = dialogue_data
		enemy_instance.contafont_mode = Quests.quests.get(quest_id).contafont_mode
		add_child(enemy_instance)
		enemy_instance.start_dialogue(dialogue_data)
