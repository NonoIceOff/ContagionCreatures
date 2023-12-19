extends CharacterBody2D

var speed = 320

var vie = 100
var coins = 0


const FLOOR_NORMAL = Vector2(0,-1)
var ray : RayCast2D

var added_to_list = false

var pseudo = "pseudo"

var offset_x = 0
var offset_y = 0

var idle = [ Vector2(42  +  offset_x, 701 +  offset_y),Vector2(36 +  offset_x , 7 +  offset_y),Vector2(36 +  offset_x , 475 + offset_y),  Vector2(42 + offset_x , 245 + offset_y)]
var left = [Vector2(254 + offset_x , 246 + offset_y), Vector2(36 + offset_x , 245 + offset_y) ,Vector2(705 + offset_x , 246 + offset_y)]#, Vector2(705 +  offset_x , 245 +  offset_y)]
var right = [Vector2(254 +  offset_x, 475 +  offset_y), Vector2(36 +  offset_x , 475 + offset_y), Vector2(716 +  offset_x , 479 +  offset_y)]#, Vector2(716 +  offset_x , 475 +  offset_y)]
var up = [Vector2(259 +  offset_x , 701 +  offset_y),Vector2(42  +  offset_x, 701 +  offset_y), Vector2(716 +  offset_x , 701 +  offset_y)]#, Vector2(716 +  offset_x , 701 +  offset_y)]
var down = [Vector2(254 +  offset_x , 7 +  offset_y), Vector2(36 +  offset_x , 7 +  offset_y), Vector2(705 +  offset_x , 7 +  offset_y)]#, Vector2(705 +  offset_x , 7 +  offset_y)]

var i = 0
var direction = 0

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())
	get_node("HUD/Name").text = str(pseudo)
	if is_multiplayer_authority() and not added_to_list:
		get_node("Camera2D").enabled = true
	else:
		get_node("Camera2D").enabled = false
	if str(name) == "1":
		var player_list_label = get_node("../CanvasLayer/Stats/PlayerListLabel")
		player_list_label.text += "\n[font_size=16]Joueur " + str(pseudo) + "[/font_size]\n"
		added_to_list = true


func _ready(): 
	if not is_multiplayer_authority(): return
	get_node("HUD").visible = false
	
func _process(delta):
	if not is_multiplayer_authority(): return
	coins += 1
	get_node("HUD/Coins/Label").text = str(coins)
	get_node("HUD/Vie").value = vie
	get_node("../CanvasLayer/Stats/Coins/Label").text = str(coins)
	get_node("../CanvasLayer/Stats/Vie").value = vie

@rpc("any_peer")
func add_to_list(player_name):
	print("Received RPC to add", player_name, "to the list.")
	var player_list_label = get_node("../CanvasLayer/Stats/PlayerListLabel")
	player_list_label.text += "[font_size=16]Joueur " + str(player_name) + "[/font_size]\n"
	print("Added", player_name, "to the list.")
	print(multiplayer.get_unique_id())


func _physics_process(_delta):
	if is_multiplayer_authority():
		get_node("HUD/Name").text = str(pseudo)
		
		if Input.is_action_pressed("haut") or Input.is_action_pressed("ui_up"):
			i += 1
			direction = 0
			if i > 29:
				i = 1
			velocity.x = 0	
			velocity.y = -speed
			move_and_slide()
			get_node("01-generic2").region_rect = Rect2(up[i/10][0],up[i/10][1],180, 180)
		elif Input.is_action_pressed("bas") or Input.is_action_pressed("ui_down"):
			i += 1
			direction = 1
			if i > 29:
				i = 1
			velocity.x = 0
			velocity.y = speed
			move_and_slide()
			get_node("01-generic2").region_rect = Rect2(down[i/10][0],down[i/10][1],180, 180)
		elif Input.is_action_pressed("droite") or Input.is_action_pressed("ui_right"):
			i += 1
			direction = 2
			if i > 29:
				i = 1
			velocity.y = 0
			velocity.x = speed
			move_and_slide()
			get_node("01-generic2").region_rect = Rect2(right[i/10][0],right[i/10][1],180, 180)
		elif Input.is_action_pressed("gauche") or Input.is_action_pressed("ui_left"):
			i += 1
			direction = 3
			if i > 29:
				i = 1
			velocity.y = 0
			velocity.x = -speed
			move_and_slide()
			get_node("01-generic2").region_rect = Rect2(left[i/10][0],left[i/10][1],180, 180)
		else :
			get_node("01-generic2").region_rect = Rect2(idle[direction][0],idle[direction][1],180, 180)
