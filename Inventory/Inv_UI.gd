extends Control

var is_oppen = false

func _ready():
	close()

func _process(delta):
	if Input.is_action_just_pressed("i"):
		if is_oppen:
			close()
		else:
			oppen()

func oppen():
	visible = true
	is_oppen = true
	

func close():
	visible = false
	is_oppen = false
	
