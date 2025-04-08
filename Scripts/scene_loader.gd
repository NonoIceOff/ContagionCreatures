extends Node

@onready var loading_screen_scene = preload("res://Scenes/loading_screen.tscn")

var scene_to_load_path
var loading_screen_scene_instance
var loading = false

func load_scene(path):
	var current_scene = get_tree().current_scene
	
	# Instanciation et affichage de l'écran de chargement
	loading_screen_scene_instance = loading_screen_scene.instantiate()
	get_tree().root.call_deferred("add_child", loading_screen_scene_instance)
	await get_tree().process_frame  # S'assurer que l'écran de chargement s'affiche
	
	# Démarrer le chargement en arrière-plan
	if ResourceLoader.has_cached(path):
		ResourceLoader.load_threaded_get(path)
	else:
		ResourceLoader.load_threaded_request(path)
		
	# Libération de l'ancienne scène après l'affichage de l'écran de chargement
	current_scene.queue_free()
	
	loading = true
	scene_to_load_path = path
	
func _process(delta):
	if not loading or not scene_to_load_path:
		return
	
	var progress = []
	var status = ResourceLoader.load_threaded_get_status(scene_to_load_path, progress)
	
	if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		var progressbar = loading_screen_scene_instance.get_node("ProgressBar")
		progressbar.value = progress[0] * 100  # Converti en pourcentage

		var label = loading_screen_scene_instance.get_node("Label")
		
		# Récupération des fichiers actuellement chargés
		var dependencies = ResourceLoader.get_dependencies(scene_to_load_path)
		if dependencies.size() > 0:
			label.text = "Chargement : " + dependencies[min(dependencies.size() - 1, int(progress[0] * dependencies.size()))]
		else:
			label.text = "Chargement en cours..."

	elif status == ResourceLoader.THREAD_LOAD_LOADED:
		var new_scene = ResourceLoader.load_threaded_get(scene_to_load_path)
		if new_scene:
			get_tree().change_scene_to_packed(new_scene)
		else:
			print("Erreur de chargement : la scène est invalide.")
			
		loading_screen_scene_instance.queue_free()
		loading = false
	else:
		print("Le chargement a échoué.")
