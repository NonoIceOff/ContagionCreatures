extends CharacterBody2D

signal player_entered_door_signal

@export var speed: float = 200
@export var sprint_multiplier: float = 1.3

@onready var animated_sprite: AnimatedSprite2D = $player1
@onready var pause_menu = $"player1/2/CanvasLayer/GameUI/PopupMenu/PauseMenuScreenContainer"
@onready var player_xp = get_node_or_null("/root/Map3/ui/XPPanel")

@onready var bush_tilemap = get_node_or_null("/root/Map3/TileMap/bush")
@onready var full_screen_map_parent = get_parent().get_parent()

func _ready() -> void:
	Global.ui_visible = true

func entered_door():
	emit_signal("player_entered_door_signal")

func _process(delta):
	Global.party_timer_seconds += delta

func _physics_process(_delta: float) -> void:
	var input_velocity = Vector2.ZERO
	
	# La touche ESC est maintenant gérée dans ui.gd de manière centralisée
		
	if Input.is_action_just_pressed("Space"):
		if player_xp:
			player_xp.gain_xp(100)

	if bush_tilemap != null:
		var position_player_centered = (position+ Vector2(8, 8))/(16*3)
		var tile_id = bush_tilemap.get_cell_source_id(position_player_centered)
		var random = randi() % 100
		if tile_id == 1 and random == 1 and Global.tutorial_stade > 9:
			await _play_combat_transition("res://Scenes/Combat/scène_combat.tscn")

	var can_move = full_screen_map_parent == null or full_screen_map_parent.get_node_or_null("ui/Full_Screen_map") == null
	if can_move:
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

# Fonctions pour le système centralisé d'interfaces
func open_pause():
	if not Global.game_paused:
		pause_menu.visible = true
		Engine.time_scale = 0
		Global.game_paused = true

func close_pause():
	if Global.game_paused:
		pause_menu.visible = false
		Engine.time_scale = 1
		Global.game_paused = false

func _play_combat_transition(scene_path: String):
	# Créer un overlay noir pour la transition
	var overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0)
	overlay.size = get_viewport_rect().size
	overlay.z_index = 100
	get_tree().root.add_child(overlay)
	
	# Animation de la caméra
	var camera = get_node("player1/2")
	Global.ui_visible = false
	
	# DÉMARRER LE CHARGEMENT IMMÉDIATEMENT en arrière-plan
	ResourceLoader.load_threaded_request(scene_path)
	
	# Créer des effets visuels pendant que ça charge
	var tween = create_tween()
	tween.set_parallel(true)
	
	# Zoom sur le joueur
	if is_instance_valid(camera):
		tween.tween_property(camera, "zoom", Vector2(4, 4), 0.8).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(camera, "position", Vector2(16, 16), 0.8).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
	# Shake effect
	for i in range(6):
		var shake_offset = Vector2(randf_range(-5, 5), randf_range(-5, 5))
		tween.tween_property(camera, "offset", shake_offset, 0.1).set_delay(0.8 + i * 0.1)
	
	# Fade to black avec des flashes
	tween.tween_property(overlay, "color", Color(1, 1, 1, 0.8), 0.15).set_delay(1.2)
	tween.tween_property(overlay, "color", Color(0, 0, 0, 0), 0.1).set_delay(1.35)
	tween.tween_property(overlay, "color", Color(1, 1, 1, 0.9), 0.15).set_delay(1.45)
	tween.tween_property(overlay, "color", Color(0, 0, 0, 1), 0.3).set_delay(1.6)
	
	await tween.finished
	
	# Attendre que le chargement soit terminé (si ce n'est pas déjà fait)
	var progress = []
	while true:
		var status = ResourceLoader.load_threaded_get_status(scene_path, progress)
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			break
		elif status == ResourceLoader.THREAD_LOAD_FAILED or status == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			push_error("Échec du chargement de la scène")
			overlay.queue_free()
			return
		await get_tree().process_frame
	
	# Nettoyage de la caméra
	if is_instance_valid(camera):
		camera.offset = Vector2.ZERO
	
	# IMPORTANT : Supprimer l'overlay AVANT de changer de scène
	overlay.queue_free()
	await get_tree().process_frame
	
	# Récupérer la scène chargée et changer
	var new_scene = ResourceLoader.load_threaded_get(scene_path)
	if new_scene:
		get_tree().change_scene_to_packed(new_scene)
