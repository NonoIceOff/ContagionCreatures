extends Control

@onready var camera = get_node("SubViewportContainer/SubViewport/Camera2D")

var pin

func _ready():
	pin = get_node("/root/main_map/MobPNJ/Ennemy").position
	
func _physics_process(delta):
	get_node("AnimationPlayer").current_animation = "pin"
	camera.position = owner.find_child("Player_One").position
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
	
