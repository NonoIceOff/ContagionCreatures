extends Node

class Quest:
	var id: int
	var title: String
	var long_description: String
	var descriptions: Array
	var mini_descriptions: Array
	var pin_positions: Array
	var stade: int = 0
	var finished: bool = false
	var members_only: bool = false

	func _init(id, title, long_description, descriptions, mini_descriptions, pin_positions, members_only = false):
		self.id = id
		self.title = title
		self.long_description = long_description
		self.descriptions = descriptions
		self.mini_descriptions = mini_descriptions
		self.pin_positions = pin_positions
		self.members_only = members_only

var current_quest_id = -1
var quests = {
	0: Quest.new(
		0, 
		"L'aube d'un fléau", 
		"Une nuit étrange s'est abattue sur votre village, Héronbourg. Les animaux qui vivaient en harmonie semblent possédés par une étrange aura violette. Vous vous réveillez ce matin alors que tout bascule...",
		[
			"Vous trouvez une poêle dans la cuisine.",
			"Un Goupil Contaminé surgit devant votre maison, vous devez le combattre !",
			"Les habitants paniqués parlent d'une pluie violette tombée il y a trois jours.",
			"Le chef du village, Aldric, vous attend pour discuter de la menace qui grandit."
		],
		[
			"Trouvez un équipement.",
			"Affrontez votre premier adversaire !",
			"Explorez le village et parlez aux habitants.",
			"Obtenez des explications du chef Aldric."
		],
		[
			Vector2(200, 300), # Maison du joueur
			Vector2(250, 350), # Devant la maison (combat)
			Vector2(500, 700), # Place du village
			Vector2(600, 1000) # Maison du chef
		],
		false # Pas réservé aux membres
	)
}



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

		Tutorial.get_node(".").tutorials[7]["progress"] += 100

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
	var quest = quests.get(quest_id, null)
	if quest and not quest.finished:
		if quest.stade < quest.descriptions.size() - 1:
			quest.stade += 1
		else:
			quest.finished = true
