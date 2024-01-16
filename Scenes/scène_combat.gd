extends Node2D

var speechbox =  preload("res://Scenes/speech_box_COMBAT.tscn")
var rng = RandomNumberGenerator.new()
var pv_player = 100
var pv_enemy = 100
var turn = 0 # 0 = ton tour ; 1 = le tour du méchant



var attack_index = 0
var attack_names = ["[color=red]avalanche de singes[/color]","[color=red]poele surpuissante[/color]","[color=red]dragibus noir[/color]","[color=red]douche[/color]"]
var attack_values = [11,23,2,20]


var texts_enemy = {
	0: {
		"text": "loading attack...",
		"has_choices": false,
		"text_choices": ["Oui", "Non"],
		"has_suite": true,
		"choices_jump_to": [0, 0]
	},
	1: {
		"text": "C'est a ... d'attaquer maintenant ",
		"has_choices": false,
		"text_choices": ["Oui", "Non"],
		"has_suite": false,
		"choices_jump_to": [0, 0]
	},
}

var texts_end = {
	0: {
		"text": "qui perd ?",
		"has_choices": false,
		"text_choices": ["Oui", "Non"],
		"has_suite": true,
		"choices_jump_to": [0, 0]
	},
	1: {
		"text": "xp gagné ?",
		"has_choices": false,
		"text_choices": ["Oui", "Non"],
		"has_suite": false,
		"choices_jump_to": [0, 0]
	},
}

func _ready():
	get_node("CanvasLayer/Transition/AnimationPlayer").play("transition_to_screen")
	await get_tree().create_timer(0.05).timeout

func spawn_dialogue(custom_texts):
	var dialogue = speechbox.instantiate()
	dialogue.position = Vector2(0,-380)
	dialogue.texts = custom_texts
	add_child(dialogue)

func _process(delta):
	rng.randomize()
	get_node("ContainerMob/TextureProgressBar").value = pv_enemy
	get_node("ContainerPLAYER/TextureProgressBar").value = pv_player
	
	if get_node_or_null("SpeechBox") != null:
		if get_node("SpeechBox").actual_text == 1:
			if pv_player <= 0 and pv_player > -1000:
				loose()
				turn = -1
				pv_player = -1000
			elif pv_enemy <= 0 and pv_enemy > -1000:
				win()
				turn = -1
				pv_enemy = -1000
	
	if turn == 1:
		enemy_turns()
		turn = 2
			
		


func enemy_turns():
	if get_node_or_null("SpeechBox") != null:
		attack_index = rng.randi_range(0,attack_names.size()-1)
		get_node("SpeechBox").queue_free()
		texts_enemy[0]["text"] = get_node("/root/SceneCombat/ContainerMob/Pseudo").text+" utilise "+str(attack_names[attack_index])+" et vous inflige "+str(attack_values[attack_index])+" degats."
		texts_enemy[1]["text"] = "C'est a vous "+get_node("/root/SceneCombat/ContainerPLAYER/Pseudo").text+" d'attaquer maintenant "
		get_node("/root/SceneCombat").spawn_dialogue(texts_enemy)
		pv_player -= attack_values[attack_index]
		get_node("/root/SceneCombat/AnimationPlayer").play("Damage_Player") 
		get_node("/root/SceneCombat/AnimationPlayer").play("shake") 
		await get_node("/root/SceneCombat/AnimationPlayer").animation_finished
		
func win():
	if get_node_or_null("SpeechBox") != null:
		get_node("SpeechBox").queue_free()
		texts_end[0]["text"] = get_node("/root/SceneCombat/ContainerMob/Pseudo").text+" chute !"
		texts_end[1]["text"] = "Vous remportez le combat et 0 xp !"
		get_node("/root/SceneCombat").spawn_dialogue(texts_end)
		get_node("/root/SceneCombat/AnimationPlayer").play("Enemy_Death")
		
		
		
func loose():
	if get_node_or_null("SpeechBox") != null:
		get_node("SpeechBox").queue_free()
		texts_end[0]["text"] = get_node("/root/SceneCombat/ContainerMob/Pseudo").text+" remporte son combat..."
		texts_end[1]["text"] = "Vous perdez le combat et repartez bredouille..."
		get_node("/root/SceneCombat").spawn_dialogue(texts_end)
		get_node("/root/SceneCombat/AnimationPlayer").play("Player_Death")
		
		
