extends Node2D

@onready var main_menu = $CanvasLayer/MultiplayerSettings
@onready var address_entry = $CanvasLayer/MultiplayerSettings/IpAddress
@onready var pseudo_entry = $CanvasLayer/MultiplayerSettings/Pseudo
@onready var player_list_label = $CanvasLayer/PlayerListLabel

const Player = preload("res://Scenes/Player_Multiplayer.tscn")
const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()

func add_player(peer_id,pseudo="pseudo"):
	var player = Player.instantiate()
	player.name = str(peer_id)
	player.pseudo = str(pseudo)
	player.position = Vector2(250, 250)
	add_child(player)
	
	#player_list_label.text += "\n[b]Joueur " + str(player.pseudo) + "[/b]"  # Ajoute le joueur à la liste

func remove_player(peer_id,pseudo="pseudo"):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()
		#player_list_label.text = player_list_label.text.replace("\n[b]Joueur " + str(player.pseudo) + "[/b]", "")  # Retire le joueur de la liste

func _on_multiplayer_spawner_spawned(player):
	if player.is_multiplayer_authority():
		player.pseudo = str(pseudo_entry.text)
		player.rpc("add_to_list", str(player.pseudo).strip_edges())
		player.added_to_list = true

func _on_join_game_pressed():
	main_menu.hide()

	enet_peer.create_client(address_entry.text, PORT)
	multiplayer.multiplayer_peer = enet_peer

func _on_host_game_pressed():
	main_menu.hide()

	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	add_player(multiplayer.get_unique_id(),pseudo_entry.text)
