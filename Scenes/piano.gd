extends Node2D

var piano_id = 0

func add_note_in_quest():
	if Global.pianos[piano_id] == 0:
		Global.set_quest(3)
		Global.pianos[piano_id] = 1
		if Global.quests[3]["stade"] < 3:
			Global.finished_stade_quest()
		else:
			queue_free()
			Global.quest_finished(3)

func _on__pressed():
	get_node("1/AudioStreamPlayer2D").playing = true
	add_note_in_quest()


func _on_2_pressed():
	get_node("2/AudioStreamPlayer2D").playing = true
	add_note_in_quest()


func _on_3_pressed():
	get_node("3/AudioStreamPlayer2D").playing = true
	add_note_in_quest()




func _on_4_pressed():
	get_node("4/AudioStreamPlayer2D").playing = true
	add_note_in_quest()


func _on_5_pressed():
	get_node("5/AudioStreamPlayer2D").playing = true
	add_note_in_quest()


func _on_6_pressed():
	get_node("6/AudioStreamPlayer2D").playing = true
	add_note_in_quest()


func _on_7_pressed():
	get_node("7/AudioStreamPlayer2D").playing = true
	add_note_in_quest()


func _on_8_pressed():
	get_node("8/AudioStreamPlayer2D").playing = true
	add_note_in_quest()


func _on_9_pressed():
	get_node("9/AudioStreamPlayer2D").playing = true
	add_note_in_quest()


func _on_10_pressed():
	get_node("10/AudioStreamPlayer2D").playing = true
	add_note_in_quest()


func _on_11_pressed():
	get_node("11/AudioStreamPlayer2D").playing = true
	add_note_in_quest()


func _on_12_pressed():
	get_node("12/AudioStreamPlayer2D").playing = true
	add_note_in_quest()


func _on_quit_pressed():
	queue_free()
