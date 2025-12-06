extends Node

@onready var loading_screen_scene = preload("res://Scenes/loading_screen.tscn")

var scene_to_load_path
var loading_screen_scene_instance
var loading = false
var last_progress = 0.0  # Pour éviter les mises à jour inutiles

func load_scene(path):
	# Vérifier si on essaie de charger la même scène
	if loading and scene_to_load_path == path:
		return
	
	var current_scene = get_tree().current_scene
	
	# Instanciation et affichage de l'écran de chargement
	loading_screen_scene_instance = loading_screen_scene.instantiate()
	get_tree().root.call_deferred("add_child", loading_screen_scene_instance)
	await get_tree().process_frame  # S'assurer que l'écran de chargement s'affiche
	
	# Démarrer le chargement en arrière-plan
	if ResourceLoader.has_cached(path):
		# Scène déjà en cache, pas besoin de recharger
		var cached_scene = ResourceLoader.load_threaded_get(path)
		if cached_scene:
			_change_to_scene(cached_scene)
			return
	else:
		ResourceLoader.load_threaded_request(path)
		
	# Libération de l'ancienne scène après l'affichage de l'écran de chargement
	if current_scene:
		current_scene.queue_free()
	
	loading = true
	scene_to_load_path = path
	last_progress = 0.0

func _change_to_scene(scene_resource):
	get_tree().change_scene_to_packed(scene_resource)
	if loading_screen_scene_instance:
		loading_screen_scene_instance.queue_free()
		loading_screen_scene_instance = null
	loading = false
	scene_to_load_path = ""
	
func _process(delta):
	if not loading or not scene_to_load_path:
		return
	
	var progress = []
	var status = ResourceLoader.load_threaded_get_status(scene_to_load_path, progress)
	
	if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		# Optimisation: ne mettre à jour que si le progrès a changé significativement
		if abs(progress[0] - last_progress) > 0.01:  # Mise à jour tous les 1%
			last_progress = progress[0]
			
			if loading_screen_scene_instance:
				var progressbar = loading_screen_scene_instance.get_node("ProgressBar")
				progressbar.value = progress[0] * 100  # Converti en pourcentage

				var label = loading_screen_scene_instance.get_node("Label")
				
				# Récupération des fichiers actuellement chargés
				var dependencies = ResourceLoader.get_dependencies(scene_to_load_path)
				if dependencies.size() > 0:
					var dep_index = min(dependencies.size() - 1, int(progress[0] * dependencies.size()))
					label.text = "Chargement : " + dependencies[dep_index]
				else:
					label.text = "Chargement en cours..."

	elif status == ResourceLoader.THREAD_LOAD_LOADED:
		var new_scene = ResourceLoader.load_threaded_get(scene_to_load_path)
		if new_scene:
			_change_to_scene(new_scene)
		else:
			push_error("Erreur de chargement : la scène est invalide.")
			if loading_screen_scene_instance:
				loading_screen_scene_instance.queue_free()
			loading = false
	else:
		push_error("Le chargement a échoué.")
		if loading_screen_scene_instance:
			loading_screen_scene_instance.queue_free()
		loading = false
