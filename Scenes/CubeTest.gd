extends CharacterBody2D
var speed = 7
var dir = Vector2()
const FLOOR_NORMAL = Vector2(0,-1)
var left = [Vector2(80 , 16), Vector2(48 , 16), Vector2(64 , 16)]
var right = [Vector2(80 , 32), Vector2(48 , 32), Vector2(64 , 32)]
var up = [Vector2(80 , 48), Vector2(48 , 48), Vector2(64 , 48)]
var down = [Vector2(80 , 0), Vector2(48 , 0), Vector2(64 , 0)]
var i = 0

func _ready():
	pass 



func _physics_process(delta):
	
	if Input.is_action_pressed("ui_up"):
		i += 1
		if i > 20:
			i = 0
		position.y += -speed
		get_node("01-generic").region_rect = Rect2(up[i/10][0],up[i/10][1],16,16)
	elif Input.is_action_pressed("ui_down"):
		i += 1
		if i > 20:
			i = 0
		position.y += speed
		get_node("01-generic").region_rect = Rect2(down[i/10][0],down[i/10][1],16,16)
	elif Input.is_action_pressed("ui_right"):
		i += 1
		if i > 20:
			i = 0
		position.x += speed
		get_node("01-generic").region_rect = Rect2(right[i/10][0],right[i/10][1],16,16)
	elif Input.is_action_pressed("ui_left"):
		i += 1
		if i > 20:
			i = 0
		position.x += -speed
		get_node("01-generic").region_rect = Rect2(left[i/10][0],left[i/10][1],16,16)
	else :
		dir.x = 0
	
	

	
func _input(event):
	print(event)
	
