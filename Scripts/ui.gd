extends CanvasLayer

@onready var time_label = $PanelDate/Heure 
@onready var day_label = $PanelDate/Jour
@onready var canvas_modulate = get_node_or_null("../CanvasJour_Nuit")
@onready var particules_neige = $Neige
@onready var aurora_particles = $Aurore_boreales

# Cache des nodes
@onready var speedrun_timer = $SpeedrunTimer
@onready var informations = $Informations
@onready var coins_label = $Stats/CoinsLabel
@onready var panel_date = $PanelDate
@onready var minimap = $Minimap
@onready var xp_panel = $XPPanel
@onready var skill_tree = $SkillTree  # La vraie SkillTree instanciée, pas celle dans InfoTouches
@onready var quest_menu = $QuestMenu

# Système centralisé de gestion des interfaces - UNE SEULE À LA FOIS
enum InterfaceType { NONE, INVENTORY, SKILL_TREE, QUEST_MENU, MAP, INVENTORY_ITEMS, PAUSE }
var current_interface = InterfaceType.NONE

var time_speed = 0.1
var seconds_per_in_game_minute = 1.0
var inv_animal_instance = null
var map_instance = null
var inv_items_reference = null

# Vérifie les nodes au démarrage
var _debug_ready = false


func _ready() -> void:
	# Configure l'UI pour continuer à fonctionner pendant la pause
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	skill_tree = get_node_or_null("SkillTree")
	quest_menu = get_node_or_null("QuestMenu")
	
	if Global.is_daycycle == true:
		advance_time()

	_debug_ready = true

# Vérifie si une interface est ouverte
func is_interface_open() -> bool:
	return current_interface != InterfaceType.NONE

# Ouvre ou ferme l'inventaire
func toggle_inventory() -> void:
	if current_interface == InterfaceType.INVENTORY:
		if inv_animal_instance:
			inv_animal_instance.queue_free()
			inv_animal_instance = null
		current_interface = InterfaceType.NONE
	else:
		if current_interface != InterfaceType.NONE:
			close_current_interface()
		var load_scene = preload("res://Inventory/inv_animals.tscn")
		inv_animal_instance = load_scene.instantiate()
		add_child(inv_animal_instance)
		if inv_animal_instance.has_method("open"):
			inv_animal_instance.open()
		current_interface = InterfaceType.INVENTORY


# Ouvre ou ferme le skill tree
func toggle_skill_tree() -> void:
	if current_interface == InterfaceType.SKILL_TREE:
		if skill_tree and skill_tree.has_method("close"):
			skill_tree.close()
		elif skill_tree:
			skill_tree.visible = false
		current_interface = InterfaceType.NONE
	elif current_interface == InterfaceType.NONE:
		if skill_tree:
			if skill_tree.has_method("open"):
				skill_tree.open()
			else:
				skill_tree.visible = true
			current_interface = InterfaceType.SKILL_TREE


# Ouvre ou ferme le menu des quêtes
func toggle_quest_menu() -> void:
	if current_interface == InterfaceType.QUEST_MENU:
		if quest_menu and quest_menu.has_method("close"):
			quest_menu.close()
		elif quest_menu:
			quest_menu.visible = false
		current_interface = InterfaceType.NONE
	elif current_interface == InterfaceType.NONE:
		if quest_menu:
			if quest_menu.has_method("open"):
				quest_menu.open()
			else:
				quest_menu.visible = true
			current_interface = InterfaceType.QUEST_MENU


# Ouvre ou ferme la map
func toggle_map() -> void:
	if current_interface == InterfaceType.MAP:
		get_tree().paused = false
		if map_instance:
			map_instance.queue_free()
			map_instance = null
		if minimap:
			minimap.visible = true
		current_interface = InterfaceType.NONE
	else:
		# Ferme toute interface ouverte avant d'ouvrir la map
		if current_interface != InterfaceType.NONE:
			close_current_interface()
		# Maintenant ouvre la map
		var load_scene = preload("res://Scenes/Full_screen_map.tscn")
		map_instance = load_scene.instantiate()
		add_child(map_instance)
		if map_instance is CanvasItem:
			map_instance.z_index = 100
		if minimap:
			minimap.visible = false
		current_interface = InterfaceType.MAP


# Ouvre ou ferme l'inventaire items (I)
func toggle_inventory_items() -> void:
	if inv_items_reference == null:
		var player = get_tree().get_first_node_in_group("Player_One")
		if player:
			inv_items_reference = player.get_node_or_null("Inv_UI")
	
	if current_interface == InterfaceType.INVENTORY_ITEMS:
		if inv_items_reference and inv_items_reference.has_method("close"):
			inv_items_reference.close()
		elif inv_items_reference:
			inv_items_reference.visible = false
		current_interface = InterfaceType.NONE
	elif current_interface == InterfaceType.NONE:
		if inv_items_reference:
			if inv_items_reference.has_method("open"):
				inv_items_reference.open()
			else:
				inv_items_reference.visible = true
			current_interface = InterfaceType.INVENTORY_ITEMS


# Ouvre ou ferme le menu pause (ESC)
func toggle_pause() -> void:
	if current_interface == InterfaceType.PAUSE:
		var player = get_tree().get_first_node_in_group("Player_One")
		if player and player.has_method("close_pause"):
			player.close_pause()
		current_interface = InterfaceType.NONE
	else:
		if current_interface != InterfaceType.NONE:
			close_current_interface()
		var player = get_tree().get_first_node_in_group("Player_One")
		if player and player.has_method("open_pause"):
			player.open_pause()
			current_interface = InterfaceType.PAUSE


# Ferme l'interface actuellement ouverte
func close_current_interface() -> void:
	match current_interface:
		InterfaceType.INVENTORY:
			toggle_inventory()
		InterfaceType.SKILL_TREE:
			toggle_skill_tree()
		InterfaceType.QUEST_MENU:
			toggle_quest_menu()
		InterfaceType.MAP:
			toggle_map()
		InterfaceType.INVENTORY_ITEMS:
			toggle_inventory_items()
		InterfaceType.PAUSE:
			toggle_pause()
	
func _process(delta: float) -> void:
	if Global.is_speedrun_timer == true:
		speedrun_timer.visible = true
		var seconds = int(Global.party_timer_seconds)
		var hours = int(seconds) / 3600
		var minutes = (int(seconds) % 3600) / 60
		var secs = int(seconds) % 60
		speedrun_timer.text = str(hours).pad_zeros(2) + ":" + str(minutes).pad_zeros(2) + ":" + str(secs).pad_zeros(2)


	if Global.tutorial_stade < 10:
		informations.visible = true
	coins_label.text = str(PlayerStats.money)+" [img=32x32]res://Textures/COIN.png[/img]"

	# Gestion des touches pour ouvrir/fermer les interfaces
	if Input.is_action_just_pressed("ui_p"):
		toggle_inventory()
	
	if Input.is_action_just_pressed("Skill_tree"):
		toggle_skill_tree()
	
	if Input.is_action_just_pressed("q"):
		toggle_quest_menu()
	
	if Input.is_action_just_pressed("M"):
		toggle_map()
	
	if Input.is_action_just_pressed("i"):
		toggle_inventory_items()
	
	# ESC : Si une interface est ouverte, la fermer. Sinon ouvrir le menu pause
	if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("échap"):
		if current_interface == InterfaceType.PAUSE:
			toggle_pause()  # Fermer le pause
		elif current_interface != InterfaceType.NONE:
			close_current_interface()  # Fermer l'interface ouverte
		else:
			toggle_pause()  # Ouvrir le pause
	
	var quest_particles = get_node_or_null("CPUParticles2D")

	panel_date.visible = Global.ui_visible and Global.current_map != "HomeOfHector"
	
	# Gérer la minimap - ne pas afficher si la fullscreen map est ouverte
	if minimap:
		if current_interface == InterfaceType.MAP:
			minimap.visible = false  # Masquer si fullscreen map ouverte
		elif Global.is_minimap == true:
			minimap.visible = Global.ui_visible and Global.current_map != "HomeOfHector"
		else:
			minimap.visible = false
			xp_panel.position.y = 932
			panel_date.position.y = 932+96

	if Quests.current_quest_id > -1 and quest_particles != null and Quests.quests.has(Quests.current_quest_id):
		var quest = Quests.quests.get(Quests.current_quest_id)
		if quest and quest.stade < quest.mini_descriptions.size():
			quest_particles.visible = true
			quest_particles.get_node("QuestTextBar").text = "[right][rainbow freq=0.05][b]" + tr(quest.title).to_upper() + " [/b][/rainbow]\n[color=white][i]" + tr(quest.mini_descriptions[quest.stade])
		else:
			quest_particles.visible = false
	else:
		if quest_particles != null:
			quest_particles.visible = false

func advance_time() -> void:
	while true:
		await get_tree().create_timer(seconds_per_in_game_minute).timeout
		Global.current_minute += 1
		if Global.current_minute >= 60:
			Global.current_minute = 0
			Global.current_hour += 1
			if Global.current_hour >= 24:
				Global.current_hour = 0
				Global.current_day += 1
				print("Nouvelle journée commence !")
				trigger_daily_events()

		update_lighting(Global.current_hour, Global.current_minute)
		time_label.text = format_time(Global.current_hour, Global.current_minute)
		day_label.text = "Jour : " + str(Global.current_day)

func format_time(hour: int, minute: int) -> String:
	var hour_string = "0" + str(hour) if hour < 10 else str(hour)
	var minute_string = "0" + str(minute) if minute < 10 else str(minute)
	return hour_string + ":" + minute_string

# Ajuster l'éclairage en fonction de l'heure et des minutes
func update_lighting(hour: int, minute: int) -> void:
	var time_in_day = hour + minute / 60.0

	# Définir les couleurs cibles en fonction de l'heure
	if time_in_day >= 5 and time_in_day < 7:
		Global.target_color = Color(0.8, 0.7, 0.6, 1)  # Crépuscule
	elif time_in_day >= 7 and time_in_day < 17:
		Global.target_color = Color(1, 1, 1, 1) # Jour
	elif time_in_day >= 17 and time_in_day < 20:
		Global.target_color = Color(0.8, 0.7, 0.6, 1)  # Crépuscule
	else:
		Global.target_color = Color(0.2, 0.2, 0.4, 1)  # Nuit

	#get_node("/root/Global").last_color = Global.target_color
	if canvas_modulate:
		canvas_modulate.color = canvas_modulate.color.lerp(Global.target_color, 0.1)
	

func trigger_daily_events():
	# Réinitialiser tous les événements
	for event in Global.daily_events.keys():
		Global.daily_events[event]["active"] = false

	var random_roll = randi() % 100
	var cumulative_chance = 0
	for event in Global.daily_events.keys():
		# Vérifiez que les aurores boréales ne se déclenchent que la nuit
		if event == "aurora_borealis" and (Global.current_hour < 20 or Global.current_hour >= 3):
			continue  # Sauter si ce n'est pas la nuit

		cumulative_chance += Global.daily_events[event]["chance"]
		if random_roll < cumulative_chance:
			Global.daily_events[event]["active"] = true
			print("Événement déclenché :", event)
			handle_event(event)
			break

func handle_event(event: String) -> void:
	match event:
		"aurora_borealis":
			print("Aurores boréales ! Le ciel est magnifique.")
			particules_neige.emitting = false
			aurora_particles.emitting = true
		"snowstorm":
			print("Tempête de neige ! La visibilité est réduite.")
			particules_neige.emitting = true
			aurora_particles.emitting = false
		"clear_sky":
			print("Ciel dégagé. Rien de spécial aujourd’hui.")
			particules_neige.emitting = false
			aurora_particles.emitting = false
