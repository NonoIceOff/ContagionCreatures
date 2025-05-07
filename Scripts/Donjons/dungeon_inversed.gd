extends Node2D

var hud_enabled = true
var item_scene = preload("res://Scenes/item.tscn")
var intro_var = true
var torch_orders = [
		[0,0,0,0,0],
		[0,0,0,0,0],
		[0,0,0,0,0],
		[0,0,0,0,0]
	]
var actual_ordre = [0,0,0,0,0]

func shuffle_orders():
	for i in torch_orders.size():
		var index = 1
		var placed = false
		for j in 5:
			placed = false
			while placed == false:
				var random_index = randi_range(0,4)
				if torch_orders[i][random_index] == 0:
					torch_orders[i][random_index] = index
					placed = true
			index += 1
	print(torch_orders)

func add_torch(id):
	var index_dispo = 0
	var line = 0
	for i in actual_ordre.size():
		if actual_ordre[i] != 0:
			index_dispo += 1
	actual_ordre[index_dispo] = id
	print(actual_ordre)

func check_torch_order(line):
	for i in torch_orders[line].size():
		if torch_orders[line][i] != actual_ordre[i]:
			return false
	return true
	
func reset_torches(line):
	for i in range(1+line*5,line*5+5+1):
		actual_ordre = [0,0,0,0,0]
		print("Brazero1-"+str(i))
		var torch_pos = Vector2(-4+(2*i-1)-1,-1)
		print(torch_pos)
		get_node("Control/TileMap").set_cell(0, torch_pos, 0, Vector2(7,10), 0)
		get_node("Control/TileMap").set_cell(1, torch_pos+Vector2(0,-1), 0, Vector2(-1,-1), 0)
		get_node("Brazero1-"+str(i)).clicked = false
		get_node("Brazero1-"+str(i)+"/PointLight2D").visible = false

func intro():
	var visible_text = 0
	var intro_state = 0
	get_node("CanvasLayer/DungeonTitle").visible = true
	get_node("Control/TileMap/Player_One/player1/2").zoom = Vector2(.4,.4)
	get_node("Control/TileMap/Player_One/player1/2").position = -get_node("Control/TileMap/Player_One").position+Vector2(0,-800)
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
	SaveSystem.load_localisation()
	shuffle_orders()
	Global.brazero_numbers = 0
	intro()

	get_node("/root/DungeonInversed/CanvasLayer/Transition/AnimationPlayer").play("transition_to_screen")
	await get_tree().create_timer(0.3).timeout
	get_node("Control").visible = true

func _process(delta: float) -> void:
	if get_node("Control/TileMap/Player_One/PointLight2D").texture_scale > 1 and intro_var == false:
		get_node("Control/TileMap/Player_One/PointLight2D").texture_scale -= 0.1
	
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
