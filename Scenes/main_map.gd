extends Node2D


@onready var pause_menu = $Player_One/Camera2D/CanvasLayer/PauseMenu
@onready var global_vars = get_node("/root/Global")
var paused = false
var Key = false
var entered_Ennemy = false
var item_scene = preload("res://Scenes/item.tscn")
var pianoscene = preload("res://Scenes/piano.tscn")
var interacted = false
var quest_id = 0
var zoomed = false
var scene_load = false


func _ready():
	Global.current_map = "main_map"
	if get_node_or_null("ui/CPUParticles2D") != null:
		get_node("ui/CPUParticles2D").visible = false
	get_node("ui/Transition/AnimationPlayer").play("transition_to_screen")
	await get_tree().create_timer(0.05).timeout
	get_node("SoundEffectFx").play()
	get_node("MobPNJ/AreaEnnemy1/Label_E_ennemy").visible = false
	$InteractArea/Trigger.visible = true
	$InteractArea/Interact.visible = Global.interact
	Global.load()
	
	
func zoom_dialogue():
	if zoomed == false:
		get_node("SoundEffectFx").stream_paused = true
		zoomed = true
		if get_node_or_null("ui/Minimap") != null:
			get_node("ui/Minimap").visible = false
		if get_node_or_null("ui/Stats") != null:
			get_node("ui/Stats").visible = false
		get_node("ui/Cinematic").modulate = Color(0,0,0,0)
		get_node("ui/Cinematic").visible = true
		for i in 10:
			await get_tree().create_timer(0.001).timeout 
			get_node("Player_One/2").zoom *= 1.05
			get_node("ui/Cinematic").modulate.a += 0.1
		
func unzoom_dialogue():
	if zoomed == true:
		get_node("SoundEffectFx").stream_paused = false
		zoomed = false
		if get_node_or_null("ui/Minimap") != null:
			get_node("ui/Minimap").visible = true
		if get_node_or_null("ui/Stats") != null:
			get_node("ui/Stats").visible = true
		for i in 10:
			await get_tree().create_timer(0.001).timeout 
			get_node("Player_One/2").zoom /= 1.05
			get_node("ui/Cinematic").modulate.a -= 0.1
		get_node("ui/Cinematic").visible = false


func _process(delta):
	if Global.tutorial == true and Global.tutorial_stade == 0: ## INITIALISATION DU TUTO
		get_node("StartCinematic").visible = true
		get_node("StartCinematic/RichTextLabel").visible_ratio = 0
		get_node("Path2D/PathFollow2D/Camera2D").enabled = true
		get_node("Player_One/2").enabled = false
		get_node("StartCinematic/CPUParticles2D").visible = false
		get_node("StartCinematic/Ennemy").visible = false
		
		Global.tutorial_stade = 1
		get_node("AudioStreamPlayer2D").stream = load("res://Sounds/music_debut.mp3")
		get_node("AudioStreamPlayer2D").playing = true
		get_node("SoundEffectFx").volume_db = -80
		get_node("ui").visible = false
		
	if Global.tutorial == true and Global.tutorial_stade == 1: ## INTRODUCTION DU TUTO
		get_node("Path2D/PathFollow2D").progress += 175*delta
		
		if get_node("StartCinematic/StopCinematic").self_modulate.a < 1-delta:
			get_node("StartCinematic/StopCinematic").self_modulate.a += 0.25*delta
		get_node("StartCinematic/RichTextLabel").visible_ratio += 0.2*delta
		if get_node("Path2D/PathFollow2D").progress_ratio >= 0 and get_node("Path2D/PathFollow2D").progress_ratio < 0+delta:
			get_node("StartCinematic/RichTextLabel").visible_ratio = 0
			get_node("StartCinematic/RichTextLabel").text = "[center]"+Global.start_cinematic[0]
		if get_node("Path2D/PathFollow2D").progress_ratio >= 0.15 and get_node("Path2D/PathFollow2D").progress_ratio < 0.15+delta:
			get_node("StartCinematic/RichTextLabel").visible_ratio = 0
			get_node("StartCinematic/RichTextLabel").text = "[center]"+Global.start_cinematic[1]
		if get_node("Path2D/PathFollow2D").progress_ratio >= 0.30 and get_node("Path2D/PathFollow2D").progress_ratio < 0.30+delta:
			get_node("StartCinematic/RichTextLabel").visible_ratio = 0
			get_node("AudioStreamPlayer2D").stream = load("res://Sounds/start_cinematic_dark_music.mp3")
			get_node("AudioStreamPlayer2D").playing = true
			get_node("Path2D/PathFollow2D/Camera2D/AnimationPlayer").current_animation = "camera_shake"
			get_node("StartCinematic/AnimationPlayer").current_animation = "new_animation"
			get_node("StartCinematic/CPUParticles2D").visible = true
			get_node("StartCinematic/Ennemy").visible = true
			get_node("StartCinematic/RichTextLabel").text = "[center]"+Global.start_cinematic[2]
		if get_node("Path2D/PathFollow2D").progress_ratio >= 0.45 and get_node("Path2D/PathFollow2D").progress_ratio < 0.45+delta:
			get_node("StartCinematic/RichTextLabel").visible_ratio = 0
			get_node("StartCinematic/RichTextLabel").text = "[center]"+Global.start_cinematic[3]
		if get_node("Path2D/PathFollow2D").progress_ratio >= 0.60 and get_node("Path2D/PathFollow2D").progress_ratio < 0.60+delta:
			get_node("StartCinematic/RichTextLabel").visible_ratio = 0
			get_node("StartCinematic/RichTextLabel").text = "[center]"+Global.start_cinematic[4]
		if get_node("Path2D/PathFollow2D").progress_ratio >= 0.75 and get_node("Path2D/PathFollow2D").progress_ratio < 0.75+delta:
			get_node("StartCinematic/RichTextLabel").visible_ratio = 0
			get_node("StartCinematic/RichTextLabel").text = "[center]"+Global.start_cinematic[5]
			
			
		if get_node("AudioStreamPlayer2D").playing == false or get_node("Path2D/PathFollow2D").progress_ratio >= 1-delta: ## SI L'INTRO EST TERMINEE
			get_node("ui").visible = true
			get_node("Player_One/2").enabled = true
			get_node("Path2D/PathFollow2D/Camera2D").enabled = false
			get_node("SoundEffectFx").volume_db = -10
			get_node("AudioStreamPlayer2D").playing = false
			Global.tutorial_stade = 2
			get_node("StartCinematic").visible = false
			get_node("Path2D/PathFollow2D/Camera2D/AnimationPlayer").current_animation = "[STOP]"
			get_node("StartCinematic/AnimationPlayer").current_animation = "[STOP]"
			get_node("StartCinematic/CPUParticles2D").visible = false
			
		
	if get_node_or_null("ui/Stats/Coins/Label") != null:
		get_node_or_null("ui/Stats/Coins/Label").text = str(PlayerStats.monnaie)
	
	if Input.is_action_just_pressed("échap"):
		PauseMenu()
	
	if Input.is_action_just_pressed("ui_interact") and get_node_or_null("ui/SpeechBox") == null:
		interacted = true
		var scene_source = preload("res://Scenes/speech_box.tscn")
		var scene_instance = scene_source.instantiate()
		
		if get_node_or_null("Piano2/Interact") != null and get_node("Piano2/Interact").visible == true:
			var instance = pianoscene.instantiate()
			instance.piano_id = 1
			get_node("ui").add_child(instance)
		
		if get_node_or_null("InteractArea/Interact") != null and $InteractArea/Interact.visible == true:
			if quest_id == 0 and Global.quests[0]["stade"] == 0:
				Global.set_quest(0)
				var text_quest_0 = {
					0: {
						"text": "Bonjour jeune aventurier ! J'ai perdu quelque chose... pourrais-tu m'aider contre [tornado radius=5.0 freq=1.0 connected=1][rainbow freq=0.1 sat=0.8 val=0.8]une recompense[/rainbow][/tornado] ?",
						"has_choices": true,
						"text_choices": ["Oui", "Non"],
						"has_suite": false,
						"choices_jump_to": [1, 4]
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
						"text": "Je pense que Monsieur Loytan peux nous aider, va le voir pourfaire avancer cette malheureuse tragedie.",
						"has_choices": false,
						"text_choices": [],
						"has_suite": true,
						"choices_jump_to": [4, 0]
					},
					4: {
						"text": "Oh... reviens me voir plus tard !",
						"has_choices": false,
						"text_choices": [],
						"has_suite": false,
						"choices_jump_to": [0, 0]
					}
				}
				scene_instance.texts = text_quest_0
				scene_instance.icon = load("res://Textures/Old_guy_who_lost_is_crampté_REAL.png")
				scene_instance.get_node("IconSpeecher/Sprite2D").region_rect = Rect2(8,0,16,16)
				scene_instance.name_icon = "Hector"
				get_node("ui").add_child(scene_instance)
				zoom_dialogue()
				interacted = false
				
		if get_node_or_null("Loytan/Interact") != null and get_node("Loytan/Interact").visible == true:
			if quest_id == 0 and Global.quests[0]["stade"] == 1:
				Global.set_quest(0)
				var text_quest_0_2 = {
					0: {
						"text": "[color=#0000FF][b]Hello cher eleve,[/b][/color] [color=#FF0000][i]j'ai cru comprendre que Hector avait perdu ses cramptes.[/i][/color]",
						"has_choices": false,
						"text_choices": ["Oui", "Non"],
						"has_suite": true,
						"choices_jump_to": [1, 0]
					},
					1: {
						"text": "Je les ai retrouves dans une enigme, resouds-la pour la recuperer !",
						"has_choices": false,
						"text_choices": [],
						"has_suite": true,
						"choices_jump_to": [2, 0]
					},
					2: {
						"text": "",
						"has_choices": false,
						"text_choices": [],
						"has_suite": true,
						"choices_jump_to": [0, 0]
					}
				}
				scene_instance.texts = text_quest_0_2
				scene_instance.icon = load("res://Textures/PNJ/Loytan/loytan_full.png")
				scene_instance.get_node("IconSpeecher/Sprite2D").region_rect = Rect2(8,0,16,16)
				scene_instance.name_icon = "Loytan"
				get_node("ui").add_child(scene_instance)
				zoom_dialogue()
				interacted = false
				
			if quest_id == 0 and Global.quests[0]["stade"] == 2:
				Global.set_quest(0)
				var text_quest_0_3 = {
					0: {
						"text": "Bravo t'as resolu l'enigme ! Tu sera desormais traumatise par les dimanches.",
						"has_choices": false,
						"text_choices": ["Oui", "Non"],
						"has_suite": true,
						"choices_jump_to": [1, 0]
					},
					1: {
						"text": "Tiens, voici les cramptes donne les a Hector.",
						"has_choices": false,
						"text_choices": [],
						"has_suite": true,
						"choices_jump_to": [2, 0]
					}
				}
				scene_instance.texts = text_quest_0_3
				scene_instance.icon = load("res://Textures/PNJ/Loytan/loytan_full.png")
				scene_instance.get_node("IconSpeecher/Sprite2D").region_rect = Rect2(8,0,16,16)
				scene_instance.name_icon = "Loytan"
				get_node("ui").add_child(scene_instance)
				zoom_dialogue()
				interacted = false

			if quest_id == 0 and Global.quests[0]["stade"] == 4:
				Global.set_quest(0)
				var text_quest_0_4 = {
					0: {
						"text": "Tu n'as pas reussi l'enigme, je vais devoir t'en passer une autre...",
						"has_choices": false,
						"text_choices": ["Oui", "Non"],
						"has_suite": true,
						"choices_jump_to": [1, 0]
					},
					1: {
						"text": "J'espere que celle-ci va te plaire !",
						"has_choices": false,
						"text_choices": [],
						"has_suite": true,
						"choices_jump_to": [2, 0]
					},
					2: {
						"text": "",
						"has_choices": false,
						"text_choices": [],
						"has_suite": true,
						"choices_jump_to": [0, 0]
					}
				}
				scene_instance.texts = text_quest_0_4
				scene_instance.icon = load("res://Textures/PNJ/Loytan/loytan_full.png")
				scene_instance.get_node("IconSpeecher/Sprite2D").region_rect = Rect2(8,0,16,16)
				scene_instance.name_icon = "Loytan"
				get_node("ui").add_child(scene_instance)
				zoom_dialogue()
				interacted = false
				
		if get_node_or_null("InteractArea/Interact") != null and get_node("InteractArea/Interact").visible == true:
			if quest_id == 0 and Global.quests[0]["stade"] == 3:
				Global.set_quest(0)
				var text_quest_0_4 = {
					0: {
						"text": "Oh et bien merci beaucoup d'avoir retrouve mes cramptes.",
						"has_choices": false,
						"text_choices": ["Oui", "Non"],
						"has_suite": true,
						"choices_jump_to": [1, 0]
					},
					1: {
						"text": "En recompense, je te les donnes, fais-en un bel usage. Il est tres utile pour les combats.",
						"has_choices": false,
						"text_choices": [],
						"has_suite": true,
						"choices_jump_to": [2, 0]
					},
					2: {
						"text": "A toi de te balader un peu mon garcon.",
						"has_choices": false,
						"text_choices": [],
						"has_suite": true,
						"choices_jump_to": [3, 0]
					}
				}
				scene_instance.texts = text_quest_0_4
				scene_instance.icon = load("res://Textures/Old_guy_who_lost_is_crampté_REAL.png")
				scene_instance.get_node("IconSpeecher/Sprite2D").region_rect = Rect2(8,0,16,16)
				scene_instance.name_icon = "Hector"
				get_node("ui").add_child(scene_instance)
				zoom_dialogue()
				interacted = false
				
		if get_node_or_null("Bagird/Interact") != null and get_node("Bagird/Interact").visible == true:
			if quest_id == 1 and Global.quests[1]["stade"] == 0:
				Global.set_quest(1)
				Global.quests[1]["stade"] = 1
				get_node("AudioStreamPlayer2D").stream = load("res://Sounds/bagrid_shlack.mp3")
				get_node("AudioStreamPlayer2D").playing = true
				var text_quest_1 = {
					0: {
						"text": "Salut mon pote, alors pret a ecouter mes blagues de fou ? Attention tu risques de perdre ton cerveau !",
						"has_choices": true,
						"text_choices": ["Je veux ecouter pitie", "Non c'est de la merde"],
						"has_suite": false,
						"choices_jump_to": [1, 6]
					},
					1: {
						"text": "Super ! C'est parti ! Alors... Voyons voir...",
						"has_choices": false,
						"text_choices": [],
						"has_suite": true,
						"choices_jump_to": [2, 0]
					},
					2: {
						"text": "La femme : 'Docteur j’ai la diarrhée mentale'",
						"has_choices": false,
						"text_choices": [],
						"has_suite": true,
						"choices_jump_to": [3, 0]
					},
					3: {
						"text": "Docteur : 'C’est-à-dire ?'",
						"has_choices": false,
						"text_choices": [],
						"has_suite": true,
						"choices_jump_to": [4, 0]
					},
					4: {
						"text": "La Femme : 'À chaque fois que j’ai une idée, c’est de la merde !'",
						"has_choices": false,
						"text_choices": [],
						"has_suite": true,
						"choices_jump_to": [5, 0]
					},
					5: {
						"text": "Alors c'etait excellent .",
						"has_choices": true,
						"text_choices": ["Oui de la dinguerie pure","Nul a chier"],
						"has_suite": true,
						"choices_jump_to": [7, 8]
					},
					6: {
						"text": "Punaise il veux pas se detendre un peu le roblochon...",
						"has_choices": false,
						"text_choices": [],
						"has_suite": false,
						"choices_jump_to": [0, 0]
					},
					7: {
						"text": "MERCIIIIIIIIIIIIII TIENS EN RECOMPENSE !",
						"has_choices": false,
						"text_choices": [],
						"has_suite": false,
						"choices_jump_to": [0, 0]
					},
					8: {
						"text": "COMMENT CA T'AIMES PAS ? RESSAISIS-TOI UN PEU RIGOLE !",
						"has_choices": false,
						"text_choices": [],
						"has_suite": false,
						"choices_jump_to": [0, 0]
					}
				}
				scene_instance.texts = text_quest_1
				scene_instance.icon = load("res://Textures/PNJ/Bagird/bagird_full.png")
				scene_instance.get_node("IconSpeecher/Sprite2D").region_rect = Rect2(8,0,16,16)
				scene_instance.name_icon = "Bagird"
				get_node("ui").add_child(scene_instance)
				zoom_dialogue()
				interacted = false
				
			if quest_id == 1 and Global.quests[1]["stade"] == 2:
				Global.set_quest(1)
				get_node("AudioStreamPlayer2D").stream = load("res://Sounds/bagrid_rire.mp3")
				get_node("AudioStreamPlayer2D").playing = true
				var text_quest_1_2 = {
					0: {
						"text": "Bravo tu m'as trouve, tu est trop fort ! Tu as rit a la blague hillarante et tu est trop fort au cache-cache.",
						"has_choices": false,
						"text_choices": ["Oui", "Non"],
						"has_suite": true,
						"choices_jump_to": [1, 0]
					},
					1: {
						"text": "Je vais te donner ce N-KEY, a toi de trouver a quoi elle sert ! Qui sait, elle cache un enorme secret...",
						"has_choices": false,
						"text_choices": [],
						"has_suite": true,
						"choices_jump_to": [0, 0]
					}
				}
				scene_instance.texts = text_quest_1_2
				scene_instance.icon = load("res://Textures/PNJ/Bagird/bagird_full.png")
				scene_instance.get_node("IconSpeecher/Sprite2D").region_rect = Rect2(8,0,16,16)
				scene_instance.name_icon = "Bagird"
				get_node("ui").add_child(scene_instance)
				zoom_dialogue()
				interacted = false
		
		if get_node_or_null("InversedDungeon/Interact") != null and get_node("InversedDungeon/Interact").visible == true:
			if quest_id == 2 and Global.items[5]["quantity"] > 0:
				
				Global.items[5]["quantity"] -= 1
				quest_id = 0
				
				Global.quest_finished(1)
				Global.quests[1]["finished"] = true

				get_node("ui/Transition/AnimationPlayer").play("screen_to_transition")
				await get_tree().create_timer(2).timeout
				get_tree().change_scene_to_file("res://Scenes/dungeon_inversed.tscn")
				interacted = false
			

	if entered_Ennemy == true and Key == false:
		if Input.is_action_just_pressed("ui_interact"): #and $MobPNJ/AreaEnnemy1/Collision_Ennemy.is_in_group("Player_One"):
			Tutorial.get_node(".").tutorials[4]["progress"] += 100
			Key = true
			get_node("ui/Transition/AnimationPlayer").play("screen_to_transition")
			await get_tree().create_timer(2).timeout
			get_tree().change_scene_to_file("res://Scenes/scène_combat.tscn")
			Key = false

	if Input.is_action_just_pressed("M"):
		if scene_load == false:
			var load_scene = preload("res://Scenes/Full_screen_map.tscn")
			var load_instance = load_scene.instantiate()
			load_instance.position = Vector2(0,0)
			get_node("ui/Minimap").visible = false
			get_node("ui").add_child(load_instance)
			
			scene_load = true

		elif scene_load == true:
			get_node("ui/Full_Screen_map").queue_free()
			get_node("ui/Minimap").visible = true
			scene_load = false
	
	
func PauseMenu ():
	if Global.paused == true:
		pause_menu.show()
		Engine.time_scale = 0
		Global.can_move = false
	elif Global.paused == false:
		pause_menu.hide()
		Engine.time_scale = 1
		Global.can_move = true
	
	Global.paused = !Global.paused
	

func _on_area_ennemy_1_body_entered(body):
	if body.is_in_group("Player_One"):
		entered_Ennemy = true
		get_node("MobPNJ/AreaEnnemy1/Label_E_ennemy").visible = true


func _on_area_ennemy_1_body_exited(body):
	if body.is_in_group("Player_One"):
		entered_Ennemy = false
		get_node("MobPNJ/AreaEnnemy1/Label_E_ennemy").visible = false

func _on_interact_area_entered(body):
	if body.is_in_group("Player_One"):
		$InteractArea/Interact.visible = true

func _on_interact_area_exited(body):
	if body.is_in_group("Player_One"):
		$InteractArea/Interact.visible = false

func spawn_item(pos,type,id):
	var item_instance = item_scene.instantiate()
	item_instance.position = pos
	item_instance.id = id
	item_instance.type = type
	if type == "item":
		item_instance.get_node("Texture").texture = load(Global.items[id]["texture"])
	if type == "attack":
		item_instance.get_node("Texture").texture = load(Global.attacks[id]["texture"])
	add_child(item_instance)
	
func _on_entered_transition_map(body):
	var entered_area = false
	if body.is_in_group("Player_One"):
		entered_area = true
		get_node("/root/main_map/ui/Transition/AnimationPlayer").play("screen_to_transition")
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://Scenes/map2.tscn")
	


func _on_interact_area_body_entered(body):
	if body.is_in_group("Player_One"):
		quest_id = 0
		$InteractArea/Interact.visible = true


func _on_interact_area_body_exited(body):
	if body.is_in_group("Player_One"):
		$InteractArea/Interact.visible = false


func _on_bagird_body_entered(body):
	if body.is_in_group("Player_One"):
		quest_id = 1
		get_node("Bagird/Interact").visible = true


func _on_bagird_body_exited(body):
	if body.is_in_group("Player_One"):
		get_node("Bagird/Interact").visible = false


func _on_inversed_dungeon_body_entered(body):
	if body.is_in_group("Player_One"):
		quest_id = 2
		get_node("InversedDungeon/Interact").visible = true


func _on_inversed_dungeon_body_exited(body):
	if body.is_in_group("Player_One"):
		get_node("InversedDungeon/Interact").visible = false


func _on_loytan_body_entered(body):
	if body.is_in_group("Player_One"):
		quest_id = 0
		get_node("Loytan/Interact").visible = true


func _on_loytan_body_exited(body):
	if body.is_in_group("Player_One"):
		get_node("Loytan/Interact").visible = false


func _on_piano_2_body_entered(body):
	if body.is_in_group("Player_One"):
		get_node("Piano2/Interact").visible = true


func _on_piano_2_body_exited(body):
	if body.is_in_group("Player_One"):
		get_node("Piano2/Interact").visible = false


func _on_stop_cinematic_pressed():
	get_node("ui").visible = true
	get_node("Player_One/2").enabled = true
	get_node("Path2D/PathFollow2D/Camera2D").enabled = false
	get_node("SoundEffectFx").volume_db = -10
	get_node("AudioStreamPlayer2D").playing = false
	Global.tutorial_stade = 2
	get_node("StartCinematic").visible = false
	get_node("Path2D/PathFollow2D/Camera2D/AnimationPlayer").current_animation = "[STOP]"
	get_node("StartCinematic/AnimationPlayer").current_animation = "[STOP]"
	get_node("StartCinematic/CPUParticles2D").visible = false
	get_node("StartCinematic/Ennemy").visible = false
