extends Area2D


var entered = false
var Key = false

func _ready():
	get_node("Label_E").visible = false
	#get_node("/root/Transition_Scène/ScèneJeu/main_map/Player_One/Area2D").connect("body_entered_signal", Callable( self, "_Zone_Entered"))


func _on_body_entered(body):
	if body.is_in_group("Player_One"):
		entered = true
		get_node("Label_E").visible = true


func _on_body_exited(body):
	if body.is_in_group("Player_One"):
		entered = false
		get_node("Label_E").visible = false


func _process(delta):
	if entered == true and Key == false:
		if Input.is_action_just_pressed("ui_interact"):
			Global.save()
			Key = true
			if get_node_or_null("/root/HomeOfHector/CanvasLayer/Transition/AnimationPlayer") != null:
				get_node("/root/HomeOfHector/CanvasLayer/Transition/AnimationPlayer").play("screen_to_transition")
			if get_node_or_null("/root/Dungeon1/CanvasLayer/Transition/AnimationPlayer") != null:
				get_node("/root/Dungeon1/CanvasLayer/Transition/AnimationPlayer").play("screen_to_transition")
			if get_node_or_null("/root/DungeonEnigme/CanvasLayer/Transition/AnimationPlayer") != null:
				get_node("/root/DungeonEnigme/CanvasLayer/Transition/AnimationPlayer").play("screen_to_transition")
			print("pou")
			await get_tree().create_timer(2).timeout
			get_tree().change_scene_to_file("res://Scenes/main_map.tscn")
			print("rrr")
			Key = false



	



	
