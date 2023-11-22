extends CharacterBody2D
#@export var SpriteSheets:Array[LPCSpriteSheet]
#@export var DefaultAnimation:LPCAnimation = LPCAnimation.IDLE_DOWN
var speed = 7
const FLOOR_NORMAL = Vector2(0,-1)
var offset_x = 48
var offset_y = 0
var left = [Vector2(80 + offset_x , 16 + offset_y), Vector2(48 + offset_x , 16 + offset_y)]
var right = [Vector2(80 +  offset_x, 32 +  offset_y),Vector2(48 +  offset_x , 32 +  offset_y)]
var up = [Vector2(80 +  offset_x , 48 +  offset_y),Vector2(48 +  offset_x , 48 +  offset_y)]
var down = [Vector2(80 +  offset_x , 0 +  offset_y), Vector2(48 +  offset_x , 0 +  offset_y)]
var i = 0
var direction = -1
var idle = [Vector2(64  +  offset_x, 48 +  offset_y), Vector2(64 +  offset_x , 0 +  offset_y), Vector2(64 +  offset_x , 32 + offset_y) , Vector2(64 + offset_x , 16 + offset_y)]


func _ready():
	pass 



func _physics_process(delta):
	#if Input.is_action_just_pressed("ui_up"):
	#	position.y += -speed
	#	get_node("01-generic").region_rect = Rect2(up[2][1],up[2][1],16,16)
	if Input.is_action_pressed("ui_up"):
		i += 1
		direction = 0
		if i > 19:
			i = 1
		position.y += -speed
		get_node("01-generic").region_rect = Rect2(up[i/10][0],up[i/10][1],16,16)
	elif Input.is_action_pressed("ui_down"):
		i += 1
		direction = 1
		if i > 19:
			i = 1
		position.y += speed
		get_node("01-generic").region_rect = Rect2(down[i/10][0],down[i/10][1],16,16)
	elif Input.is_action_pressed("ui_right"):
		i += 1
		direction = 2
		if i > 19:
			i = 1
		position.x += speed
		get_node("01-generic").region_rect = Rect2(right[i/10][0],right[i/10][1],16,16)
	elif Input.is_action_pressed("ui_left"):
		i += 1
		direction = 3
		if i > 19:
			i = 1
		position.x += -speed
		get_node("01-generic").region_rect = Rect2(left[i/10][0],left[i/10][1],16,16)
	else :
		get_node("01-generic").region_rect = Rect2(idle[direction][0],idle[direction][1],16,16)
		
	
	

	

	
