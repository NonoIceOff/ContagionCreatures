extends Node2D

@onready var pre_evo_sprite := $CanvasLayer/creaturePreEvo
@onready var post_evo_sprite := $CanvasLayer/creaturePostEvo
@onready var item_used_sprite := $CanvasLayer/matchedItem
@onready var animation_player := $CanvasLayer/AnimationPlayer
@onready var dialogue_evo := $CanvasLayer/Dialogue

var has_played_consume := false
var has_played_evolution := false

func start_evolution(pre_texture_path: String, post_texture_path: String, pre_name: String, post_name: String, matched_item: String):
	pre_evo_sprite.texture = load(pre_texture_path)
	post_evo_sprite.texture = load(post_texture_path)
	item_used_sprite.texture = load(matched_item)
	var pre_evo_name = pre_name
	var post_evo_name = post_name
	
	var dialogues = [
	{
		"text": pre_evo_name + " est compatible avec l'item",
		"action": "_on_dialogue_start"
	},
	{
		"text": "Cliquez pour intéragir"
	},
	{
		"text": "",
		"action": "_on_set_variable",
		"params": [
			"Global.numberDialogue",
			1
		]
	},
	{
		"text": "Oh " + pre_evo_name + " va évoluer !!!!!!!",
		"action": "_on_set_variable",
		"params": [
			"Global.numberDialogue",
			2
		]
	},
	{
		"text": pre_evo_name + " a évolué en " + post_evo_name + " !",
		"action": "_on_dialogue_end"
	}
] 
	dialogue_evo.start_dialogue(dialogues)

func _ready():
	pass
	#MusicsPlayer.play_sound("res://Sounds/combat_music.mp3", "Player")
	
func _process(delta: float) -> void:
	if Global.numberDialogue == 1 and not has_played_consume:
		animation_player.play("consumeItem")
		has_played_consume = true
		
	elif Global.numberDialogue == 2 and not has_played_evolution:
		animation_player.play("evolution")
		has_played_evolution = true

func _on_AnimationPlayer_animation_finished(anim_name: String):
	if anim_name == "evolution":
		queue_free()
