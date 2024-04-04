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
	
	var i = 0
	for key in Global.animals_player:
		
		var button = Button.new()
		button.name = str(key)
		button.text = "Type :"+str(Global.type_animal)
		button.position = Vector2(660,890)
		button.custom_minimum_size = Vector2(40,40)
		button.connect("pressed", Callable(self, "_info_animal"))
		add_child(button)
		
		var sprite = Sprite2D.new()
		sprite.name = "Sprite"
		sprite.texture = load("res://Textures/Info.png")
		sprite.scale = Vector2(2,2)
		sprite.position = Vector2(20,20)
		button.add_child(sprite)
			
		#var value = Label.new()
		#value.name = "Value"
		#value.text = "Effets :"+str(Global.animals_player[key]["effets"])
		#value.text = "Type :"+(Global.random_type)
		#value.position.y = 46
		#value.custom_minimum_size = Vector2(280,16)
		#value.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		#value.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		#value.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		#button.add_child(value)
		


func _info_animal(button):
	for key in Global.animals_player:
		var label_info = Label.new()
		label_info.name = "name"
		label_info.text = "Effets :"+str(Global.animals_player[key]["effets"])
		label_info.text = "Type :"+(Global.random_type)
		label_info.text = "Info sur l'animal"
		label_info.position.y = 46
		label_info.custom_minimum_size = Vector2(280,16)
		label_info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label_info.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label_info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		button.add_child(label_info)
		
		var close_button = Button.new()
		close_button.texture = load("res://Textures/Cross_Close.png")
		close_button.scale = Vector2(1.7,1.7)
		close_button.position = Vector2(20,20)
		close_button.connect("pressed", Callable(self, "_close_info_animal"),)
		label_info.add_child(close_button)
		
func _close_info_animal(label_info):
	label_info.queue_free()

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
			if pv_player <= 0 and pv_player > -1000000000000:
				loose()
				turn = -1
				pv_player = -1000
			elif pv_enemy <= 0 and pv_enemy > -1000000000000:
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
		texts_enemy[0]["text"] = get_node("/root/SceneCombat/ContainerMob/Pseudo").text+" utilise "+str(attack_names[attack_index])+" et vous inflige"+str(attack_values[attack_index])+" degats."
		texts_enemy[1]["text"] = "C'est a vous ("+get_node("/root/SceneCombat/ContainerPLAYER/Pseudo").text+") d'attaquer maintenant "
		get_node("/root/SceneCombat").spawn_dialogue(texts_enemy)
		pv_player -= attack_values[attack_index]
		get_node("/root/SceneCombat/AnimationPlayer").play("Damage_Player") 
		get_node("/root/SceneCombat/AnimationPlayer").play("shake") 
		if get_node_or_null("Sounds") != null:
			get_node("Sounds").stream = load("res://Sounds/hurt.mp3")
			get_node("Sounds").playing = true
		await get_node("/root/SceneCombat/AnimationPlayer").animation_finished
		
func win():
	if get_node_or_null("SpeechBox") != null:
		Tutorial.get_node(".").tutorials[5]["progress"] += 100
		get_node("SpeechBox").queue_free()
		texts_end[0]["text"] = get_node("/root/SceneCombat/ContainerMob/Pseudo").text+" chute !"
		texts_end[1]["text"] = "Vous remportez le combat et 0 xp !"
		get_node("/root/SceneCombat").spawn_dialogue(texts_end)
		get_node("/root/SceneCombat/AnimationPlayer").play("Enemy_Death")
		if get_node_or_null("Sounds") != null:
			get_node("Sounds").stream = load("res://Sounds/explosion.mp3")
			get_node("Sounds").playing = true
		get_node("/root/SceneCombat/CanvasLayer/Transition/AnimationPlayer").play("screen_to_transition")
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://Scenes/main_map.tscn")
		
		
func loose():
	if get_node_or_null("SpeechBox") != null:
		get_node("SpeechBox").queue_free()
		texts_end[0]["text"] = get_node("/root/SceneCombat/ContainerMob/Pseudo").text+" remporte son combat..."
		texts_end[1]["text"] = "Vous perdez le combat et repartez bredouille..."
		get_node("/root/SceneCombat").spawn_dialogue(texts_end)
		get_node("/root/SceneCombat/AnimationPlayer").play("Player_Death")
		if get_node_or_null("Sounds") != null:
			get_node("Sounds").stream = load("res://Sounds/explosion.mp3")
			get_node("Sounds").playing = true
		get_node("/root/HomeOfHector/CanvasLayer/Transition/AnimationPlayer").play("screen_to_transition")
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://Scenes/main_map.tscn")
	
