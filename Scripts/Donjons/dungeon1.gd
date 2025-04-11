extends Node2D

var hud_enabled = true
const maze = preload("res://Maze/tile_map.tscn")
var item_scene = preload("res://Scenes/item.tscn")
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
	
	get_node("Control/TileMap/Player_One/player1/2").zoom = Vector2(2,2)
	get_node("Control/TileMap/Player_One/PointLight2D").texture_scale = 5
	get_node("Control/TileMap/Player_One/PointLight2D").visible = true
	get_node("Control/TileMap/Player_One/player1/2").position = Vector2(0,0)
	
	
	
func _ready() -> void:
	MusicsPlayer.play_sound("res://Sounds/dungeon_sound.mp3","Musics")
	Global.load_localisation()
	intro()
	
	#for x in range(0,64,16):
	#	for y in range(0,64,16):
	#		var random_type = randi_range(0,item_types.size()-1)
	#		var random_item = 0
	#		if random_type == 0:
	#			random_item = randi_range(1,Global.items.size())
	#		if random_type == 1:
	#			random_item = randi_range(1,Global.attacks.size())
	#		spawn_item(Vector2(x,y)*32+Vector2(8,8),item_types[random_type],random_item)
	get_node("/root/Dungeon1/CanvasLayer/Transition/AnimationPlayer").play("transition_to_screen")
	get_node("Control").visible = true

#func on_fringe_changed():
	$CanvasLayer/spots_visited_column.text = "\n".join(Global.letters_to_show)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_node("Control/TileMap/Player_One/PointLight2D").texture_scale > 1 and intro_var == false:
		get_node("Control/TileMap/Player_One/PointLight2D").texture_scale -= 0.1
	
	$CanvasLayer/spots_visited_column.text = "\n".join(Global.letters_to_show)
	


func _on_grid_size_slider_value_changed(value: float) -> void:
	Global.grid_size = value


func _on_solve_speed_slider_value_changed(value: float) -> void:
	Global.step_delay = value


func _on_allow_loops_toggled(button_pressed: bool) -> void:
	Global.allow_loops = button_pressed


func _on_show_labels_toggled(button_pressed: bool) -> void:
	Global.show_labels = button_pressed
	$CanvasLayer/spots_visited_column.set_visible(button_pressed)
	
func spawn_item(pos,type,id):
	var item_instance = item_scene.instantiate()
	item_instance.position = pos
	item_instance.id = id
	item_instance.type = type
	if type == "item":
		item_instance.get_node("Texture").texture = load(Global.items[id]["texture"])
	if type == "attack":
		item_instance.get_node("Texture").texture = load(Global.attacks[id]["texture"])
	add_child(item_instance)
