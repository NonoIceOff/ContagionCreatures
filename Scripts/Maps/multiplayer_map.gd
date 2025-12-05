extends Node2D

const Player = preload("res://Scenes/Player_Multiplayer.tscn")

@onready var players_container = $Players
@onready var spawn_points = $SpawnPoints
@onready var players_list_ui = $UI/PlayersList

var spawn_index = 0

func _ready():
	NetworkManager.player_connected.connect(_on_player_connected)
	NetworkManager.player_disconnected.connect(_on_player_disconnected)
	
	for peer_id in NetworkManager.players_info:
		add_player(peer_id, NetworkManager.players_info[peer_id].name)
	
	update_players_list()

func add_player(peer_id: int, player_name: String):
	var player = Player.instantiate()
	player.name = str(peer_id)
	player.player_name = player_name
	
	# Position at spawn point
	if spawn_index < spawn_points.get_child_count():
		player.position = spawn_points.get_child(spawn_index).position
		spawn_index += 1
	else:
		player.position = Vector2(randf_range(250, 450), randf_range(250, 450))
	
	# Set authority to the peer that owns this player
	player.set_multiplayer_authority(peer_id)
	
	# Add camera only for local player
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
	# Clear existing list except title
	for child in players_list_ui.get_children():
		if child.name != "PlayersTitle":
			child.queue_free()
	
	# Add current players
	for peer_id in NetworkManager.players_info:
		var label = Label.new()
		label.theme_override_font_sizes["font_size"] = 18
		label.text = "• " + NetworkManager.players_info[peer_id].name
		players_list_ui.add_child(label)
