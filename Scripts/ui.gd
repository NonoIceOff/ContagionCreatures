extends CanvasLayer

@onready var time_label = $PanelDate/Heure 
@onready var day_label = $PanelDate/Jour
@onready var canvas_modulate = $"../CanvasJour_Nuit"
@onready var particules_neige = $Neige
@onready var aurora_particles = $Aurore_boreales


var time_speed = 0.1
var seconds_per_in_game_minute = 1.0

func _init() -> void:
	print("a")

func _ready() -> void:
	print("ok")
	advance_time()
	
func _process(delta: float) -> void:
	print(Global.current_map)
	if Global.current_map != "HomeOfHector":
		get_node("PanelDate").visible = true
		get_node("Minimap").visible = true
	else: 
		get_node("PanelDate").visible = false
		get_node("Minimap").visible = false
	if Quests.current_quest_id > -1 and get_node_or_null("CPUParticles2D") != null:
		get_node("CPUParticles2D").visible = true
		get_node("CPUParticles2D/QuestTextBar").text = "[right][rainbow freq=0.05]"+tr(Quests.quests[Quests.current_quest_id]["title"])+" [/rainbow]\n[color=white][i]"+tr(Quests.quests[Quests.current_quest_id]["mini_descriptions"][Quests.quests[Quests.current_quest_id]["stade"]])
	else:
		get_node("CPUParticles2D").visible = false

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
