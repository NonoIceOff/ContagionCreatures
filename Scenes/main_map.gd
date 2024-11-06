extends Node2D


@onready var pause_menu = $Player_One/Camera2D/CanvasLayer/PauseMenu
@onready var global_vars = get_node("/root/Global")
var paused = false
var Key = false
var item_scene = preload("res://Scenes/item.tscn")
var pianoscene = preload("res://Scenes/piano.tscn")
var interacted = false
var quest_id = 0
var zoomed = false
var scene_load = false
@onready var label_sauvegarde = get_node("Player_One/Camera2D/CanvasLayer/LabelSauvegarde")
@onready var label_sauvegarder = get_node("Player_One/Camera2D/CanvasLayer/LabelSauvegarder")
@onready var area_torche = get_node("areaTorche")
@onready var area_ennemy = get_node("MobPNJ/AreaEnnemy1")


func _ready():
	Global.load_localisation()
	Global.load()
	Global.current_map = "main_map"
	if get_node_or_null("ui/CPUParticles2D") != null:
		get_node("ui/CPUParticles2D").visible = false
	get_node("ui/Transition/AnimationPlayer").play("transition_to_screen")
	await get_tree().create_timer(0.05).timeout
	get_node("SoundEffectFx").play()
	$InteractArea/Trigger.visible = true
	$InteractArea/Interact.visible = Global.interact
	area_torche.connect("save_triggered", Callable(self, "_on_save_triggered")) #se connecte au script dans area_saved envoie un signal au script ci-dessous
	area_torche.connect("saved_triggered", Callable(self, "_on_saved_triggered")) #se connecte au script dans area_saved envoie un signal au script ci-dessous
	area_torche.connect("saved_outside_area", Callable(self, "_on_saved_outside_area"))
	area_ennemy.connect("getNode", Callable(self, "_on_search_getNode"))
	Global.load()
	
	
func _on_search_getNode() -> void:
	get_node("ui/Transition/AnimationPlayer").play("screen_to_transition")
	
func _on_save_triggered() -> void:
	if label_sauvegarde:
		get_node("Player_One/Camera2D/CanvasLayer/LabelSauvegarder").visible = false
		label_sauvegarde.visible = true
		await get_tree().create_timer(5).timeout
		label_sauvegarde.visible = false
	else:
		print("LabelSauvegarde not found at the specified path")

func _on_saved_triggered() -> void:
	get_node("Player_One/Camera2D/CanvasLayer/LabelSauvegarder").visible = true
	
	
func _on_saved_outside_area() -> void:
	get_node("Player_One/Camera2D/CanvasLayer/LabelSauvegarder").visible = false
	
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit() # default behavior
		Global.save()

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
			get_node("StartCinematic/RichTextLabel").text = "[center]"+tr(Global.start_cinematic[0])
		if get_node("Path2D/PathFollow2D").progress_ratio >= 0.15 and get_node("Path2D/PathFollow2D").progress_ratio < 0.15+delta:
			get_node("StartCinematic/RichTextLabel").visible_ratio = 0
			get_node("StartCinematic/RichTextLabel").text = "[center]"+tr(Global.start_cinematic[1])
		if get_node("Path2D/PathFollow2D").progress_ratio >= 0.30 and get_node("Path2D/PathFollow2D").progress_ratio < 0.30+delta:
			get_node("StartCinematic/RichTextLabel").visible_ratio = 0
			get_node("AudioStreamPlayer2D").stream = load("res://Sounds/start_cinematic_dark_music.mp3")
			get_node("AudioStreamPlayer2D").playing = true
			get_node("Path2D/PathFollow2D/Camera2D/AnimationPlayer").current_animation = "camera_shake"
			get_node("StartCinematic/AnimationPlayer").current_animation = "new_animation"
			get_node("StartCinematic/CPUParticles2D").visible = true
			get_node("StartCinematic/Ennemy").visible = true
			get_node("StartCinematic/RichTextLabel").text = "[center]"+tr(Global.start_cinematic[2])
		if get_node("Path2D/PathFollow2D").progress_ratio >= 0.45 and get_node("Path2D/PathFollow2D").progress_ratio < 0.45+delta:
			get_node("StartCinematic/RichTextLabel").visible_ratio = 0
			get_node("StartCinematic/RichTextLabel").text = "[center]"+tr(Global.start_cinematic[3])
		if get_node("Path2D/PathFollow2D").progress_ratio >= 0.60 and get_node("Path2D/PathFollow2D").progress_ratio < 0.60+delta:
			get_node("StartCinematic/RichTextLabel").visible_ratio = 0
			get_node("StartCinematic/RichTextLabel").text = "[center]"+tr(Global.start_cinematic[4])
		if get_node("Path2D/PathFollow2D").progress_ratio >= 0.75 and get_node("Path2D/PathFollow2D").progress_ratio < 0.75+delta:
			get_node("StartCinematic/RichTextLabel").visible_ratio = 0
			get_node("StartCinematic/RichTextLabel").text = "[center]"+tr(Global.start_cinematic[5])
			
			
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
						"text": "DIALOGUE_0_TEXT0",
						"has_choices": true,
						"text_choices": ["DIALOGUE_YES", "DIALOGUE_NO"],
						"has_suite": false,
						"choices_jump_to": [1, 4]
					},
					1: {
						"text": "DIALOGUE_0_TEXT1",
						"has_choices": false,
						"text_choices": [],
						"has_suite": true,
						"choices_jump_to": [2, 0]
					},
					2: {
						"text": "DIALOGUE_0_TEXT2",
						"has_choices": false,
						"text_choices": [],
						"has_suite": true,
						"choices_jump_to": [3, 0]
					},
					3: {
						"text": "DIALOGUE_0_TEXT3",
						"has_choices": false,
						"text_choices": [],
						"has_suite": true,
						"choices_jump_to": [4, 0]
					},
					4: {
						"text": "DIALOGUE_0_TEXT4",
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
						"text": "DIALOGUE_0-2_TEXT0",
						"has_choices": false,
						"text_choices": ["DIALOGUE_YES", "DIALOGUE_NO"],
						"has_suite": true,
						"choices_jump_to": [1, 0]
					},
					1: {
						"text": "DIALOGUE_0-2_TEXT1",
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
						"text": "DIALOGUE_0-3_TEXT0",
						"has_choices": false,
						"text_choices": ["DIALOGUE_YES", "DIALOGUE_NO"],
						"has_suite": true,
						"choices_jump_to": [1, 0]
					},
					1: {
						"text": "DIALOGUE_0-3_TEXT1",
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
						"text": "DIALOGUE_0-4_TEXT0",
						"has_choices": false,
						"text_choices": ["DIALOGUE_YES", "DIALOGUE_NO"],
						"has_suite": true,
						"choices_jump_to": [1, 0]
					},
					1: {
						"text": "DIALOGUE_0-4_TEXT1",
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
						"text": "DIALOGUE_0-5_TEXT0",
						"has_choices": false,
						"text_choices": ["DIALOGUE_YES", "DIALOGUE_NO"],
						"has_suite": true,
						"choices_jump_to": [1, 0]
					},
					1: {
						"text": "DIALOGUE_0-5_TEXT1",
						"has_choices": false,
						"text_choices": [],
						"has_suite": true,
						"choices_jump_to": [2, 0]
					},
					2: {
						"text": "DIALOGUE_0-5_TEXT2",
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
						"text": "DIALOGUE_1_TEXT0",
						"has_choices": true,
						"text_choices": ["DIALOGUE_1_CHOICE3", "DIALOGUE_1_CHOICE4"],
						"has_suite": false,
						"choices_jump_to": [1, 6]
					},
					1: {
						"text": "DIALOGUE_1_TEXT1",
						"has_choices": false,
						"text_choices": [],
						"has_suite": true,
						"choices_jump_to": [2, 0]
					},
					2: {
						"text": "DIALOGUE_1_TEXT2",
						"has_choices": false,
						"text_choices": [],
						"has_suite": true,
						"choices_jump_to": [3, 0]
					},
					3: {
						"text": "DIALOGUE_1_TEXT3",
						"has_choices": false,
						"text_choices": [],
						"has_suite": true,
						"choices_jump_to": [4, 0]
					},
					4: {
						"text": "DIALOGUE_1_TEXT4",
						"has_choices": false,
						"text_choices": [],
						"has_suite": true,
						"choices_jump_to": [5, 0]
					},
					5: {
						"text": "DIALOGUE_1_TEXT5",
						"has_choices": true,
						"text_choices": ["DIALOGUE_1_CHOICE1","DIALOGUE_1_CHOICE2"],
						"has_suite": true,
						"choices_jump_to": [7, 8]
					},
					6: {
						"text": "DIALOGUE_1_TEXT6",
						"has_choices": false,
						"text_choices": [],
						"has_suite": false,
						"choices_jump_to": [0, 0]
					},
					7: {
						"text": "DIALOGUE_1_TEXT7",
						"has_choices": false,
						"text_choices": [],
						"has_suite": false,
						"choices_jump_to": [0, 0]
					},
					8: {
						"text": "DIALOGUE_1_TEXT8",
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
						"text": "DIALOGUE_1-2_TEXT0",
						"has_choices": false,
						"text_choices": ["DIALOGUE_YES", "DIALOGUE_NO"],
						"has_suite": true,
						"choices_jump_to": [1, 0]
					},
					1: {
						"text": "DIALOGUE_1-2_TEXT1",
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
	

func _on_interact_area_entered(body):
	if body.is_in_group("Player_One"):
		$InteractArea/Interact.visible = true

func _on_interact_area_exited(body):
	if body.is_in_group("Player_One"):
		$InteractArea/Interact.visible = false

func spawn_item(pos,type,id):
	var item_instance = item_scene.instantiate()
	item_instance.position = pos
	item_instance.id = id-1
	item_instance.type = type
	if type == "item":
		item_instance.get_node("Texture").texture = load(Global.items[5]["texture"])
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
