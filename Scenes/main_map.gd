extends Node2D

@onready var pause_menu = $Player_One/Camera2D/CanvasLayer/PauseMenu
@onready var global_vars = get_node("/root/Global")
var paused = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("échap"):
		PauseMenu()


func PauseMenu():
	if paused == false:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	
	paused = !paused
	


func NPCInteract():
	while Global.interact == true :
		if Input.is_action_just_pressed("ui_interact"):
			print("test")
			var scene_source = preload("res://Scenes/speech_box.tscn")
			var scene_instance = scene_source.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE) 
			add_child(scene_instance)
		