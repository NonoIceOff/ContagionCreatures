extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.user_enemy = {"id":1,"username":"Nonoice","email":"nolan.lameille@gmail.com","password":"admin","points":0,"money":"0.00"}
	print("ennemy : ",Global.user_enemy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
