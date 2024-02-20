extends Node2D

@onready var pause_menu = $Player_One/Camera2D/CanvasLayer/PauseMenu
@onready var global_vars = get_node("/root/Global")
var paused = false
var Key = false
var entered_Ennemy = false
var item_scene = preload("res://Scenes/item.tscn")
var interacted = false
var quest_id = 0

func _ready():
	if get_node_or_null("CanvasLayer/CPUParticles2D") != null:
		get_node("CanvasLayer/CPUParticles2D").visible = false
	get_node("CanvasLayer/Transition/AnimationPlayer").play("transition_to_screen")
	await get_tree().create_timer(0.05).timeout
	get_node("MobPNJ/AreaEnnemy1/Label_E_ennemy").visible = false
	$InteractArea/Trigger.visible = true
	$InteractArea/Interact.visible = Global.interact
	spawn_item(Vector2(0,0),"item",1)
	


func _process(_delta):
	if Global.current_quest_id > -1 and get_node_or_null("CanvasLayer/CPUParticles2D") != null:
		get_node("CanvasLayer/CPUParticles2D/QuestTextBar").text = "[center][rainbow freq=0.05]"+Global.quests[Global.current_quest_id]["title"]+" [/rainbow] [color=black]| [color=white][i]"+Global.quests[Global.current_quest_id]["mini_descriptions"][ Global.quests[Global.current_quest_id]["stade"]]
	if Input.is_action_just_pressed("échap"):
		PauseMenu()
	if $InteractArea/Interact.visible == true:
		if Input.is_action_just_pressed("ui_interact") and get_node_or_null("CanvasLayer2/SpeechBox") == null:
			interacted = true
			var scene_source = preload("res://Scenes/speech_box.tscn")
			var scene_instance = scene_source.instantiate()
			if quest_id == 0:
				var text_quest_0 = {
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
				scene_instance.texts = text_quest_0
				
			if quest_id == 1 and Global.quests[1]["stade"] == 0:
				Global.quests[1]["stade"] = 1
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
				
			if quest_id == 1 and Global.quests[1]["stade"] == 2:
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
				
				
			get_node("CanvasLayer2").add_child(scene_instance)
			interacted = false			
	if entered_Ennemy == true and Key == false:
		if Input.is_action_just_pressed("ui_interact"): #and $MobPNJ/AreaEnnemy1/Collision_Ennemy.is_in_group("Player_One"):
			Key = true
			get_node("CanvasLayer/Transition/AnimationPlayer").play("screen_to_transition")
			print("pou")
			await get_tree().create_timer(2).timeout
			get_tree().change_scene_to_file("res://Scenes/scène_combat.tscn")
			print("rrr")
			Key = false


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
		get_node("/root/main_map/CanvasLayer/Transition/AnimationPlayer").play("screen_to_transition")
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
