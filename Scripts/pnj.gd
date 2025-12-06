extends Node2D

var dialogue_scene = preload("res://Scenes/dialogue.tscn")
var speech_box_scene = preload("res://Scenes/speech_box.tscn")
var in_area = false
var enemy_instance = null
var pnj_name = ""
var quest_id = 0
var quest_stade = 0

var over_texture = ""
var under_texture = ""
var sound_file = ""  # Son optionnel à jouer au dialogue

var dialogue_data = []  # Peut être Array ou Dictionary

func _ready() -> void:
	if over_texture != "" and over_texture != null:
		var texture = load(over_texture)
		if texture:
			get_node("Area2D/CharacterBody2D/Over").texture = texture
	
	if under_texture != "" and under_texture != null:
		var texture = load(under_texture)
		if texture:
			get_node("Area2D/CharacterBody2D/Over/Under").texture = texture

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player_One":
		Global.interact = true
		get_node("Area2D/Interact").visible = true
		in_area = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player_One":
		Global.interact = false
		get_node("Area2D/Interact").visible = false
		in_area = false
		
func _process(delta: float) -> void:
	var joypads = Input.get_connected_joypads()
	if joypads.size() < 1:
		get_node("Area2D/Interact").texture = load("res://Textures/Buttons/keyboard/keyboard_e.png")
	else:
		get_node("Area2D/Interact").texture = load(Controllers.a_texture)
	
	if Input.is_action_just_pressed(Controllers.a_input) and in_area == true and enemy_instance == null:
		# Fermer toutes les interfaces ouvertes
		var ui = get_node_or_null("/root/" + Global.current_map + "/ui")
		if ui and ui.has_method("close_current_interface"):
			ui.close_current_interface()
		
		# Animation bounce du PNJ
		var pnj_sprite = get_node("Area2D/CharacterBody2D/Over")
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_BOUNCE)
		tween.tween_property(pnj_sprite, "scale", pnj_sprite.scale * 1.2, 0.2)
		tween.tween_property(pnj_sprite, "scale", pnj_sprite.scale, 0.2)
		
		Quests.current_quest_id = quest_id
		
		# Jouer le son si défini
		if sound_file != "":
			var audio_player = get_node_or_null("/root/" + Global.current_map + "/AudioStreamPlayer2D")
			if audio_player:
				audio_player.stream = load(sound_file)
				audio_player.playing = true
		
		# Déterminer quel système de dialogue utiliser
		if typeof(dialogue_data) == TYPE_DICTIONARY:
			# Ancien système speech_box avec textes structurés
			enemy_instance = speech_box_scene.instantiate()
			enemy_instance.texts = dialogue_data
			enemy_instance.icon = load(over_texture)
			enemy_instance.get_node("IconSpeecher/Sprite2D").region_rect = Rect2(8, 0, 16, 16)
			enemy_instance.name_icon = pnj_name
			var ui_node = get_node_or_null("/root/" + Global.current_map + "/ui")
			if ui_node:
				ui_node.add_child(enemy_instance)
		else:
			# Nouveau système dialogue.gd avec array simple
			enemy_instance = dialogue_scene.instantiate()
			enemy_instance.pnj_name = pnj_name
			enemy_instance.dialogues = dialogue_data
			enemy_instance.contafont_mode = Quests.quests.get(quest_id).contafont_mode
			add_child(enemy_instance)
			enemy_instance.start_dialogue(dialogue_data)
