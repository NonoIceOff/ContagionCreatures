extends Control

var dialogue_scene = preload("res://Scenes/dialogue.tscn") 
var in_area = false
var enemy_instance = null

var dialogue_data = [
	{"text": "Bonjour, comment ça va ?", "action": "_on_dialogue_start"},
	{"text": "Je peux vous aider ?"},
	{"text": "Voulez-vous des informations ?", "choices": [
		{"text": "Oui", "response": "Voici les informations.", "action": "_on_yes_choice"},
		{"text": "Non", "response": "D'accord, à bientôt!"}
	]},
	{"text": "Fin du dialogue.", "action": "_on_dialogue_end"}
]

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
	print(in_area)

	if Input.is_action_just_pressed("ui_interact") and in_area == true and enemy_instance == null:
		print("ok")
		enemy_instance = dialogue_scene.instantiate()
		add_child(enemy_instance)
		enemy_instance.start_dialogue(dialogue_data)
