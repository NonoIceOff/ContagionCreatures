extends Node2D

var speechbox =  preload("res://Scenes/speech_box_COMBAT.tscn")
var rng = RandomNumberGenerator.new()
var pv_player = 100
var pv_enemy = 100
var turn = 0 # 0 = ton tour ; 1 = le tour du méchant

var defense_player = 0


var buttonP : Button
var buttonE : Button
var animalP : Sprite2D
var animalE : Sprite2D
var background_rect_info : ColorRect

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
	activate_buttons()
	
	
	var color_rect_player = ColorRect.new()
	color_rect_player.name = "color_rect"
	color_rect_player.size = Vector2(100, 30)  
	color_rect_player.color = Color(0, 1, 0)  
	color_rect_player.position = Vector2(190, 660)
	add_child(color_rect_player)


	
	var life_player = Label.new()
	life_player.name = "life_player"
	life_player.text = str(pv_player)
	life_player.scale = Vector2(1.5, 1.5)
	life_player.position.x = 25
	color_rect_player.add_child(life_player)
	
	var color_rect_enemy = ColorRect.new()
	color_rect_enemy.name = "color_rect"
	color_rect_enemy.size = Vector2(100, 30)  
	color_rect_enemy.color = Color(1, 0, 0)  
	color_rect_enemy.position = Vector2(1740, 370)
	add_child(color_rect_enemy)


	
	var life_enemy = Label.new()
	life_enemy.name = "life_player"
	life_enemy.text = str(pv_enemy)
	life_enemy.scale = Vector2(1.5, 1.5)
	life_enemy.position.x = 25
	color_rect_enemy.add_child(life_enemy)
	
	var i = 0
	for key in Global.actual_animal:
		if Global.animals_player[key] == Global.animals_player[PlayerStats.animal_id]:
			
			animalP = Sprite2D.new()
			animalP.name = "Sprite"
			animalP.texture = load(Global.actual_animal[PlayerStats.animal_id]["texture_animal_fight"])
			animalP.texture_filter =  CanvasItem.TEXTURE_FILTER_NEAREST 
			animalP.position = Vector2(774,995)
			animalP.z_index = 0
			animalP.scale = Vector2(5.1,5.1)
			add_child(animalP)
			
			buttonP = Button.new()
			buttonP.name = "info_buttonP"
			buttonP.name = str(key)
			buttonP.connect("pressed", Callable(self, "_create_and_display_label_player"))
			buttonP.position = Vector2(660,890)
			buttonP.custom_minimum_size = Vector2(70,70)
			add_child(buttonP)
			
			var sprite = Sprite2D.new()
			sprite.name = "Sprite"
			sprite.texture = load("res://Textures/Info.png")
			sprite.scale = Vector2(2,2)
			sprite.position = Vector2(35,35)
			buttonP.add_child(sprite)
		
		
	for key in Global.animals_enemy:
		if Global.animals_enemy[key] == Global.animals_enemy[PlayerStats.animal_id]:
			
			
			
			animalE = Sprite2D.new()
			animalE.name = "Sprite_animal_enemy"
			animalE.texture = load(Global.animals_enemy[PlayerStats.animal_id]["texture_infected"])
			print("Animal enemy: " + str(Global.animals_enemy[PlayerStats.animal_id]["name"]) +" et de type: " + str(Global.animals_enemy[PlayerStats.animal_id]["type"][0]))
			animalE.texture_filter =  CanvasItem.TEXTURE_FILTER_NEAREST 
			animalE.position = Vector2(1102,841)
			animalE.z_index = 0
			animalE.scale = Vector2(5.1,5.1)
			add_child(animalE)
			
			buttonE = Button.new()
			buttonE.name = "info_buttonE"
			buttonE.name = str(key)
			buttonE.position = Vector2(1200,821)
			buttonE.connect("pressed", Callable(self, "_create_and_display_label_enemy"))			
			buttonE.modulate = Color(1, 0.54902, 0, 1)
			buttonE.custom_minimum_size = Vector2(70,70)
			add_child(buttonE)
			
			var sprite = Sprite2D.new()
			sprite.name = "Sprite"
			sprite.texture = load("res://Textures/Info.png")
			sprite.scale = Vector2(2,2)
			sprite.position = Vector2(35,35)
			buttonE.add_child(sprite)
			
			
	if PlayerStats.animal_id != -1:
		for key in Global.actual_animal:
			for keys in Global.attacks:
				if Global.actual_animal[key]["type"] == Global.attacks[keys]["type"]:
						print(Global.actual_animal[key]["type"][0])
						print(Global.attacks[keys]["type"][0])
						var boost_animal = Global.attacks[keys]["value"] * 2
						Global.attacks[keys]["value"] += boost_animal

func _create_and_display_label_player():
	for key in Global.actual_animal:
		if Global.animals_player[key] == Global.animals_player[PlayerStats.animal_id]:
			background_rect_info = ColorRect.new()
			var screen_size = get_viewport_rect().size
			var center_position = screen_size /2
			background_rect_info.size = Vector2(800, 600)
			background_rect_info.position = (screen_size - background_rect_info.size) / 2
			background_rect_info.color = Color(0.0, 0.0, 0.2, 0.9)  
			add_child(background_rect_info)
			
			var sprite_animal_info = Sprite2D.new()
			sprite_animal_info.texture_filter =  CanvasItem.TEXTURE_FILTER_NEAREST 
			sprite_animal_info.texture = load(Global.actual_animal[PlayerStats.animal_id]["textureA"])
			sprite_animal_info.scale = Vector2(6,6)
			sprite_animal_info.position = Vector2(background_rect_info.size.x /2 , background_rect_info.size.y /3) 
			background_rect_info.add_child(sprite_animal_info)
			
			var label_info = Label.new()
			label_info.text = Global.actual_animal[key]["name"]
			label_info.add_theme_font_override("font", load("res://Font/8-BIT_WONDER.TTF"))
			label_info.scale = Vector2(2, 2)
			label_info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			label_info.position.x = background_rect_info.size.x / 2.5
			label_info.position.y = background_rect_info.size.y / 2
			background_rect_info.add_child(label_info)
			
			var close_button = Button.new()
			close_button.scale = Vector2(1,1)
			close_button.custom_minimum_size = Vector2(70,70)
			close_button.position = Vector2(background_rect_info.size.x - close_button.size.x - 80, 10)
			close_button.connect("pressed" , Callable( self , "_close_info_animalP"))
			background_rect_info.add_child(close_button)
			
			var sprite = Sprite2D.new()
			sprite.texture = load("res://Textures/Cross_Close.png")
			sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST 
			sprite.scale = Vector2(2.5,2.5)
			sprite.position = Vector2(close_button.size.x / 2, close_button.size.y / 2)
			close_button.add_child(sprite)
			
			var effects_label = Label.new()
			effects_label.text = "Effets: " + str(Global.actual_animal[key]["effets"][0])
			effects_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			effects_label.size = Vector2(700, 50)
			effects_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			effects_label.position = Vector2((background_rect_info.size.x - effects_label.size.x) / 2, background_rect_info.size.y - effects_label.size.y - 10)
			background_rect_info.add_child(effects_label)
			
			var type_label = Label.new()
			type_label.text = "Type: " + str(Global.actual_animal[key]["type"][0])
			type_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			type_label.size = Vector2(700, 50)
			type_label.position = Vector2((background_rect_info.size.x - type_label.size.x) / 2, effects_label.position.y - type_label.size.y - 10)
			background_rect_info.add_child(type_label)
			desactivate_buttons()
			print("Name: " + Global.actual_animal[key]["name"] + "\nEffets: " + str(Global.actual_animal[key]["effets"][0]) + "\nType: " + str(Global.actual_animal[key]["type"][0]))
			
func _create_and_display_label_enemy():
	for key in Global.animals_enemy:
		if Global.animals_enemy[key] == Global.animals_enemy[PlayerStats.animal_id]:
			background_rect_info = ColorRect.new()
			var screen_size = get_viewport_rect().size
			var center_position = screen_size / 2
			background_rect_info.size = Vector2(800, 600)
			background_rect_info.position = (screen_size - background_rect_info.size) / 2
			background_rect_info.color = Color(0.2, 0.0, 0.0, 0.9)  
			add_child(background_rect_info)
			
			var sprite_animal_info = Sprite2D.new()
			sprite_animal_info.texture_filter =  CanvasItem.TEXTURE_FILTER_NEAREST
			if Global.animals_enemy[PlayerStats.animal_id]["infected"] == false:
				sprite_animal_info.texture = load(Global.animals_enemy[PlayerStats.animal_id]["textureA"])
			else:
				sprite_animal_info.texture = load(Global.animals_enemy[PlayerStats.animal_id]["texture_infected"])				
			sprite_animal_info.scale = Vector2(6,6)
			sprite_animal_info.position = Vector2(background_rect_info.size.x /2 , background_rect_info.size.y /3) 
			background_rect_info.add_child(sprite_animal_info)
			
			var label_info = Label.new()
			label_info.text = Global.animals_enemy[PlayerStats.animal_id]["name"]
			label_info.add_theme_font_override("font", load("res://Font/8-BIT_WONDER.TTF"))
			label_info.scale = Vector2(2, 2)
			label_info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			label_info.position.x = background_rect_info.size.x / 2.5
			label_info.position.y = background_rect_info.size.y / 2
			background_rect_info.add_child(label_info)
			
			var close_button = Button.new()
			close_button.scale = Vector2(1,1)
			close_button.custom_minimum_size = Vector2(70,70)
			close_button.position = Vector2(background_rect_info.size.x - close_button.size.x - 80, 10)
			close_button.connect("pressed" , Callable( self , "_close_info_animalE"))
			background_rect_info.add_child(close_button)
			
			var sprite = Sprite2D.new()
			sprite.texture = load("res://Textures/Cross_Close.png")
			sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST 
			sprite.scale = Vector2(2.5,2.5)
			sprite.position = Vector2(close_button.size.x / 2, close_button.size.y / 2)
			close_button.add_child(sprite)
			
			var effects_label = Label.new()
			effects_label.text = "Effets: " + str(Global.animals_enemy[PlayerStats.animal_id]["effets"][0])
			effects_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			effects_label.size = Vector2(700, 50)
			effects_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			effects_label.position = Vector2((background_rect_info.size.x - effects_label.size.x) / 2, background_rect_info.size.y - effects_label.size.y - 10)
			background_rect_info.add_child(effects_label)
			
			var type_label = Label.new()
			type_label.text = "Type: " + str(Global.animals_enemy[PlayerStats.animal_id]["type"][0])
			type_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			type_label.size = Vector2(700, 50)
			type_label.position = Vector2((background_rect_info.size.x - type_label.size.x) / 2, effects_label.position.y - type_label.size.y - 10)
			background_rect_info.add_child(type_label)
			desactivate_buttons()
			print("Name: " + Global.animals_enemy[PlayerStats.animal_id]["name"] + "\nEffets: " + str(Global.animals_enemy[PlayerStats.animal_id]["effets"][0]) + "\nType: " + str(Global.animals_enemy[PlayerStats.animal_id]["type"][0]))

func _close_info_animalP():
	if background_rect_info != null:
		background_rect_info.queue_free()
		activate_buttons()
		
func _close_info_animalE():
	if background_rect_info != null:
		background_rect_info.queue_free()
		activate_buttons()
		
func activate_buttons():
	if buttonP != null and buttonE != null:
		buttonP.disabled = false
		buttonE.disabled = false
		get_node("Button").disabled = false
		get_node("Button2").disabled = false
		get_node("Button3").disabled = false
	else:
		print("Les boutons ne sont pas initialisés.")

func desactivate_buttons():
	if buttonP != null and buttonE != null:
		buttonP.disabled = true
		buttonE.disabled = true
		get_node("Button").disabled = true
		get_node("Button2").disabled = true
		get_node("Button3").disabled = true
	else:
		print("Les boutons ne sont pas initialisés.")
	

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
		Global.attack_index = rng.randi_range(0,Global.attack_names.size()-1)
		get_node("SpeechBox").queue_free()
		texts_enemy[0]["text"] = get_node("/root/SceneCombat/ContainerMob/Pseudo").text+" utilise "+str(Global.attack_names[Global.attack_index])+" et vous inflige "+str(Global.attack_values[Global.attack_index])+" degats."
		texts_enemy[1]["text"] = "C'est a vous ("+get_node("/root/SceneCombat/ContainerPLAYER/Pseudo").text+") d'attaquer maintenant "
		get_node("/root/SceneCombat").spawn_dialogue(texts_enemy)
		pv_player -= Global.enemy_attack
		get_node("/root/SceneCombat/AnimationPlayer").play("Damage_Player") 
		get_node("/root/SceneCombat/AnimationPlayer").play("shake")
		await get_node("/root/SceneCombat/AnimationPlayer").animation_finished
		print(pv_player)
		print(pv_enemy)
		
func win():
	if get_node_or_null("SpeechBox") != null:
		get_node("SpeechBox").queue_free()
		texts_end[0]["text"] = get_node("/root/SceneCombat/ContainerMob/Pseudo").text+" chute !"
		texts_end[1]["text"] = "Vous remportez le combat et 0 xp !"
		get_node("/root/SceneCombat").spawn_dialogue(texts_end)
		get_node("/root/SceneCombat/AnimationPlayer").play("Enemy_Death")
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
		get_node("/root/SceneCombat/CanvasLayer/Transition/AnimationPlayer").play("screen_to_transition")
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://Scenes/main_map.tscn")
	
