extends Node2D

const ZOOM_SPEED = 0.1
const TIMER_INTERVAL = 0.01
const PLAYER1_TARGET_Y = 880
const PLAYER1_TARGET_X = 1132

var camera = []

func _process(delta: float) -> void:
	camera = get_tree().get_nodes_in_group("camera")
	var player1 = get_node("Control/player1")
	var tilemap = get_node("Control/TileMap")
	var sounds = get_node("Sounds")
	var audio_player = get_node("AudioStreamPlayer2D")

	player1.speed_scale = 0.8

	match Global.tutorial_stade:
		0:
			player1.position.y -= 100 * delta
			player1.animation = "NorthWalk"
			if player1.position.y < PLAYER1_TARGET_Y:
				Global.tutorial_stade = 1
		1:
			player1.position.x += 100 * delta
			player1.animation = "EastWalk"
			if player1.position.x > PLAYER1_TARGET_X:
				tilemap.set_cell(1, Vector2i(19, 14), 0, Vector2i(9, 10))
				tilemap.set_cell(1, Vector2i(19, 13), 0, Vector2i(9, 9))
				tilemap.get_node("PointLight2D5").visible = true
				sounds.play()
				Global.tutorial_stade = 2
		2:
			player1.speed_scale = 0
			audio_player.stream_paused = true
			await get_tree().create_timer(1).timeout
			Global.smooth_zoom(camera[0], 1, Vector2(-32, -32), 0.1)
			Global.tutorial_stade = 3
		3:
			player1.speed_scale = 0
			if sounds.stream != load("res://Sounds/enigma_solved.mp3"):
				sounds.stream = load("res://Sounds/enigma_solved.mp3")
				sounds.play()
			Global.tutorial_stade = 4
		4:
			player1.speed_scale = 0
			await get_tree().create_timer(2).timeout
			audio_player.stream_paused = false
			Global.smooth_zoom(camera[0], 1.8, Vector2(16, 16), 0.1)
			Global.tutorial_stade = 5
		5:
			player1.speed_scale = 0
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
			Global.tutorial_stade = 6
		6:
			get_node("CanvasLayer/Chute").emitting = false
			player1.speed_scale = 0.8 * 2
			player1.position.x -= 200 * delta
			player1.animation = "WestWalk"
			if player1.position.x < 1000:
				Global.tutorial_stade = 7
		7:
			player1.speed_scale = 0.8 * 2
			player1.position.y += 200 * delta
			player1.animation = "SouthWalk"
			if player1.position.y > 1000:
				Global.tutorial_stade = 8
		8:
			SceneLoader.load_scene("res://Scenes/map3.tscn")
			Global.tutorial_stade = 9

	player1.play()
