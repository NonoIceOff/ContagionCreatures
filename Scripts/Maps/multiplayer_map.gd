extends Node2D

const Player = preload("res://Scenes/Player_Multiplayer.tscn")
const MAX_PLAYERS = 4

# Couleurs pour chaque joueur
const PLAYER_COLORS = [
	Color(0.2, 0.5, 1.0),    # 1: Bleu
	Color(1.0, 0.2, 0.2),    # 2: Rouge
	Color(0.2, 1.0, 0.3),    # 3: Vert
	Color(1.0, 0.9, 0.2)     # 4: Jaune
]

@onready var players_container = $Players
@onready var spawn_points = $SpawnPoints
@onready var players_list_ui = $UI/PlayersList

var spawn_index = 0

func _ready():
	NetworkManager.player_connected.connect(_on_player_connected)
	NetworkManager.player_disconnected.connect(_on_player_disconnected)
	
	await get_tree().process_frame
	await get_tree().create_timer(0.2).timeout
	
	print("=== MAP READY ===")
	print("Mon peer_id: ", multiplayer.get_unique_id())
	print("Joueurs dans NetworkManager.players_info: ", NetworkManager.players_info.keys())
	for peer_id in NetworkManager.players_info:
		print("  - Joueur ", peer_id, ": ", NetworkManager.players_info[peer_id])
	
	for peer_id in NetworkManager.players_info:
		add_player(peer_id, NetworkManager.players_info[peer_id].name)
	
	update_players_list()

func add_player(peer_id: int, player_name: String):
	if players_container.has_node(str(peer_id)):
		print("Joueur déjà présent, ignoré: ", player_name, " (ID: ", peer_id, ")")
		return
	
	var player = Player.instantiate()
	player.name = str(peer_id)
	player.player_name = player_name
	
	var player_index = 0
	if NetworkManager.players_info.has(peer_id):
		player_index = NetworkManager.players_info[peer_id].player_index
	
	if player_index < PLAYER_COLORS.size():
		player.player_color = PLAYER_COLORS[player_index]
	else:
		player.player_color = Color.WHITE
	
	if spawn_index < spawn_points.get_child_count():
		player.position = spawn_points.get_child(spawn_index).position
		spawn_index += 1
	else:
		player.position = Vector2(randf_range(250, 450), randf_range(250, 450))
	
	player.set_multiplayer_authority(peer_id)
	
	var synchronizer = player.get_node("MultiplayerSynchronizer")
	if synchronizer:
		synchronizer.set_multiplayer_authority(peer_id)
		synchronizer.public_visibility = true
	
	if peer_id == multiplayer.get_unique_id():
		var camera = Camera2D.new()
		camera.enabled = true
		player.add_child(camera)
	
	players_container.add_child(player)
	update_players_list()
	print("Joueur ajouté à la map: ", player_name, " (ID: ", peer_id, ")")

func remove_player(peer_id: int):
	var player = players_container.get_node_or_null(str(peer_id))
	if player:
		player.queue_free()
	update_players_list()
	print("Joueur retiré de la map (ID: ", peer_id, ")")

func _on_player_connected(peer_id: int, player_info: Dictionary):
	add_player(peer_id, player_info.name)

func _on_player_disconnected(peer_id: int):
	remove_player(peer_id)

func update_players_list():
	for child in players_list_ui.get_children():
		if child.name != "PlayersTitle":
			child.queue_free()
	
	var player_num = 0
	for peer_id in NetworkManager.players_info:
		var label = Label.new()
		label.add_theme_font_size_override("font_size", 18)
		
		var player_node = players_container.get_node_or_null(str(peer_id))
		if player_node:
			label.add_theme_color_override("font_color", player_node.player_color)
		
		label.text = "• Joueur " + str(player_num + 1) + ": " + NetworkManager.players_info[peer_id].name
		players_list_ui.add_child(label)
		player_num += 1
