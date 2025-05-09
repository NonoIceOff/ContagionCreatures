extends CanvasLayer

@onready var time_label = $PanelDate/Heure 
@onready var day_label = $PanelDate/Jour
@onready var canvas_modulate = $"../CanvasJour_Nuit"
@onready var particules_neige = $Neige
@onready var aurora_particles = $Aurore_boreales

var is_open = false
var time_speed = 0.1
var seconds_per_in_game_minute = 1.0


func _ready() -> void:
	if Global.is_daycycle == true:
		advance_time()
	
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if Global.is_speedrun_timer == true:
		get_node("SpeedrunTimer").visible = Global.is_speedrun_timer
		var seconds = int(Global.party_timer_seconds)
		var hours = int(seconds) / 3600
		var minutes = (int(seconds) % 3600) / 60
		var secs = int(seconds) % 60
		get_node("SpeedrunTimer").text = str(hours).pad_zeros(2) + ":" + str(minutes).pad_zeros(2) + ":" + str(secs).pad_zeros(2)


	if Global.tutorial_stade < 10:
		get_node("Informations").visible = true
	get_node("Stats/CoinsLabel").text = str(PlayerStats.money)+" [img=32x32]res://Textures/COIN.png[/img]"

	if Input.is_action_just_pressed("ui_p"):
		if is_open:
			get_node("inv_animal").queue_free()
		else:
			var load_scene = preload("res://Inventory/inv_animals.tscn")
			var load_instance = load_scene.instantiate()
			load_instance.position = Vector2(0,0)
			load_instance.name = "inv_animal"
			add_child(load_instance)
			load_instance.get_node("CanvasLayer").visible = true
		is_open = !is_open

	var panel_date = get_node("PanelDate")
	var minimap = get_node("Minimap")
	var quest_particles = get_node_or_null("CPUParticles2D")

	panel_date.visible = Global.ui_visible and Global.current_map != "HomeOfHector"
	if Global.is_minimap == true:
		minimap.visible = Global.ui_visible and Global.current_map != "HomeOfHector"
	else:
		minimap.visible = false
		get_node("XPPanel").position.y = 932
		get_node("PanelDate").position.y = 932+96

	if Quests.current_quest_id > -1 and quest_particles != null:
		quest_particles.visible = true
		quest_particles.get_node("QuestTextBar").text = "[right][rainbow freq=0.05][b]" + tr(Quests.quests[Quests.current_quest_id]["title"]).to_upper() + " [/b][/rainbow]\n[color=white][i]" + tr(Quests.quests[Quests.current_quest_id]["mini_descriptions"][Quests.quests[Quests.current_quest_id]["stade"]])
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
