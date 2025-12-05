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
		NetworkManager.add_player_locally(multiplayer.get_unique_id(), player_name)
		get_tree().change_scene_to_file("res://Scenes/Lobby.tscn")
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
		NetworkManager.register_player.rpc_id(1, multiplayer.get_unique_id(), player_name)
		get_tree().change_scene_to_file("res://Scenes/Lobby.tscn")
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
