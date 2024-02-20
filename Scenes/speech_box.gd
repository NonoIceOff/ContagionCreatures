extends Control

var texts = {
	0: {
		"text": "Bonjour jeune aventurier ! J'ai perdu quelque chose... pourrais-tu m'aider contre [tornado radius=5.0 freq=1.0 connected=1][rainbow freq=0.1 sat=0.8 val=0.8]une recompense[/rainbow][/tornado] ?",
		"has_choices": true,
		"text_choices": ["Oui", "Non"],
		"has_suite": false,
		"choices_jump_to": [1, 3]
	},
	1: {
		"text": "Super ! Eh bien j’ai perdu mes [wave amp=50 freq=2][color=yellow]CRAMPTES[/color][/wave].\nElles sont très importantes à mes yeux. Sans elles, je ne peux plus me déplacer normalement...",
		"has_choices": false,
		"text_choices": [],
		"has_suite": true,
		"choices_jump_to": [2, 0]
	},
	2: {
		"text": "[shake rate=20.0 level=20 connected=1][color=purple]Le grand méchant[/color][/shake] me les a volées, ils doivent certainement être dans un coin non éloigné de la map.",
		"has_choices": false,
		"text_choices": [],
		"has_suite": true,
		"choices_jump_to": [3, 0]
	},
	3: {
		"text": "Oh... reviens me voir plus tard !",
		"has_choices": false,
		"text_choices": [],
		"has_suite": false,
		"choices_jump_to": [0, 0]
	}
}

var actual_text = 0
var choice = 0

func _ready():
	display_text()

func display_text():
	get_node("TextsBox/Label").text = texts[actual_text]["text"]
	get_node("TextsBox/Label").visible_ratio = 0

	if texts[actual_text]["has_choices"]:
		get_node("TextsBox/Choices").visible = true
		get_node("TextsBox/ChoicesTexts").visible = true
		update_choices()

func update_choices():
	var choices = texts[actual_text]["text_choices"]
	get_node("TextsBox/ChoicesTexts").text = ""
	for i in range(choices.size()):
		get_node("TextsBox/ChoicesTexts").text += choices[i]+"\n"


func _process(delta):
	if get_node("TextsBox/Label").visible_ratio == 1:
		if actual_text < texts.size():
			if not texts[actual_text]["has_choices"] && Input.is_action_just_pressed("ui_down"):
				get_node("TextsBox/Next1").visible = false
				get_node("TextsBox/Next2").visible = true
			elif not texts[actual_text]["has_choices"] && Input.is_action_just_pressed("ui_up"):
				get_node("TextsBox/Next1").visible = true
				get_node("TextsBox/Next2").visible = false
			else:
				get_node("TextsBox/Choices").visible = true
				get_node("TextsBox/ChoicesTexts").visible = true
	else:
		get_node("TextsBox/Label").visible_ratio += 0.01
		get_node("TextsBox/Next1").visible = false
		get_node("TextsBox/Next2").visible = false
		get_node("TextsBox/Choices").visible = false
		get_node("TextsBox/ChoicesTexts").visible = false

	if Input.is_action_just_pressed("ui_interact"):
		if not texts[actual_text]["has_choices"]:
			handle_next_text()
		else:
			handle_choice()

	if Input.is_action_just_pressed("ui_down") and choice < 1:
		get_node("TextsBox/Choices").position.y += 38
		choice += 1
	if Input.is_action_just_pressed("ui_up") and choice > 0:
		get_node("TextsBox/Choices").position.y -= 38
		choice -= 1

func handle_next_text():
	actual_text += 1
	if actual_text < texts.size():
		if texts[actual_text]["has_suite"]:
			display_text()
		else:
			visible = false
			queue_free()
	else:
		visible = false
		queue_free()

func handle_choice():
	if choice == 0:
		actual_text = texts[actual_text]["choices_jump_to"][0]
	elif choice == 1:
		actual_text = texts[actual_text]["choices_jump_to"][1]
	
	display_text()
