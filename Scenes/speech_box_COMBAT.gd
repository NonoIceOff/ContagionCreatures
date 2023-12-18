extends Control

var texts = {
	0: {
		"text": "a",
		"has_choices": false,
		"text_choices": ["Oui", "Non"],
		"has_suite": true,
		"choices_jump_to": [0, 0]
	},
	1: {
		"text": "bloublou",
		"has_choices": false,
		"text_choices": ["Oui", "Non"],
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
			if not texts[actual_text]["has_choices"]:
				get_node("TextsBox/Next").visible = true
			else:
				get_node("TextsBox/Choices").visible = true
				get_node("TextsBox/ChoicesTexts").visible = true
	else:
		get_node("TextsBox/Label").visible_ratio += 0.01
		get_node("TextsBox/Next").visible = false
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
	else:
		visible = false

func handle_choice():
	if choice == 0:
		actual_text = texts[actual_text]["choices_jump_to"][0]
	elif choice == 1:
		actual_text = texts[actual_text]["choices_jump_to"][1]
	
	display_text()
