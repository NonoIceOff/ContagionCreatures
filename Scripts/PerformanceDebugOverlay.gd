extends CanvasLayer

## Overlay de débogage des performances
## Affiche les FPS, mémoire, et autres statistiques en temps réel
## Utilisation: Ajouter cette scène à votre scène principale ou comme Autoload

@onready var label = $PanelContainer/MarginContainer/VBoxContainer/StatsLabel
@onready var panel = $PanelContainer

var update_interval = 0.5  # Mise à jour toutes les 0.5 secondes
var time_since_update = 0.0
var visible_stats = true

func _ready():
	# Position en haut à gauche
	panel.position = Vector2(10, 10)
	
	# Rendre semi-transparent
	panel.modulate = Color(1, 1, 1, 0.8)
	
	# Cacher par défaut (appuyer sur F3 pour afficher)
	visible = false

func _process(delta):
	time_since_update += delta
	
	if time_since_update >= update_interval:
		time_since_update = 0.0
		update_stats()

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_F3:
			visible = !visible

func update_stats():
	if not visible:
		return
	
	var fps = Engine.get_frames_per_second()
	var process_time = Performance.get_monitor(Performance.TIME_PROCESS) * 1000
	var physics_time = Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS) * 1000
	var render_time = Performance.get_monitor(Performance.TIME_RENDER) * 1000
	
	var memory_static = Performance.get_monitor(Performance.MEMORY_STATIC) / 1024.0 / 1024.0
	var memory_dynamic = Performance.get_monitor(Performance.MEMORY_DYNAMIC) / 1024.0 / 1024.0
	var memory_total = memory_static + memory_dynamic
	
	var objects_in_frame = Performance.get_monitor(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME)
	var draw_calls = Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)
	var vertices = Performance.get_monitor(Performance.RENDER_VERTICES_IN_FRAME)
	
	var nodes_in_tree = get_tree().get_node_count()
	var orphan_nodes = Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)
	
	# Couleur du FPS
	var fps_color = Color.GREEN
	if fps < 45:
		fps_color = Color.ORANGE
	if fps < 30:
		fps_color = Color.RED
	
	var text = ""
	text += "[b]PERFORMANCE MONITOR[/b]\n"
	text += "─────────────────────────\n"
	text += "[color=#%s]FPS: %d[/color]\n" % [fps_color.to_html(false), fps]
	text += "\n"
	
	text += "[b]TEMPS:[/b]\n"
	text += "  Process:  %.2f ms\n" % process_time
	text += "  Physics:  %.2f ms\n" % physics_time
	text += "  Render:   %.2f ms\n" % render_time
	text += "  Frame:    %.2f ms\n" % ((process_time + physics_time + render_time))
	text += "\n"
	
	text += "[b]MÉMOIRE:[/b]\n"
	text += "  Static:   %.1f MB\n" % memory_static
	text += "  Dynamic:  %.1f MB\n" % memory_dynamic
	text += "  Total:    [color=#%s]%.1f MB[/color]\n" % [_get_memory_color(memory_total).to_html(false), memory_total]
	text += "\n"
	
	text += "[b]RENDU:[/b]\n"
	text += "  Objects:  %d\n" % objects_in_frame
	text += "  Draw Calls: %d\n" % draw_calls
	text += "  Vertices: %d\n" % vertices
	text += "\n"
	
	text += "[b]SCENE:[/b]\n"
	text += "  Nodes:    %d\n" % nodes_in_tree
	text += "  Orphans:  [color=#%s]%d[/color]\n" % [_get_orphan_color(orphan_nodes).to_html(false), orphan_nodes]
	text += "\n"
	
	# Info additionnelles si PerformanceOptimizer existe
	if has_node("/root/PerformanceOptimizer"):
		var perf_opt = get_node("/root/PerformanceOptimizer")
		var stats = perf_opt.get_performance_stats()
		text += "[b]CACHES:[/b]\n"
		text += "  Textures: %d\n" % stats.texture_cache_size
		text += "  Scenes:   %d\n" % stats.scene_cache_size
		text += "  Pools:    P:%d E:%d Pr:%d\n" % [stats.particle_pool_size, stats.enemy_pool_size, stats.projectile_pool_size]
		text += "\n"
	
	text += "─────────────────────────\n"
	text += "[i]F3: Toggle | F4: Cleanup[/i]"
	
	label.text = text

func _get_memory_color(memory_mb: float) -> Color:
	if memory_mb < 100:
		return Color.GREEN
	elif memory_mb < 250:
		return Color.YELLOW
	elif memory_mb < 500:
		return Color.ORANGE
	else:
		return Color.RED

func _get_orphan_color(orphans: int) -> Color:
	if orphans == 0:
		return Color.GREEN
	elif orphans < 10:
		return Color.YELLOW
	else:
		return Color.RED
