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
				if pnj_entry[0] == "bagird_pnj":
					pnj = bagird_pnj
				elif pnj_entry[0] == "sage_pnj":
					pnj = sage_pnj
				else:
					pnj = bagird_pnj
				return [pnj, pnj_entry[1]],
			),
		quest_data.get("members_only", false),
		quest_data.get("stade", 0),
		quest_data.get("contafont_mode", false)
	)
	print(new_quest.id)
	quests[new_quest.id] = new_quest ## Application de la quête à la liste des quêtes

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
						else:
							print("Error parsing JSON: ", parse_result)
						
						file.close()
				file_name = dir.get_next()
			dir.list_dir_end()
	

func _ready() -> void:
	load_quests_from_files()

func init_pnj(map):
	for i in quests.size():
		spawn_pnj(i)

func spawn_pnj(quest_id):
	var i = quest_id
	var quest_stade = quests.get(i).stade
	var pnj_position = Vector2(quests.get(i).pin_positions[quests.get(i).stade][0], quests.get(i).pin_positions[quests.get(i).stade][1])
	var map = quests.get(i).pin_positions[quests.get(i).stade][2]
	print("Map sur pnj: " + map)
	var dialogue_data = quests.get(i).pnj_data[quest_stade][1]
	var pnj_data = quests.get(i).pnj_data[quest_stade][0]

	var instance = pnj_scene.instantiate()
	instance.position = Vector2(pnj_position)
	instance.quest_id = i
	instance.name = "Quest"+str(i)
	instance.pnj_name = pnj_data.name
	instance.quest_stade = quest_stade
	instance.dialogue_data = dialogue_data
	instance.over_texture = pnj_data.over_texture
	instance.under_texture = pnj_data.under_texture
	if get_node_or_null("/root/" + map) == null:
		print("Map not found: " + map)
		return
	else:
		get_node("/root/" + map).add_child(instance)

func delete_pnj(map, quest_id):
	print("oui")
	var node_name = "Quest" + str(quest_id)
	var node = get_node_or_null("/root/" + map + "/" + node_name)
	if node != null:
		node.call_deferred("free")

func respawn_pnj(map, quest_id):
	delete_pnj(map, quest_id)
	await get_tree().process_frame
	spawn_pnj(quest_id)


func quest_finished(i):
	var quest = quests.get(i, null)
	if quest and not quest.finished:
		quest.finished = true
		
		# Stockage des nodes en cache pour éviter plusieurs `get_node()`
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
			minimap.change_pin(quests[i].pin_positions[quests[i].stade])

func advance_stade(quest_id = current_quest_id):
	if quests.get(quest_id).stade < quests.get(int(quest_id)).descriptions.size():
		quests.get(quest_id).stade += 1
	else:
		delete_pnj(Global.current_map,quest_id)
