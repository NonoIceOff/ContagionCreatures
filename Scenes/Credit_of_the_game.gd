extends Label

var speed = 20 #vitesse de défilement des crédits

func _ready():
	set_process(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var new_position = position - Vector2(0, speed * delta)
	set_position(new_position)
	
	if position.y < -get_viewport_rect().size.y:
		queue_free() #supprimer les crédits une fois hors de l'écran
