extends Sprite2D
var speed = 75
var dir = Vector2()
const FLOOR_NORMAL = Vector2(0,-1)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_pressed("ui_up"): 
		position.y += -speed
	elif Input.is_action_pressed("ui_down"):
		position.y += speed
	elif Input.is_action_pressed("ui_right"):
		position.x += speed
	elif Input.is_action_pressed("ui_left"):
		position.x += -speed
	else :
		dir.x = 0
	

	
func _input(event):
	print(event)
	
