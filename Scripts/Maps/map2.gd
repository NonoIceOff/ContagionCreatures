extends Node2D

var entered = false
var interacted = false
var pianoscene = preload("res://Scenes/piano.tscn")

func _ready():
	Global.current_map = "map2"
	get_node("/root/map2/CanvasLayer2/Transition/AnimationPlayer").play("transition_to_screen")
	await get_tree().create_timer(0.05).timeout



func _process(delta):
	if Input.is_action_just_pressed("ui_interact") and get_node_or_null("CanvasLayer2/SpeechBox") == null:
		interacted = true
		var scene_source = preload("res://Scenes/speech_box.tscn")
		var scene_instance = scene_source.instantiate()
		
		if get_node_or_null("Piano3/Interact") != null and get_node("Piano3/Interact").visible == true:
			var instance = pianoscene.instantiate()
			instance.piano_id = 2
			get_node("CanvasLayer2").add_child(instance)
			
		if get_node_or_null("Piano4/Interact") != null and get_node("Piano4/Interact").visible == true:
			var instance = pianoscene.instantiate()
			instance.piano_id = 3
			get_node("CanvasLayer2").add_child(instance)


func _on_leave_to_map_1_body_entered(body):
	entered = false
	if body.is_in_group("Player_One"):
		entered = true
		get_node("CanvasLayer2/Transition/AnimationPlayer").play("screen_to_transition")
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://Scenes/main_map.tscn")


func _on_enter_home_map_2_body_entered(body):
	pass # change scene to the house of the Map2


func _on_enter_donjon_body_entered(body):
	entered = false
	if body.is_in_group("Player_One"):
		entered = true
		get_node("/root/map2/CanvasLayer2/Transition/AnimationPlayer").play("screen_to_transition")
		await get_tree().create_timer(0.2).timeout
		var random = randi_range(0,1)
		if random == 0:
			get_tree().change_scene_to_file("res://Scenes/dungeon1.tscn")
		if random == 1:
			get_tree().change_scene_to_file("res://Scenes/dungeon_enigme.tscn")
	

func _on_piano_3_body_entered(body):
	if body.is_in_group("Player_One"):
		get_node("Piano3/Interact").visible = true


func _on_piano_3_body_exited(body):
	if body.is_in_group("Player_One"):
		get_node("Piano3/Interact").visible = false


func _on_piano_4_body_entered(body):
	if body.is_in_group("Player_One"):
		get_node("Piano4/Interact").visible = true


func _on_piano_4_body_exited(body):
	if body.is_in_group("Player_One"):
		get_node("Piano4/Interact").visible = false
