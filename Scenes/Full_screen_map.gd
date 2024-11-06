extends Control

@onready var camera = get_node("SubViewportContainer/SubViewport/Camera2D")

#Point jaune dans la miniMap
var pin
var points_stock: Array = []
var point_placed = false
var point_sprite = ColorRect.new() 

func _ready():
	pin = get_node("/root/main_map/MobPNJ/Ennemy").position
	load_point()
	
	
func _physics_process(delta):
	get_node("AnimationPlayer").current_animation = "pin"
	camera.position = get_node("/root/main_map/Player_One").position
	pin = get_node("/root/main_map/MobPNJ/Ennemy").position
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
		
	get_node("Position").text = "X: "+str(int(get_node("/root/main_map/Player_One").position.x))+"  |  Y: "+str(int(get_node("/root/main_map/Player_One").position.y))

func change_pin(position):
	pin = position
	
	

func _input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var mouse_pos: Vector2 = get_local_mouse_position()
		var previous_pointReplace = points_stock.size()-1
		draw_point(mouse_pos)
		point_placed = true
		points_stock.append(mouse_pos)
		change_pin(mouse_pos)
		saved_point(mouse_pos)
		


func draw_point(position: Vector2):
	point_sprite.color = Color(1,1,0)
	point_sprite.size = Vector2i(11.0, 11.0)
	point_sprite.position = position.round()
	add_child(point_sprite)
	
func clear_point():
	if point_sprite != null:
		point_sprite.queue_free()
		point_placed = false


func saved_point(position : Vector2):
	Global.saved_point_position = position
	print("Save position :", Global.saved_point_position)


func load_point():
	print("Load position :", Global.saved_point_position)
	if Global.saved_point_position != Vector2.ZERO:
		draw_point(Global.saved_point_position)
	else:
		print("ERROR LOADING")
