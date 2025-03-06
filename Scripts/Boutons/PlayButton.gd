extends Button

var menu_fade_out = false

func _physics_process(delta):
	if menu_fade_out == true:
		set_modulate(lerp(get_modulate(), Color(1,1,1,0), 0.02))

func _process(delta):
	if float(get_modulate()[3]) <= 0.1:
		get_tree().change_scene_to_file("res://Scenes/map3.tscn")

func _on_pressed():
	get_node("../Sounds").stream = load("res://Sounds/coinc.mp3")
	get_node("../Sounds").playing = true
	menu_fade_out = true
	load_next_scene()
	

func load_next_scene():
	Global.load()
	print(Global.tutorial_stade)
	if Global.tutorial_stade >= 9-9:
		SceneLoader.load_scene("res://Scenes/map3.tscn")
	else:
		SceneLoader.load_scene("res://Scenes/intro.tscn")
	get_node("../Sounds").stream = load("res://Sounds/coinc.mp3")
	get_node("../Sounds").playing = true
