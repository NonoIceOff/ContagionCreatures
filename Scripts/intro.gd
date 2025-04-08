extends Node2D

const ZOOM_SPEED = 0.1
const TIMER_INTERVAL = 0.01
const PLAYER1_TARGET_Y = 880
const PLAYER1_TARGET_X = 1132

var brazero_in_area = false 
var exit_in_area = false
var enter_in_area = false
var door_in_area = false

var camera = []
	
func _process(delta: float) -> void:
	camera = get_tree().get_nodes_in_group("camera")
	var player1 = get_node("Control/TileMap/Player_One/player1")
	var tilemap = get_node("Control/TileMap")
	var sounds = get_node("Sounds")
	var audio_player = get_node("AudioStreamPlayer2D")

	match Global.tutorial_stade:
		2:
			player1.speed_scale = 0
			audio_player.stream_paused = true
			
			await get_tree().create_timer(1).timeout
			get_node("CanvasLayer/CPUParticles2D").visible = false
			Global.smooth_zoom(camera[0], 1, Vector2(-32, -32), 0.1)
			Global.tutorial_stade = 3
			
		3:
			player1.speed_scale = 0
			if sounds.stream != load("res://Sounds/enigma_solved.mp3"):
				sounds.stream = load("res://Sounds/enigma_solved.mp3")
				sounds.play()
			get_node("CanvasLayer/CPUParticles2D").visible = false
			Global.tutorial_stade = 4
		4:
			player1.speed_scale = 0
			get_node("Control/CPUParticles2D").emitting = true
			get_node("CanvasLayer/CPUParticles2D").visible = false
			await get_tree().create_timer(2).timeout
			audio_player.stream_paused = false
			
			Global.smooth_zoom(camera[0], 1.8, Vector2(16, 16), 0.1)
			get_node("Control/TileMap").erase_cell(1,Vector2(13,16))
			get_node("Control/TileMap").erase_cell(1,Vector2(13,15))
			get_node("Control/TileMap").erase_cell(1,Vector2(14,15))
			get_node("Control/TileMap").erase_cell(1,Vector2(15,15))
			get_node("Control/TileMap").erase_cell(1,Vector2(15,16))
			get_node("Control/CPUParticles2D").emitting = false
			
			Global.tutorial_stade = 5
		5:
			player1.speed_scale = 0
			get_node("CanvasLayer/CPUParticles2D/QuestTextBar").text = "SORTEZ DU DONJON"
			await get_tree().create_timer(1).timeout
			if sounds.stream != load("res://Sounds/explosion.mp3"):
				sounds.stream = load("res://Sounds/explosion.mp3")
				sounds.play()
			var shake_amount = 1
			var shake_duration = 0.5
			var shake_timer = shake_duration
			get_node("CanvasLayer/Chute").emitting = true
			while shake_timer > 0:
				var shake_offset = Vector2(randf_range(-shake_amount, shake_amount), randf_range(-shake_amount, shake_amount))
				camera[0].position += shake_offset
				await get_tree().create_timer(TIMER_INTERVAL).timeout
				camera[0].position -= shake_offset
				shake_timer -= TIMER_INTERVAL
			get_node("CanvasLayer/Timer").visible = true
			get_node("CanvasLayer/Timer").time_left = 20.0
			get_node("CanvasLayer/CPUParticles2D").visible = true
			
			Global.tutorial_stade = 6
		6:
			get_node("CanvasLayer/Chute").emitting = false
			

	player1.play()
	
	get_node("Control/TileMap/BrazeroIntro/Label_E_Home").visible = brazero_in_area
	get_node("Control/TileMap/ExitArea/Label_E_Home").visible = exit_in_area
	get_node("Control/TileMap/EnterArea/Label_E_Home").visible = enter_in_area
	get_node("Control/TileMap/DoorArea/Label_E_Home").visible = door_in_area
	
	if get_node("CanvasLayer/Timer").time_left <= 0:
		get_tree().change_scene_to_file("res://Scenes/intro.tscn")
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_interact"):
		if brazero_in_area == true:
			get_node("Control/TileMap/PointLight2D5").visible = true
			MusicsPlayer.play_sound("res://Sounds/flame_sound.mp3","Bus1")
			Global.tutorial_stade = 2
		if exit_in_area == true:
			MusicsPlayer.play_sound("res://Sounds/hurt.mp3","Player")
			get_node("Control/TileMap/Player_One").position = Vector2(224,532)
		if enter_in_area == true:
			MusicsPlayer.play_sound("res://Sounds/hurt.mp3","Player")
			get_node("Control/TileMap/Player_One").position = Vector2(224,250)
		if door_in_area == true:
			SceneLoader.load_scene("res://Scenes/map3.tscn")
	
func _on_brazero_intro_body_entered(body: Node2D) -> void:
	if Global.tutorial_stade <= 6 and body.is_in_group("Player_One"):
		brazero_in_area = true

func _on_brazero_intro_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player_One"):
		brazero_in_area = false


func _on_exit_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player_One"):
		exit_in_area = true


func _on_exit_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player_One"):
		exit_in_area = false


func _on_enter_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player_One"):
		enter_in_area = true


func _on_enter_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player_One"):
		enter_in_area = false


func _on_door_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player_One"):
		door_in_area = true


func _on_door_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player_One"):
		door_in_area = true
