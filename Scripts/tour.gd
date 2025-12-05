extends Node2D

var hud_enabled = true
var item_types = ["item","attack"]

var intro_var = true

func intro():
	var visible_text = 0
	var intro_state = 0
	get_node("CanvasLayer/DungeonTitle").visible = true
	get_node("Control/TileMap/Player_One/player1/2").zoom = Vector2(.4,.4)
	get_node("Control/TileMap/Player_One/player1/2").position = -get_node("Control/TileMap/Player_One").position+Vector2(700,350)
	for i in 100:
		visible_text += 0.05
		get_node("Control/TileMap/Player_One/player1/2").zoom += Vector2(.001,.001)
		get_node("CanvasLayer/DungeonTitle").modulate.a = visible_text
		await get_tree().create_timer(0.1).timeout
	intro_state = 1
	for i in 50:
		visible_text -= 0.1
		get_node("CanvasLayer/DungeonTitle").modulate.a = visible_text
		await get_tree().create_timer(0.1).timeout
	intro_var = false
	
	get_node("Control/TileMap/Player_One/player1/2").zoom = Vector2(1,1)
	get_node("Control/TileMap/Player_One/PointLight2D").texture_scale = 5
	get_node("Control/TileMap/Player_One/PointLight2D").visible = true
	get_node("Control/TileMap/Player_One/player1/2").position = Vector2(0,0)
	
	
	
func _ready() -> void:
	MusicsPlayer.play_sound("res://Sounds/dungeon_sound.mp3","Musics")
	SaveSystem.load_localisation()
	intro()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_node("Control/TileMap/Player_One/PointLight2D").texture_scale > 1 and intro_var == false:
		get_node("Control/TileMap/Player_One/PointLight2D").texture_scale -= 0.1
