extends CharacterBody2D

@export var speed: float = 200
@export var sprint_multiplier: float = 1.3

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var name_label: Label = $NameLabel

var player_name: String = ""
var player_color: Color = Color.WHITE
var current_animation: String = ""
var animation_speed: float = 1.0

func _ready():
	name_label.text = player_name
	set_player_color(player_color)

func set_player_color(color: Color):
	player_color = color
	animated_sprite.modulate = color
	if is_multiplayer_authority():
		sync_color.rpc(color)

@rpc("any_peer", "reliable")
func sync_color(color: Color):
	if not is_multiplayer_authority():
		player_color = color
		animated_sprite.modulate = color

func _physics_process(_delta: float) -> void:
	if not is_multiplayer_authority():
		return
	
	var input_velocity = Vector2.ZERO
	
	if Input.is_action_pressed("droite"):
		input_velocity.x += 1
		set_animation("EastWalk")
	elif Input.is_action_pressed("gauche"):
		input_velocity.x -= 1
		set_animation("WestWalk")
	elif Input.is_action_pressed("haut"):
		input_velocity.y -= 1
		set_animation("NorthWalk")
	elif Input.is_action_pressed("bas"):
		input_velocity.y += 1
		set_animation("SouthWalk")
	else:
		set_animation("")

	if input_velocity.length() > 0:
		if Input.is_action_pressed("Sprint"):
			input_velocity = input_velocity.normalized() * speed * sprint_multiplier
			set_animation_speed(sprint_multiplier)
		else:
			input_velocity = input_velocity.normalized() * speed
			set_animation_speed(1.0)

	velocity = input_velocity
	move_and_slide()
	
	# Synchronize position to all other players
	sync_position.rpc(position)

# Fonctions pour synchroniser la position
@rpc("any_peer", "unreliable_ordered")
func sync_position(new_position: Vector2):
	if not is_multiplayer_authority():
		position = new_position

# Fonctions pour synchroniser l'animation
func set_animation(anim_name: String):
	if current_animation != anim_name:
		current_animation = anim_name
		sync_animation.rpc(anim_name)
		if anim_name == "":
			animated_sprite.stop()
		else:
			animated_sprite.play(anim_name)

func set_animation_speed(speed_scale: float):
	if animation_speed != speed_scale:
		animation_speed = speed_scale
		sync_animation_speed.rpc(speed_scale)
		animated_sprite.speed_scale = speed_scale

@rpc("any_peer", "reliable")
func sync_animation(anim_name: String):
	if not is_multiplayer_authority():
		current_animation = anim_name
		if anim_name == "":
			animated_sprite.stop()
		else:
			animated_sprite.play(anim_name)

@rpc("any_peer", "reliable")
func sync_animation_speed(speed_scale: float):
	if not is_multiplayer_authority():
		animation_speed = speed_scale
		animated_sprite.speed_scale = speed_scale
