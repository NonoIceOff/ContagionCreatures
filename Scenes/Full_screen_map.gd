extends Control

@onready var camera = get_node("SubViewportContainer/SubViewport/Camera2D")

#Point jaune dans la miniMap
var pin
var points_stock: Array = []
#var point_player : ColorRect = null

func _ready():
	pin = get_node("/root/main_map/MobPNJ/Ennemy").position
	#var point_sprite = ColorRect.new()
	#point_sprite.color = Color(1,1,0)
	#point_sprite = Rect2(0,0,16,16)
	#add_child(point_sprite)
	
	
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
	

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var mouse_pos: Vector2 = get_local_mouse_position()
		var previous_pointReplace = points_stock.size()-1
		if previous_pointReplace >= 0:
			points_stock[previous_pointReplace] = mouse_pos
		else:
			points_stock.append(mouse_pos)
		draw_point(mouse_pos)
		points_stock.append(mouse_pos)

func draw_point(position: Vector2) -> void:
	var point_sprite = ColorRect.new() 
	point_sprite.color = Color(1,1,0)
	point_sprite.size = Vector2i(8.0, 8.0)
	point_sprite.position = position.round()
	add_child(point_sprite)

