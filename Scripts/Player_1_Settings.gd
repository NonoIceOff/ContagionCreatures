extends CharacterBody2D

# signal player_entering_door_signal
# signal player_entered_door_signal

@export var speed: float = 200
@export var speed_multi = Global.sprint_multiplier

@onready var animated_sprite: AnimatedSprite2D = $player1
@onready var pause_menu = get_node("player1/2/CanvasLayer/GameUI/PopupMenu/PauseMenuScreenContainer")
#@onready var pause_menu = $"player1/2/CanvasLayer/PauseMenu"
@onready var player_light = $PointLight2D


var current_night_hour: int = 20
var current_night_minute: int = 20
var current_day_hour: int = 6

func entered_door():
	emit_signal("player_entered_door_signal")
	
func _physics_process(delta: float) -> void:
	var input_velocity = Vector2.ZERO
	var current_hour = Global.current_hour
	var current_minute = Global.current_minute
	
	if Input.is_action_just_pressed("échap"):
		print("échap")
		PauseMenu()

	## Détection d'un tile, si le joueur est sur un tile spécifique (l'id 3) alors print
	if get_node_or_null("/root/Map3/TileMap/bush") != null:
		var position_player_centered = (position+ Vector2(8, 8))/(16*3) 
		var tile_id = get_node("/root/Map3/TileMap/bush").get_cell_source_id(position_player_centered)
		var random = randi() % 50
		if tile_id == 1 and random == 1:
			SceneLoader.load_scene("res://Scenes/scène_combat.tscn")

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
			input_velocity = input_velocity.normalized() * speed * speed_multi
			animated_sprite.speed_scale = speed_multi
		else:
			input_velocity = input_velocity.normalized() * speed
			animated_sprite.speed_scale = 1

	velocity = input_velocity

	move_and_slide()
	

	var total_minutes = current_hour * 60 + current_minute
	var night_start_minutes = current_night_hour * 60 + current_night_minute
	var day_start_minutes = current_day_hour * 60

	if total_minutes >= night_start_minutes or total_minutes < day_start_minutes:
		player_light.visible = true
	else:
		player_light.visible = false

func PauseMenu ():
	if Global.game_paused == true:
		pause_menu.visible = false
		Engine.time_scale = 1
	elif Global.game_paused == false:
		pause_menu.visible = true
		Engine.time_scale = 0

	Global.game_paused = !Global.game_paused
