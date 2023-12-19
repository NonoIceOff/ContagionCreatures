extends Node2D

@onready var main_menu = $CanvasLayer/MultiplayerSettings
@onready var address_entry = $CanvasLayer/MultiplayerSettings/IpAddress
@onready var pseudo_entry = $CanvasLayer/MultiplayerSettings/Pseudo
@onready var player_list_label = $CanvasLayer/Stats/PlayerListLabel
@onready var stats = $CanvasLayer/Stats

const Player = preload("res://Scenes/Player_Multiplayer.tscn")
const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()

func _ready():
	stats.hide()
	
func _process(_delta):
	if get_node("CanvasLayer/MultiplayerSettings/Pseudo").text != "":
		get_node("CanvasLayer/MultiplayerSettings/HostGame").disabled = false
		get_node("CanvasLayer/MultiplayerSettings/GlobalServer/JoinGlobalServer").disabled = false
		if get_node("CanvasLayer/MultiplayerSettings/IpAddress").text != "":
			get_node("CanvasLayer/MultiplayerSettings/JoinGame").disabled = false
		else:
			get_node("CanvasLayer/MultiplayerSettings/JoinGame").disabled = true
	else:
		get_node("CanvasLayer/MultiplayerSettings/HostGame").disabled = true
		get_node("CanvasLayer/MultiplayerSettings/JoinGame").disabled = true
		get_node("CanvasLayer/MultiplayerSettings/GlobalServer/JoinGlobalServer").disabled = true
		
	var server_address = IP.get_local_addresses()[-1]
	get_node("CanvasLayer/Stats/ServerInfo").text = "[rainbow freq=0.05][b]INFO DU SERVEUR :[/b][/rainbow]\n[font_size=16]Serveur de " + str(server_address) + "\nJoueurs: " + str(multiplayer.get_peers().size() + 1) + "[/font_size]"
		
func add_player(peer_id,pseudo="pseudo"):
	var player = Player.instantiate()
	player.name = str(peer_id)
	player.pseudo = str(pseudo)
	player.position = Vector2(250, 250)
	add_child(player)

func remove_player(peer_id,pseudo="pseudo"):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()

func _on_multiplayer_spawner_spawned(player):
	if player.is_multiplayer_authority():
		player.pseudo = str(pseudo_entry.text)
		player.rpc("add_to_list", str(player.pseudo).strip_edges())
		player.added_to_list = true

func _on_join_game_pressed():
	main_menu.hide()
	stats.show()

	enet_peer.create_client(address_entry.text, PORT)
	multiplayer.multiplayer_peer = enet_peer

func _on_host_game_pressed():
	main_menu.hide()
	stats.show()

	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	add_player(multiplayer.get_unique_id(),pseudo_entry.text)


func _on_join_global_server_pressed():
	main_menu.hide()
	stats.show()

	enet_peer.create_client("localhost", 9999)
	multiplayer.multiplayer_peer = enet_peer
