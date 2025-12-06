extends Node

## Script d'optimisation globale pour Contagion Creatures
## À utiliser comme Autoload pour appliquer les optimisations au démarrage

class_name PerformanceOptimizer

# Paramètres d'optimisation
var enable_vsync: bool = true
var target_fps: int = 60
var enable_low_processor_mode: bool = false
var low_processor_mode_sleep: float = 0.016  # ~60 FPS

# Pool d'objets réutilisables
var particle_pool: Array = []
var enemy_pool: Array = []
var projectile_pool: Array = []

# Cache de ressources
var texture_cache: Dictionary = {}
var scene_cache: Dictionary = {}

func _ready():
	apply_performance_settings()
	setup_object_pools()
	print("PerformanceOptimizer: Optimisations appliquées")

## Applique les paramètres de performance optimaux
func apply_performance_settings():
	# Configuration VSync
	if enable_vsync:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	
	# Configuration FPS
	Engine.max_fps = target_fps
	
	# Mode faible processeur (utile pour économiser la batterie)
	OS.low_processor_usage_mode = enable_low_processor_mode
	OS.low_processor_usage_mode_sleep_usec = int(low_processor_mode_sleep * 1000000)
	
	# Optimisations physiques
	Engine.physics_ticks_per_second = 60
	Engine.max_physics_steps_per_frame = 8
	
	print("Performance settings applied:")
	print("  - VSync: ", enable_vsync)
	print("  - Target FPS: ", target_fps)
	print("  - Low Processor Mode: ", enable_low_processor_mode)

## Configure les pools d'objets pour réutilisation
func setup_object_pools():
	# Initialiser les pools vides
	particle_pool.clear()
	enemy_pool.clear()
	projectile_pool.clear()
	print("Object pools initialized")

## Récupère une texture depuis le cache ou la charge
func get_cached_texture(path: String) -> Texture2D:
	if texture_cache.has(path):
		return texture_cache[path]
	else:
		var texture = load(path) as Texture2D
		if texture:
			texture_cache[path] = texture
		return texture

## Récupère une scène depuis le cache ou la charge
func get_cached_scene(path: String) -> PackedScene:
	if scene_cache.has(path):
		return scene_cache[path]
	else:
		var scene = load(path) as PackedScene
		if scene:
			scene_cache[path] = scene
		return scene

## Vide le cache de textures (à appeler lors des changements de niveau)
func clear_texture_cache():
	texture_cache.clear()
	print("Texture cache cleared")

## Vide le cache de scènes (à appeler lors des changements de niveau majeurs)
func clear_scene_cache():
	scene_cache.clear()
	print("Scene cache cleared")

## Obtient un objet depuis le pool ou en crée un nouveau
func get_from_pool(pool: Array, scene_path: String) -> Node:
	if pool.size() > 0:
		return pool.pop_back()
	else:
		var scene = get_cached_scene(scene_path)
		if scene:
			return scene.instantiate()
	return null

## Retourne un objet au pool au lieu de le détruire
func return_to_pool(pool: Array, object: Node, max_pool_size: int = 50):
	if pool.size() < max_pool_size:
		object.hide()
		if object.get_parent():
			object.get_parent().remove_child(object)
		pool.append(object)
	else:
		object.queue_free()

## Statistiques de performance
func get_performance_stats() -> Dictionary:
	return {
		"fps": Engine.get_frames_per_second(),
		"process_time": Performance.get_monitor(Performance.TIME_PROCESS),
		"physics_time": Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS),
		"render_objects": Performance.get_monitor(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME),
		"memory_static": Performance.get_monitor(Performance.MEMORY_STATIC) / 1024.0 / 1024.0,  # MB
		"memory_dynamic": Performance.get_monitor(Performance.MEMORY_DYNAMIC) / 1024.0 / 1024.0,  # MB
		"texture_cache_size": texture_cache.size(),
		"scene_cache_size": scene_cache.size(),
		"particle_pool_size": particle_pool.size(),
		"enemy_pool_size": enemy_pool.size(),
		"projectile_pool_size": projectile_pool.size()
	}

## Affiche les stats de performance dans la console
func print_performance_stats():
	var stats = get_performance_stats()
	print("\n=== Performance Stats ===")
	print("FPS: ", stats.fps)
	print("Process Time: ", "%.2f ms" % (stats.process_time * 1000))
	print("Physics Time: ", "%.2f ms" % (stats.physics_time * 1000))
	print("Render Objects: ", stats.render_objects)
	print("Memory Static: ", "%.2f MB" % stats.memory_static)
	print("Memory Dynamic: ", "%.2f MB" % stats.memory_dynamic)
	print("Texture Cache: ", stats.texture_cache_size, " textures")
	print("Scene Cache: ", stats.scene_cache_size, " scenes")
	print("Pools: P:", stats.particle_pool_size, " E:", stats.enemy_pool_size, " Pr:", stats.projectile_pool_size)
	print("========================\n")

## Optimise les nœuds dans une scène
func optimize_scene_nodes(root: Node):
	for child in root.get_children():
		# Désactiver les process inutiles
		if child.has_method("set_process") and not child.has_method("_process"):
			child.set_process(false)
		
		if child.has_method("set_physics_process") and not child.has_method("_physics_process"):
			child.set_physics_process(false)
		
		# Récursif
		if child.get_child_count() > 0:
			optimize_scene_nodes(child)

## Nettoie les ressources non utilisées
func cleanup_unused_resources():
	# Force le garbage collector
	var freed = Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)
	print("Cleaning up ", freed, " orphan nodes...")
	
	# Vide les caches si trop gros
	if texture_cache.size() > 100:
		var to_remove = []
		var count = 0
		for key in texture_cache.keys():
			if count > 50:  # Garder les 50 dernières
				to_remove.append(key)
			count += 1
		
		for key in to_remove:
			texture_cache.erase(key)
		
		print("Cleared ", to_remove.size(), " textures from cache")

## Raccourci clavier pour afficher les stats (F3)
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_F3:
			print_performance_stats()
		elif event.keycode == KEY_F4:
			cleanup_unused_resources()
