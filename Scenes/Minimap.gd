extends Control

@onready var camera = get_node("SubViewportContainer/SubViewport/Camera2D")
#Point jaune dans la miniMap
var pin
var map
var player

func change_map():
	match map:
		1:
			get_node("SubViewportContainer/SubViewport/TileMap").visible = true
			get_node("SubViewportContainer/SubViewport/TileMap2").visible = false
			get_node("SubViewportContainer/SubViewport/TileMap3").visible = false
			pin = Vector2(0,0)
			player = get_node("/root/main_map/Player_One")
		2:
			get_node("SubViewportContainer/SubViewport/TileMap").visible = false
			get_node("SubViewportContainer/SubViewport/TileMap2").visible = true
			get_node("SubViewportContainer/SubViewport/TileMap3").visible = false
			pin = Vector2(0,0)
			player = get_node("/root/map2/Player_One")
		3:
			get_node("SubViewportContainer/SubViewport/TileMap").visible = false
			get_node("SubViewportContainer/SubViewport/TileMap2").visible = false
			get_node("SubViewportContainer/SubViewport/TileMap3").visible = true
			pin = Vector2(0,0)
			player = get_node("/root/HomeOfHector/Control/Player_One")
	
	#showPoint_miniMap()
	
func _physics_process(delta):
	get_node("AnimationPlayer").current_animation = "pin"
	camera.position = player.position
	var point_pos = pin - camera.position
	get_node("PinPoint").position = point_pos *0.1 + get_node("PlayerPoint").position
	
	if get_node("PinPoint").position.x < 20:
		get_node("PinPoint").position.x = 20
		
	if get_node("PinPoint").position.y < 20:
		get_node("PinPoint").position.y = 20
		
	if get_node("PinPoint").position.x > 32+180:
		get_node("PinPoint").position.x = 32+180
		
	if get_node("PinPoint").position.y > 32+180:
		get_node("PinPoint").position.y = 32+180
		
	get_node("Position").text = "X: "+str(int(player.position.x))+"  |  Y: "+str(int(player.position.y))

func change_pin(position):
	pin = position
	
	
	
	
#func draw_point(position: Vector2):
	#Global.point_sprite.color = Color(1,1,0)
	#Global.point_sprite.size = Vector2i(11.0, 11.0)
	#Global.point_sprite.position = position.round()
	#add_child(Global.point_sprite)
	
	
#func showPoint_miniMap():
	#if Global.saved_point_position != Vector2.ZERO:
		#print("aaaaaaaaaaaah")
		#draw_point(Global.saved_point_position)
	
	
