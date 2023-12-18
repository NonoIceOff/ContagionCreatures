extends Node2D

var speechbox =  preload("res://Scenes/speech_box_COMBAT.tscn")

var pv_player = 80

var pv_enemy = 50

func spawn_dialogue(custom_texts):
	var dialogue = speechbox.instantiate()
	dialogue.position = Vector2(0,-380)
	dialogue.texts = custom_texts
	add_child(dialogue)

func _process(delta):
	get_node("ContainerMob/TextureProgressBar").value = pv_enemy
	get_node("ContainerPLAYER/TextureProgressBar").value = pv_player
