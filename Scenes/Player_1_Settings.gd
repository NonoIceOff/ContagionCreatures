extends CharacterBody2D

var speed = 250


const FLOOR_NORMAL = Vector2(0,-1)
var ray : RayCast2D
signal interact_pressed

const TILE_SIZE = 16





var offset_x = 0
var offset_y = 0

var idle = [ Vector2(29  +  offset_x, 382 +  offset_y),Vector2(29 +  offset_x , 20 +  offset_y),Vector2(29 +  offset_x , 263 + offset_y),  Vector2(29 + offset_x , 143 + offset_y)]
var left = [Vector2(147 + offset_x , 143 + offset_y), Vector2(29 + offset_x , 143 + offset_y) ,Vector2(383 + offset_x , 143 + offset_y)]
var right = [Vector2(147 +  offset_x, 263 +  offset_y), Vector2(29 +  offset_x , 263 + offset_y), Vector2(383 +  offset_x , 263 +  offset_y)]
var up = [Vector2(147 +  offset_x , 382 +  offset_y),Vector2(29  +  offset_x, 382 +  offset_y), Vector2(383 +  offset_x , 382 +  offset_y)]
var down = [Vector2(147 +  offset_x , 20 +  offset_y), Vector2(29 +  offset_x , 20 +  offset_y), Vector2(383 +  offset_x , 20 +  offset_y)]

var i = 0
var direction = 0




func _ready(): 
	ray = $RayCast2D
	



func _physics_process(delta):
	
	if Input.is_action_pressed("haut") or Input.is_action_pressed("ui_up"):
		i += 1
		direction = 0
		if i > 29:
			i = 1
		velocity.x = 0	
		velocity.y = -speed
		move_and_slide()
		get_node("01-generic2").region_rect = Rect2(up[i/10][0],up[i/10][1],100, 98)
	elif Input.is_action_pressed("bas") or Input.is_action_pressed("ui_down"):
		i += 1
		direction = 1
		if i > 29:
			i = 1
		velocity.x = 0
		velocity.y = speed
		move_and_slide()
		get_node("01-generic2").region_rect = Rect2(down[i/10][0],down[i/10][1],100, 98)
	elif Input.is_action_pressed("droite") or Input.is_action_pressed("ui_right"):
		i += 1
		direction = 2
		if i > 29:
			i = 1
		velocity.y = 0
		velocity.x = speed
		move_and_slide()
		get_node("01-generic2").region_rect = Rect2(right[i/10][0],right[i/10][1],100, 98)
	elif Input.is_action_pressed("gauche") or Input.is_action_pressed("ui_left"):
		i += 1
		direction = 3
		if i > 29:
			i = 1
		velocity.y = 0
		velocity.x = -speed
		move_and_slide()
		get_node("01-generic2").region_rect = Rect2(left[i/10][0],left[i/10][1],100, 98)
	else :
		get_node("01-generic2").region_rect = Rect2(idle[direction][0],idle[direction][1],100, 98)


#func _process(delta):
	#if Input.is_action_just_pressed("ui_interact"):
		#emit_signal("interact_pressed")
		
