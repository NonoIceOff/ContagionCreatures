extends Control


## texts = {0: {"text":"aaa"}}
var texts_to_shox = ["Bonjour jeune aventurier ! J'ai perdu quelque chose... pourrais-tu m'aider contre [tornado radius=5.0 freq=1.0 connected=1][rainbow freq=0.1 sat=0.8 val=0.8]une recompense[/rainbow][/tornado] ?",
					"Super ! Eh bien j’ai perdu mes [wave amp=50 freq=2][color=yellow]CRAMPTES[/color][/wave].\nElles sont tres importantes a mes yeux. Sans elles je ne peux plus me deplacer normalement...",
					"[shake rate=20.0 level=20 connected=1][color=purple]Le grand mechant[/color][/shake] me les a voles, ils doivent certainement etre dans un coin non eloigne de la map.",
					"Oh... reviens me voir plus tard !"]
var actual_text = 0

# Si la bulle de texte possède des choix
var has_choices = [1,0,0,0]
var choice = 0

# Les liaisons des chois avec la bulle de etxte associée
var choices_links_1 = [1,0,0,0]
var choices_links_2 = [3,0,0,0]

# Si le texte possède une suite
var text_has_suit = [1,1,-1,-1]

func _ready():
	get_node("TextsBox/Label").text = texts_to_shox[actual_text]
	get_node("TextsBox/Label").visible_ratio = 0


func _process(delta):
	if get_node("TextsBox/Label").visible_ratio == 1:
		if actual_text < texts_to_shox.size():
			if has_choices[actual_text] == 0:
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
		if has_choices[actual_text] == 0:
			actual_text += 1
			if actual_text < texts_to_shox.size():
				if text_has_suit[actual_text-1] != -1:
					get_node("TextsBox/Label").visible_ratio = 0
					get_node("TextsBox/Label").text = texts_to_shox[actual_text]
				else:
					visible = false
			else:
				visible = false
		else:
			if choice == 0:
				actual_text = choices_links_1[actual_text]
				get_node("TextsBox/Label").text = texts_to_shox[actual_text]
				get_node("TextsBox/Label").visible_ratio = 0
			elif choice == 1:
				actual_text = choices_links_2[actual_text]
				get_node("TextsBox/Label").text = texts_to_shox[actual_text]
				get_node("TextsBox/Label").visible_ratio = 0
			
	if Input.is_action_just_pressed("ui_down") and choice < 1:
		get_node("TextsBox/Choices").position.y += 28
		choice += 1
	if Input.is_action_just_pressed("ui_up") and choice > 0:
		get_node("TextsBox/Choices").position.y -= 28
		choice -= 1
