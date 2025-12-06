extends Node

var pnj_scene = load("res://Scenes/PNJ.tscn")

class PNJ:
	var id: int
	var over_texture: String
	var under_texture: String
	var name: String

	func _init(id, over_texture, under_texture, name):
		self.id = id
		self.over_texture = over_texture
		self.under_texture = under_texture
		self.name = name

class Quest:
	var id: int
	var title: String
	var long_description: String
	var descriptions: Array
	var mini_descriptions: Array
	var pin_positions: Array
	var stade: int = 0
	var finished: bool = false
	var pnj_data: Array
	var contafont_mode: bool = false
	
	var members_only: bool = false

	func _init(id, title, long_description, descriptions, mini_descriptions, pin_positions, pnj_data, members_only = false, stade = 0, contafont_mode = false):
		self.id = id
		self.title = title
		self.long_description = long_description
		self.descriptions = descriptions
		self.mini_descriptions = mini_descriptions
		self.pin_positions = pin_positions
		self.pnj_data = pnj_data
		self.members_only = members_only
		self.stade = 0
		self.contafont_mode = contafont_mode

var current_quest_id = -1

var sage_pnj = PNJ.new(
	0,
	"res://Textures/Head-old-Guy-REAL.png",
	"res://Textures/Old_guy_who_lost_is_crampté_REAL.png",
	"Vieux sage"
)

var bagird_pnj = PNJ.new(
	1,
	"res://Textures/PNJ/Bagird/bagird_full.png",
	"res://Textures/PNJ/Bagird/tete_bagird.png",
	"Bagird"
)

var loytan_pnj = PNJ.new(
	2,
	"res://Textures/PNJ/Loytan/loytan_full.png",
	"res://Textures/PNJ/Loytan/tete_loytan.png",
	"Loytan"
)

var prisme_gardien_pnj = PNJ.new(
	3,
	"res://Textures/PNJ/Bagird/bagird_full.png",
	"res://Textures/PNJ/Bagird/tete_bagird.png",
	"Gardien Prisme"
)

var echo_chercheur_pnj = PNJ.new(
	4,
	"res://Textures/PNJ/Bagird/bagird_full.png",
	"res://Textures/PNJ/Bagird/tete_bagird.png",
	"Chercheur Echo"
)

var essence_alchimiste_pnj = PNJ.new(
	5,
	"res://Textures/Old_guy_who_lost_is_crampté_REAL.png",
	"res://Textures/Head-old-Guy-REAL.png",
	"Alchimiste Essence"
)

var relique_historien_pnj = PNJ.new(
	6,
	"res://Textures/PNJ/Loytan/loytan_full.png",
	"res://Textures/PNJ/Loytan/tete_loytan.png",
	"Historien Relique"
)

var quests = {}


func add_quest(quest_data: Dictionary) -> void:
	## Création d'instances "Quest" et application des données
	var new_quest = Quest.new(
		quest_data.get("id"),
		quest_data.get("title"),
		quest_data.get("long_description"),
		quest_data.get("descriptions"),
		quest_data.get("mini_descriptions"),
		quest_data.get("pin_positions").map(func(pos):return [pos.x, pos.y, pos.map]),
		quest_data.get("pnj_data").map(func(pnj_entry):
				var pnj
				match pnj_entry[0]:
					"bagird_pnj":
						pnj = bagird_pnj
					"sage_pnj":
						pnj = sage_pnj
					"loytan_pnj":
						pnj = loytan_pnj
					"prisme_gardien_pnj":
						pnj = prisme_gardien_pnj
					"echo_chercheur_pnj":
						pnj = echo_chercheur_pnj
					"essence_alchimiste_pnj":
						pnj = essence_alchimiste_pnj
					"relique_historien_pnj":
						pnj = relique_historien_pnj
					_:
						pnj = bagird_pnj
				return [pnj, pnj_entry[1]],
			),
		quest_data.get("members_only", false),
		quest_data.get("stade", 0),
		quest_data.get("contafont_mode", false)
	)
	quests[new_quest.id] = new_quest

func load_quests_from_files() -> void:
	var directories = ["res://Constantes/Quests/", "user://Quests/"] ## Dossiers à scanner pour les quêtes
	
	for dir_path in directories:
		var dir = DirAccess.open(dir_path) ## Ouvrir le répertoire
		
		if dir:
			dir.list_dir_begin() ## Lister le contenu du répertoire
			var file_name = dir.get_next() ## Obtenir le prochain fichier
			while file_name != "":
				if file_name.ends_with(".json"):
					var file_path = dir_path + file_name
					var file = FileAccess.open(file_path, FileAccess.READ) ## Ouvrir le fichier
					if file:
						## Créer un objet JSON et parser le contenu du fichier
						var json = JSON.new() 
						var parse_result = json.parse(file.get_as_text())
						if parse_result == OK:
							add_quest(json.get_data())
						file.close()
				file_name = dir.get_next()
			dir.list_dir_end()
	

func _ready() -> void:
	load_quests_from_files()

func init_pnj(map):
	for i in quests.size():
		if quests.has(i):
			var quest = quests.get(i)
			var quest_stade = quest.stade
			if quest_stade < quest.pin_positions.size():
				var pin_pos = quest.pin_positions[quest_stade]
				var pnj_map = pin_pos["map"] if typeof(pin_pos) == TYPE_DICTIONARY else pin_pos[2]
				if pnj_map == map:
					spawn_pnj(i)

func spawn_pnj(quest_id):
	var i = quest_id
	var quest = quests.get(i)
	if not quest:
		return
	
	var quest_stade = quest.stade
	if quest_stade >= quest.pnj_data.size():
		return
	
	var pnj_stade_data = quest.pnj_data[quest_stade]
	if pnj_stade_data.size() < 2:
		return
	
	var pnj_name = pnj_stade_data[0]
	var dialogue_data = pnj_stade_data[1]
	var pnj_texture = pnj_stade_data[2] if pnj_stade_data.size() > 2 else ""
	var pnj_position_data = pnj_stade_data[3] if pnj_stade_data.size() > 3 else {}
	var pnj_sound = pnj_stade_data[4] if pnj_stade_data.size() > 4 else ""
	
	if quest_stade >= quest.pin_positions.size():
		return
	
	var pin_pos = quest.pin_positions[quest_stade]
	var pnj_position: Vector2
	var map: String
	
	if pnj_position_data.has("x") and pnj_position_data.has("y"):
		pnj_position = Vector2(pnj_position_data["x"], pnj_position_data["y"])
	else:
		if typeof(pin_pos) == TYPE_DICTIONARY:
			pnj_position = Vector2(pin_pos.get("x", 0), pin_pos.get("y", 0))
		elif typeof(pin_pos) == TYPE_ARRAY and pin_pos.size() >= 2:
			pnj_position = Vector2(pin_pos[0], pin_pos[1])
		else:
			return
	
	if typeof(pin_pos) == TYPE_DICTIONARY:
		map = pin_pos.get("map", "")
	elif typeof(pin_pos) == TYPE_ARRAY and pin_pos.size() >= 3:
		map = pin_pos[2]
	else:
		return

	var instance = pnj_scene.instantiate()
	instance.position = pnj_position
	instance.quest_id = i
	instance.name = "Quest"+str(i)
	instance.pnj_name = pnj_name
	instance.quest_stade = quest_stade
	instance.dialogue_data = dialogue_data  # Peut être Dict ou Array
	instance.over_texture = pnj_texture
	instance.under_texture = pnj_texture
	instance.sound_file = pnj_sound
	
	if get_node_or_null("/root/" + map) == null:
		return
	else:
		get_node("/root/" + map).add_child(instance)

func delete_pnj(map, quest_id):
	var node_name = "Quest" + str(quest_id)
	var node = get_node_or_null("/root/" + map + "/" + node_name)
	if node != null:
		node.queue_free()

func respawn_pnj(map, quest_id):
	delete_pnj(map, quest_id)
	await get_tree().process_frame
	await get_tree().process_frame  # Double frame pour s'assurer que le free() est terminé
	spawn_pnj(quest_id)


func quest_finished(i):
	var quest = quests.get(i, null)
	if not quest:
		return
	
	var current_map = "/root/" + Global.current_map
	var sound_fx = get_node_or_null(current_map + "/SoundEffectFx")
	var ui_terminated_quest = get_node_or_null(current_map + "/ui/TerminatedQuest")
	var audio_player = get_node_or_null(current_map + "/AudioStreamPlayer2D")

	if sound_fx:
		sound_fx.playing = false

	if ui_terminated_quest:
		if audio_player:
			audio_player.stream = load("res://Sounds/victory.mp3")
			audio_player.playing = true

		ui_terminated_quest.visible = true
		ui_terminated_quest.get_node("Name").text = quest.title
		await get_tree().create_timer(5).timeout
		ui_terminated_quest.visible = false

func set_quest(i):
	var current_map = "/root/" + Global.current_map
	var minimap = get_node_or_null(current_map + "/ui/Minimap")
	var particles = get_node_or_null(current_map + "/ui/CPUParticles2D")

	if i == -1:
		if particles:
			particles.visible = false
	else:
		current_quest_id = i
		if minimap and particles:
			particles.visible = true
			var pin_pos = quests[i].pin_positions[quests[i].stade]
			# Convertir [x, y, map] en Vector2(x, y)
			minimap.change_pin(Vector2(pin_pos[0], pin_pos[1]))

func advance_stade(quest_id = current_quest_id):
	var quest = quests.get(quest_id)
	if not quest:
		return
	
	# Avancer le stade
	quest.stade += 1
	
	# Vérifier si la quête est terminée
	if quest.stade >= quest.descriptions.size():
		quest.finished = true
		delete_pnj(Global.current_map, quest_id)
		await quest_finished(quest_id)
	else:
		# Respawner le PNJ pour le nouveau stade
		await respawn_pnj(Global.current_map, quest_id)
