extends Button

var menu_fade_out = false

@onready var map_scene = preload("res://Scenes/main_map.tscn")

func _ready():
	get_node("../ProgressBar").visible = false

func _physics_process(delta):
	if menu_fade_out == true:
		set_modulate(lerp(get_modulate(), Color(1,1,1,0), 0.02))

func _process(delta):
	if float(get_modulate()[3]) <= 0.1:
		get_tree().change_scene_to_file("res://Scenes/main_map.tscn")

func _on_pressed():
	get_node("../ProgressBar").visible = true
	get_node("../Sounds").stream = load("res://Sounds/coinc.mp3")
	get_node("../Sounds").playing = true
	menu_fade_out = true
	
func load_scene(current_scene,next_scene):
	var loading_scene_instance = map_scene.instance()
	get_tree().get_root().call_deferred("add_child", loading_scene_instance)
	
	var loader = ResourceLoader.load_threaded_request(next_scene)
	if loader == null:
		print("Une erreur ests urvenue lors du chargement de la scène")
		return
	current_scene.queue_free()
	
	await get_tree().create_timer(1000).timeout
	
	while true:
		var error = loader.poll()
		if error == OK:
			get_node("../ProgressBar").value = float(loader.get_stage()/loader.get_stage_count())
			
	
