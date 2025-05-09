extends CharacterBody2D

signal player_entered_door_signal

@export var speed: float = 200
@export var sprint_multiplier: float = 1.3

@onready var animated_sprite: AnimatedSprite2D = $player1
@onready var pause_menu = $"player1/2/CanvasLayer/GameUI/PopupMenu/PauseMenuScreenContainer"
@onready var player_xp = get_node_or_null("/root/Map3/ui/XPPanel") 

func _ready() -> void:
	Global.ui_visible = true

func entered_door():
	emit_signal("player_entered_door_signal")

func _physics_process(_delta: float) -> void:
	var input_velocity = Vector2.ZERO
	
	if Input.is_action_just_pressed("échap"):
		PauseMenu()
		
	if Input.is_action_just_pressed("Space"):
		player_xp.gain_xp(100)

	## Détection d'un tile, si le joueur est sur un tile spécifique (l'id 3) alors print
	if get_node_or_null("/root/Map3/TileMap/bush") != null:
		var position_player_centered = (position+ Vector2(8, 8))/(16*3)
		var tile_id = get_node("/root/Map3/TileMap/bush").get_cell_source_id(position_player_centered)
		var random = randi() % 100
		if tile_id == 1 and random == 1 and Global.tutorial_stade > 9:
			SaveSystem.save()
			Global.smooth_zoom(get_node("player1/2"), 4, Vector2(16,16), 0.1)
			Global.ui_visible = false
			await get_tree().create_timer(5).timeout
			SceneLoader.load_scene("res://Scenes/scène_combat.tscn")
			#if player_xp:
				#print("Player XP node found, gaining XP.")
				#player_xp.gain_xp(50)
			#else:
				#print("Error: player_xp node not found! Verify the path.")

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
	if Global.game_paused == false:
		pause_menu.visible = true
		Engine.time_scale = 0
	elif Global.game_paused == true:
		pause_menu.visible = false 
		Engine.time_scale = 1
	
	Global.game_paused = !Global.game_paused
