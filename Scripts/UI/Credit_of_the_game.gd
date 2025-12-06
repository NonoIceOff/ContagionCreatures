extends Control

var speed = 50 # vitesse de défilement des crédits

func _ready():
	set_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var new_position = position - Vector2(0, speed * delta)
	set_position(new_position)
	
