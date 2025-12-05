extends Control

@onready var main_panel = $MainPanel
@onready var join_panel = $JoinPanel
@onready var player_name_input = $MainPanel/VBoxContainer/PlayerNameInput
@onready var ip_input = $JoinPanel/VBoxContainer/IPInput
@onready var error_label = $ErrorLabel

func _ready():
	main_panel.visible = true
	join_panel.visible = false
	error_label.visible = false
	
	if player_name_input:
		player_name_input.text = "Joueur_" + str(randi() % 1000)

func _on_host_button_pressed():
	var player_name = player_name_input.text.strip_edges()
	
	if player_name.is_empty():
		show_error("Veuillez entrer un pseudo")
		return
	
	if NetworkManager.create_server():
		# L'hôte s'enregistre avec player_index = 0
		NetworkManager.add_player_locally(multiplayer.get_unique_id(), player_name, false, 0)
		NetworkManager.next_player_index = 1
		get_tree().change_scene_to_file("res://Scenes/Menus/Lobby.tscn")
	else:
		show_error("Impossible de créer le serveur")

func _on_join_button_pressed():
	main_panel.visible = false
	join_panel.visible = true

func _on_join_confirm_pressed():
	var player_name = player_name_input.text.strip_edges()
	var ip_address = ip_input.text.strip_edges()
	
	if player_name.is_empty():
		show_error("Veuillez entrer un pseudo")
		return
	
	if ip_address.is_empty():
		show_error("Veuillez entrer une adresse IP")
		return
	
	if NetworkManager.join_server(ip_address):
		await get_tree().create_timer(0.5).timeout
		# Le client s'ajoute IMMÉDIATEMENT en local (sera confirmé par le serveur)
		var my_peer_id = multiplayer.get_unique_id()
		print("[CLIENT] Mon peer_id: ", my_peer_id)
		# Temporairement ajouter en local avec index -1 (sera mis à jour par le serveur)
		NetworkManager.add_player_locally(my_peer_id, player_name, false, -1)
		# Demander au serveur de nous enregistrer officiellement
		NetworkManager.register_player.rpc_id(1, my_peer_id, player_name)
		# Attendre que le serveur réponde
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://Scenes/Menus/Lobby.tscn")
	else:
		show_error("Impossible de rejoindre le serveur")

func _on_back_button_pressed():
	main_panel.visible = true
	join_panel.visible = false
	error_label.visible = false

func show_error(message: String):
	error_label.text = message
	error_label.visible = true
	await get_tree().create_timer(3.0).timeout
	error_label.visible = false
