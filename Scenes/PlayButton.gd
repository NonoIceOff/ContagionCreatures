extends Button

var menu_fade_out = false

func _physics_process(delta):
	if menu_fade_out == true:
		set_modulate(lerp(get_modulate(), Color(1,1,1,0), 0.02))

func _process(delta):
	if float(get_modulate()[3]) <= 0.1:
		get_tree().change_scene_to_file("res://Scenes/main_map.tscn")
		print("aaaa")

func _on_pressed():
	get_node("../Sounds").stream = load("res://Sounds/coinc.mp3")
	get_node("../Sounds").playing = true
	menu_fade_out = true
