extends CharacterBody2D

# signal player_entering_door_signal
# signal player_entered_door_signal

@export var speed: float = 200

@onready var animated_sprite: AnimatedSprite2D = $player1
@onready var pause_menu = get_node("player1/2/CanvasLayer/GameUI/PopupMenu/PauseMenuScreenContainer") 

func entered_door():
	emit_signal("player_entered_door_signal")

func _physics_process(_delta: float) -> void:
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
		input_velocity = input_velocity.normalized() * speed

	velocity = input_velocity

	move_and_slide()

func PauseMenu ():
	if Global.game_paused == true:
		pause_menu.visible = false
		Engine.time_scale = 1
	elif Global.game_paused == false:
		pause_menu.visible = true
		Engine.time_scale = 0

	Global.game_paused = !Global.game_paused
