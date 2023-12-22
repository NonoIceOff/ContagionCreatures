extends Node2D

var entered = false
var entered_Ennemy = false
var Key = false

func _ready():
	
	get_node("CanvasLayer/Transition/AnimationPlayer").play("transition_to_screen")
	await get_tree().create_timer(0.05).timeout
	get_node("MobPNJ/AreaEnnemy1/Label_E_ennemy").visible = false



func _on_area_ennemy_1_body_entered(body):
	if body.is_in_group("Player_One"):
		entered_Ennemy = true
		get_node("MobPNJ/AreaEnnemy1/Label_E_ennemy").visible = true


func _on_area_ennemy_1_body_exited(body):
	if body.is_in_group("Player_One"):
		entered_Ennemy = false
		get_node("MobPNJ/AreaEnnemy1/Label_E_ennemy").visible = false




func _process(delta):
	print(entered_Ennemy)
	if entered_Ennemy == true and Key == false:
		if Input.is_action_just_pressed("ui_interact"): #and $MobPNJ/AreaEnnemy1/Collision_Ennemy.is_in_group("Player_One"):
			Key = true
			get_node("CanvasLayer/Transition/AnimationPlayer").play("screen_to_transition")
			print("pou")
			await get_tree().create_timer(2).timeout
			get_tree().change_scene_to_file("res://Scenes/scène_combat.tscn")
			print("rrr")
			Key = false
