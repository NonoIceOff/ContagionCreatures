extends Node2D

@onready var pause_menu = $PauseMenu
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
