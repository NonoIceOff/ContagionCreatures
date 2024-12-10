extends CharacterBody2D

@export var speed: float = 200
@onready var animated_sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	var input_velocity = Vector2.ZERO
	


	# Gestion des entrées utilisateur
	if Input.is_action_pressed("droite"):
		input_velocity.x += 1
	elif Input.is_action_pressed("gauche"):
		input_velocity.x -= 1
	elif Input.is_action_pressed("haut"):
		input_velocity.y -= 1
	elif Input.is_action_pressed("bas"):
		input_velocity.y += 1

	if input_velocity.length() > 0:
		input_velocity = input_velocity.normalized() * speed
		
	velocity = input_velocity

	move_and_slide()
