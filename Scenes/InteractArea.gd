extends Area2D


var trigger = false


func _process(_delta):
	$Trigger.visible = true
	$Interact.visible = trigger


func _on_interact_area_entered(body):
	if body.name == "Player_One":
		trigger = true


func _on_interact_area_exited(body):
	if body.name == "Player_One":
		trigger = false


func _npc_interact():
	if trigger && Input.is_action_just_pressed("F"):
		print("test")
		var scene_source = preload("res://Scenes/speech_box.tscn")
		var scene_instance = scene_source.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE) 
		add_child(scene_instance)



#var scene_source = preload("res://Scenes/speech_box.tscn")
#		var scene_instance = scene_source.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE) 
#		add_child(scene_instance)
