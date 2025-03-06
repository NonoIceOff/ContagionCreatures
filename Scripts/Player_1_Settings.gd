extends CharacterBody2D

# signal player_entering_door_signal
# signal player_entered_door_signal

@export var speed: float = 200

@onready var animated_sprite: AnimatedSprite2D = $player1
# @onready var game_ui = get_tree().get_root().find_child("GameUI", true, false)

func entered_door():
	emit_signal("player_entered_door_signal")

func _physics_process(_delta: float) -> void:
	var input_velocity = Vector2.ZERO
	
	if Input.is_action_just_pressed("échap") and GameUI:
		if GameUI.pause_menu:
			GameUI.toggle_visibility(GameUI.pause_menu)

	if get_node_or_null("../../ui/Full_Screen_map") == null:
		if Input.is_action_pressed("droite"):
			input_velocity.x += 1
			animated_sprite.play("EastWalk")
		elif Input.is_action_pressed("gauche"):
			input_velocity.x -= 1
			animated_sprite.play("WestWalk")
		elif Input.is_action_pressed("haut"):
			input_velocity.y -= 1
			animated_sprite.play("NorthWalk")
		elif Input.is_action_pressed("bas"):
			input_velocity.y += 1
			animated_sprite.play("SouthWalk")
		else:
			animated_sprite.stop()

	if input_velocity.length() > 0:
		input_velocity = input_velocity.normalized() * speed

	velocity = input_velocity

	move_and_slide()

# func PauseMenu ():
# 	if Global.paused == true:
# 		pause_menu.show()
# 		Engine.time_scale = 0
# 		Global.can_move = false
# 	elif Global.paused == false:
# 		pause_menu.hide()
# 		Engine.time_scale = 1
# 		Global.can_move = true
	
# 	Global.paused = !Global.paused
