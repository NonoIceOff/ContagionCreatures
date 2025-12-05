extends Node

const PORT = 9999
const MAX_PLAYERS = 8

var enet_peer = ENetMultiplayerPeer.new()
var players_info = {}
var is_host = false

signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected()
signal player_ready_changed(peer_id, ready)

func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func create_server() -> bool:
	var error = enet_peer.create_server(PORT, MAX_PLAYERS)
	if error != OK:
		print("Erreur création serveur: ", error)
		return false
	
	multiplayer.multiplayer_peer = enet_peer
	is_host = true
	print("Serveur créé sur le port ", PORT)
	return true

func join_server(address: String) -> bool:
	var error = enet_peer.create_client(address, PORT)
	if error != OK:
		print("Erreur connexion au serveur: ", error)
		return false
	
	multiplayer.multiplayer_peer = enet_peer
	is_host = false
	print("Connexion au serveur ", address)
	return true

func disconnect_from_game():
	if multiplayer.multiplayer_peer:
		multiplayer.multiplayer_peer.close()
		multiplayer.multiplayer_peer = null
	
	players_info.clear()
	is_host = false
	print("Déconnexion du jeu")

@rpc("any_peer", "reliable")
func register_player(peer_id: int, player_name: String):
	if multiplayer.is_server():
		players_info[peer_id] = {
			"name": player_name,
			"ready": false
		}
		print("Joueur enregistré sur serveur: ", player_name, " (ID: ", peer_id, ")")
		
		add_player_to_clients.rpc(peer_id, player_name)
		
		for existing_peer_id in players_info:
			if existing_peer_id != peer_id:
				var existing_player = players_info[existing_peer_id]
				add_player_to_clients.rpc_id(peer_id, existing_peer_id, existing_player.name, existing_player.ready)

func add_player_locally(peer_id: int, player_name: String, ready: bool = false):
	players_info[peer_id] = {
		"name": player_name,
		"ready": ready
	}
	player_connected.emit(peer_id, players_info[peer_id])
	print("Joueur ajouté localement: ", player_name, " (ID: ", peer_id, ")")

@rpc("authority", "call_local", "reliable")
func add_player_to_clients(peer_id: int, player_name: String, ready: bool = false):
	add_player_locally(peer_id, player_name, ready)

@rpc("any_peer", "call_local", "reliable")
func set_player_ready(peer_id: int, ready: bool):
	if players_info.has(peer_id):
		players_info[peer_id].ready = ready
		player_ready_changed.emit(peer_id, ready)
		print("Joueur ", players_info[peer_id].name, " est ", "prêt" if ready else "pas prêt")

@rpc("authority", "call_local", "reliable")
func start_game():
	print("Démarrage de la partie!")
	get_tree().change_scene_to_file("res://Scenes/Maps/multiplayer_map.tscn")

func _on_player_connected(peer_id: int):
	print("Joueur connecté: ", peer_id)

func _on_player_disconnected(peer_id: int):
	if players_info.has(peer_id):
		print("Joueur déconnecté: ", players_info[peer_id].name)
		players_info.erase(peer_id)
		player_disconnected.emit(peer_id)

func _on_connected_to_server():
	print("Connecté au serveur avec succès!")

func _on_connection_failed():
	print("Échec de connexion au serveur")
	disconnect_from_game()

func _on_server_disconnected():
	print("Déconnecté du serveur")
	disconnect_from_game()
	server_disconnected.emit()

func get_local_ip() -> String:
	var addresses = IP.get_local_addresses()
	for address in addresses:
		if address.begins_with("192.168.") or address.begins_with("10."):
			return address
	return "127.0.0.1"

func all_players_ready() -> bool:
	if players_info.is_empty():
		return false
	
	for player_id in players_info:
		if not players_info[player_id].ready:
			return false
	return true
