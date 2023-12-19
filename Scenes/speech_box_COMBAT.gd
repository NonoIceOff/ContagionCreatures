extends Control

var texts = {}

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
		if texts.size() > actual_text:
			if not texts[actual_text]["has_choices"]:
				get_node("TextsBox/Label").visible_ratio = 0
				visible = true
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
	visible = true
	if texts.size() > actual_text-1:
		if texts.size() != actual_text:
			display_text()
		else:
			visible = false
			if get_node("/root/SceneCombat").turn == 0:
				get_node("/root/SceneCombat").turn = 1
			elif get_node("/root/SceneCombat").turn == 2:
				get_node("/root/SceneCombat").turn = 0
	else:
		visible = false

func handle_choice():
	if choice == 0:
		actual_text = texts[actual_text]["choices_jump_to"][0]
	elif choice == 1:
		actual_text = texts[actual_text]["choices_jump_to"][1]
	
	display_text()
