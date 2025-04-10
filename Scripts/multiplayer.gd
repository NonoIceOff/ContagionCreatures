extends Node2D

func _init() -> void:
	Global.load_user()
	if Global.user == null:
		return
	print(Global.user)
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.user != null:
		get_node("Hello").text = "Bonjour "+Global.user.username
		get_node("Points").text = "Vous avez "+str(Global.user.points)+" points"
		get_node("Points").text += "\nVous avez "+str(Global.user.money)+" argent"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/matchmaking.tscn")
