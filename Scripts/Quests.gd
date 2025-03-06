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
	
	var members_only: bool = false

	func _init(id, title, long_description, descriptions, mini_descriptions, pin_positions, pnj_data, members_only = false, stade = 0):
		self.id = id
		self.title = title
		self.long_description = long_description
		self.descriptions = descriptions
		self.mini_descriptions = mini_descriptions
		self.pin_positions = pin_positions
		self.pnj_data = pnj_data
		self.members_only = members_only
		self.stade = 0

var current_quest_id = -1

var bagird_pnj = PNJ.new(
	0,
	"res://Textures/PNJ/Bagird/tete_bagird.png",
	"res://Textures/PNJ/Bagird/bagird_full.png",
	"Bagird"
)

var quests = {}

func _init() -> void:
	quests[0] = Quest.new(
		0,
		"L'aube d'un fléau",
		"Une nuit étrange s'est abattue sur votre village, Héronbourg. Les animaux qui vivaient en harmonie semblent possédés par une étrange aura violette. Vous vous réveillez ce matin alors que tout bascule...",
		[
			"Vous trouvez une poêle dans la cuisine.",
			"Un Goupil Contaminé surgit devant votre maison, vous devez le combattre !",
		],
		[
			"Trouvez un équipement.",
			"Affrontez votre premier adversaire !",
		],
		[
			Vector2(3000, 2000), # Maison du joueur
			Vector2(3500, 2000), # Juste à côté

		],
		[
			# PREMIERE PARTIE
			[
				bagird_pnj, 
				[
					{"text": "Bonjour, comment ça va ?", "action": "_on_dialogue_start"},
					{"text": "Je peux vous aider ?"},
					{"text": "Voulez-vous des informations ?", "choices": [
						{"text": "Oui", "response": "Voici les informations.", "action": "_on_yes_choice"},
						{"text": "Non", "response": "D'accord, à bientôt!"}
					]},
					{"text": "Fin du dialogue.", "action": "_on_dialogue_end"}
				]
			],
			# SECONDE PARTIE
			[
				bagird_pnj, 
				[
					{"text": "Bonjour 2, comment ça va ?", "action": "_on_dialogue_start"},
					{"text": "Je peux vous aider ?"},
					{"text": "Voulez-vous des informations ?", "choices": [
						{"text": "Oui", "response": "Voici les informations.", "action": "_on_yes_choice"},
						{"text": "Non", "response": "D'accord, à bientôt!"}
					]},
					{"text": "Fin du dialogue.", "action": "_on_dialogue_end"}
				]
			]
		],
		false, # Pas réservé aux membres,
		0
	)


func init_pnj(map):
	for i in quests.size():
		spawn_pnj(map, i)

func spawn_pnj(map, quest_id):
	var i = quest_id
	var quest_stade = quests.get(i).stade
	var pnj_position = quests.get(i).pin_positions[quests.get(i).stade]
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
	spawn_pnj(map, quest_id)


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
