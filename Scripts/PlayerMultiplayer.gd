extends CharacterBody2D

@export var speed: float = 200
@export var sprint_multiplier: float = 1.3

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var name_label: Label = $NameLabel

var player_name: String = ""

func _ready():
	name_label.text = player_name
	
	if not is_multiplayer_authority():
		return

func _physics_process(_delta: float) -> void:
	if not is_multiplayer_authority():
		return
	
	var input_velocity = Vector2.ZERO
	
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
	
	if velocity.length() > 0:
		sync_position.rpc(position)

@rpc("any_peer", "unreliable")
func sync_position(new_position: Vector2):
	if not is_multiplayer_authority():
		position = new_position
