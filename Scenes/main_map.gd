extends Node2D

@onready var pause_menu = $Player_One/Camera2D/CanvasLayer/PauseMenu
@onready var global_vars = get_node("/root/Global")
var paused = false
var Key = false
var entered_Ennemy = false
var item_scene = preload("res://Scenes/item.tscn")

func _ready():
	get_node("CanvasLayer/Transition/AnimationPlayer").play("transition_to_screen")
	await get_tree().create_timer(0.05).timeout
	get_node("MobPNJ/AreaEnnemy1/Label_E_ennemy").visible = false
	
	spawn_item(Vector2(0,0),"item",1)
	


func _process(_delta):
	if Input.is_action_just_pressed("échap"):
		PauseMenu()
	if entered_Ennemy == true and Key == false:
		if Input.is_action_just_pressed("ui_interact"): #and $MobPNJ/AreaEnnemy1/Collision_Ennemy.is_in_group("Player_One"):
			Key = true
			get_node("CanvasLayer/Transition/AnimationPlayer").play("screen_to_transition")
			print("pou")
			await get_tree().create_timer(2).timeout
			get_tree().change_scene_to_file("res://Scenes/scène_combat.tscn")
			print("rrr")
			Key = false


func PauseMenu():
	if paused == false:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	
	paused = !paused
	

func _on_area_ennemy_1_body_entered(body):
	if body.is_in_group("Player_One"):
		entered_Ennemy = true
		get_node("MobPNJ/AreaEnnemy1/Label_E_ennemy").visible = true


func _on_area_ennemy_1_body_exited(body):
	if body.is_in_group("Player_One"):
		entered_Ennemy = false
		get_node("MobPNJ/AreaEnnemy1/Label_E_ennemy").visible = false



func NPCInteract():
	while Global.interact == true :
		if Input.is_action_just_pressed("ui_interact"):
			print("test")
			var scene_source = preload("res://Scenes/speech_box.tscn")
			var scene_instance = scene_source.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE) 
			add_child(scene_instance)

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
	
