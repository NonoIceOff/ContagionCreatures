extends Node2D

@onready var canvas_layer = $CanvasLayer2
@onready var transition_anim = $CanvasLayer2/Transition/AnimationPlayer
@onready var piano3_interact = $Piano3/Interact
@onready var piano4_interact = $Piano4/Interact

var entered = false
var interacted = false
var pianoscene = preload("res://Scenes/piano.tscn")

func _ready():
	Global.current_map = "map2"
	if transition_anim:
		transition_anim.play("transition_to_screen")
	await get_tree().create_timer(0.05).timeout



func _process(delta):
	if Input.is_action_just_pressed(Controllers.a_input) and canvas_layer and canvas_layer.get_node_or_null("SpeechBox") == null:
		interacted = true
		
		if piano3_interact and piano3_interact.visible:
			var instance = pianoscene.instantiate()
			instance.piano_id = 2
			canvas_layer.add_child(instance)
			
		if piano4_interact and piano4_interact.visible:
			var instance = pianoscene.instantiate()
			instance.piano_id = 3
			canvas_layer.add_child(instance)


func _on_leave_to_map_1_body_entered(body):
	entered = false
	if body.is_in_group("Player_One"):
		entered = true
		if transition_anim:
			transition_anim.play("screen_to_transition")
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://Scenes/Maps/map3.tscn")
func _on_enter_home_map_2_body_entered(body):
	pass # change scene to the house of the Map2


func _on_enter_donjon_body_entered(body):
	entered = false
	if body.is_in_group("Player_One"):
		entered = true
		if transition_anim:
			transition_anim.play("screen_to_transition")
		await get_tree().create_timer(0.2).timeout
		var random = randi_range(0,1)
		if random == 0:
			get_tree().change_scene_to_file("res://Scenes/dungeon1.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/Dungeons/dungeon_enigme.tscn")
	

func _on_piano_3_body_entered(body):
	if body.is_in_group("Player_One") and piano3_interact:
		piano3_interact.visible = true


func _on_piano_3_body_exited(body):
	if body.is_in_group("Player_One") and piano3_interact:
		piano3_interact.visible = false


func _on_piano_4_body_entered(body):
	if body.is_in_group("Player_One") and piano4_interact:
		piano4_interact.visible = true


func _on_piano_4_body_exited(body):
	if body.is_in_group("Player_One") and piano4_interact:
		piano4_interact.visible = false
