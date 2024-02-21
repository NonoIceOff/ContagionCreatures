extends Node2D


@onready var pause_menu = $Player_One/Camera2D/CanvasLayer/PauseMenu
@onready var global_vars = get_node("/root/Global")
var paused = false
var Key = false
var entered_Ennemy = false
var item_scene = preload("res://Scenes/item.tscn")
var interacted = false
var scene_load = false

func _ready():
	get_node("CanvasLayer/Transition/AnimationPlayer").play("transition_to_screen")
	await get_tree().create_timer(0.05).timeout
	get_node("MobPNJ/AreaEnnemy1/Label_E_ennemy").visible = false
	$InteractArea/Trigger.visible = true
	$InteractArea/Interact.visible = Global.interact
	spawn_item(Vector2(0,0),"item",1)


func _process(_delta):
	
	if Input.is_action_just_pressed("échap"):
		PauseMenu()
		
	if $InteractArea/Interact.visible == true:
		if Input.is_action_just_pressed("ui_interact"):
			interacted = true
			var scene_source = preload("res://Scenes/speech_box.tscn")
			var scene_instance = scene_source.instantiate()
			get_node("CanvasLayer2").add_child(scene_instance)
			interacted = false	

	if entered_Ennemy == true and Key == false:
		if Input.is_action_just_pressed("ui_interact"): #and $MobPNJ/AreaEnnemy1/Collision_Ennemy.is_in_group("Player_One"):
			Key = true
			get_node("CanvasLayer/Transition/AnimationPlayer").play("screen_to_transition")
			await get_tree().create_timer(2).timeout
			get_tree().change_scene_to_file("res://Scenes/scène_combat.tscn")
			Key = false

	if Input.is_action_just_pressed("M"):
		if scene_load == false:
			print("cc")
			var load_scene = preload("res://Scenes/Full_screen_map.tscn")
			var load_instance = load_scene.instantiate()
			load_instance.position = Vector2(0,0)
			get_node("CanvasLayer/Minimap").visible = false
			get_node("CanvasLayer").add_child(load_instance)
			
			scene_load = true

		elif scene_load == true:
			get_node("CanvasLayer/Full_Screen_map").queue_free()
			get_node("CanvasLayer/Minimap").visible = true
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
	

func _on_area_ennemy_1_body_entered(body):
	if body.is_in_group("Player_One"):
		entered_Ennemy = true
		get_node("MobPNJ/AreaEnnemy1/Label_E_ennemy").visible = true


func _on_area_ennemy_1_body_exited(body):
	if body.is_in_group("Player_One"):
		entered_Ennemy = false
		get_node("MobPNJ/AreaEnnemy1/Label_E_ennemy").visible = false

func _on_interact_area_entered(body):
	if body.is_in_group("Player_One"):
		$InteractArea/Interact.visible = true



func _on_interact_area_exited(body):
	if body.is_in_group("Player_One"):
		$InteractArea/Interact.visible = false

func spawn_item(pos,type,id):
	var item_instance = item_scene.instantiate()
	item_instance.position = pos
	item_instance.id = id
	item_instance.type = type
	if type == "item":
		item_instance.get_node("Texture").texture = load(Global.items[id]["texture"])
	if type == "attack":
		item_instance.get_node("Texture").texture = load(Global.attacks[id]["texture"])
	add_child(item_instance)
	
func _on_entered_transition_map(body):
	var entered_area = false
	if body.is_in_group("Player_One"):
		entered_area = true
		get_node("/root/main_map/CanvasLayer/Transition/AnimationPlayer").play("screen_to_transition")
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://Scenes/map2.tscn")
	


func _on_interact_area_body_entered(body):
	if body.is_in_group("Player_One"):
		print("aaa")
		$InteractArea/Interact.visible = true


func _on_interact_area_body_exited(body):
	if body.is_in_group("Player_One"):
		$InteractArea/Interact.visible = false
