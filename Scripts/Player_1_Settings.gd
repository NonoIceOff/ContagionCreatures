extends CharacterBody2D

signal player_entering_door_signal
signal player_entered_door_signal

@export var speed: float = 200
@export var sprint_multiplier: float = 1.3

@onready var animated_sprite: AnimatedSprite2D = $player1
@onready var pause_menu = $"player1/2/CanvasLayer/PauseMenu"

func entered_door():
	emit_signal("player_entered_door_signal")
	
func _physics_process(delta: float) -> void:
	var input_velocity = Vector2.ZERO
	
	if Input.is_action_just_pressed("échap"):
		PauseMenu()

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
		if Input.is_action_pressed("Sprint"):
			input_velocity = input_velocity.normalized() * speed * sprint_multiplier
			animated_sprite.speed_scale = sprint_multiplier
		else:
			input_velocity = input_velocity.normalized() * speed
			animated_sprite.speed_scale = 1

	velocity = input_velocity

	move_and_slide()

func PauseMenu():
	if Global.paused == true:
		pause_menu.show()
		Engine.time_scale = 0
		Global.can_move = false
	elif Global.paused == false:
		pause_menu.hide()
		Engine.time_scale = 1
		Global.can_move = true
	
	Global.paused = !Global.paused
