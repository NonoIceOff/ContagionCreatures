extends Control

# Couleurs pour chaque joueur (même ordre que multiplayer_map)
const PLAYER_COLORS = [
	Color(0.2, 0.5, 1.0),    # 1: Bleu
	Color(1.0, 0.2, 0.2),    # 2: Rouge
	Color(0.2, 1.0, 0.3),    # 3: Vert
	Color(1.0, 0.9, 0.2)     # 4: Jaune
]

@onready var players_list = $Panel/VBoxContainer/ScrollContainer/PlayersList
@onready var ready_button = $Panel/VBoxContainer/ReadyButton
@onready var start_button = $Panel/VBoxContainer/StartButton
@onready var ip_label = $Panel/VBoxContainer/IPLabel
@onready var leave_button = $Panel/VBoxContainer/LeaveButton

var local_player_ready = false

func _ready():
	NetworkManager.player_connected.connect(_on_player_connected)
	NetworkManager.player_disconnected.connect(_on_player_disconnected)
	NetworkManager.server_disconnected.connect(_on_server_disconnected)
	NetworkManager.player_ready_changed.connect(_on_player_ready_changed)
	
	start_button.visible = NetworkManager.is_host
	start_button.disabled = true
	
	if NetworkManager.is_host:
		ip_label.text = "IP du serveur: " + NetworkManager.get_local_ip()
	else:
		ip_label.text = "Connecté au serveur"
	
	refresh_players_list()

func _process(_delta):
	if NetworkManager.is_host:
		start_button.disabled = not NetworkManager.all_players_ready()

func refresh_players_list():
	for child in players_list.get_children():
		child.queue_free()
	
	for peer_id in NetworkManager.players_info:
		var player_info = NetworkManager.players_info[peer_id]
		var player_label = Label.new()
		
		# Assign color based on player_index (0=Bleu, 1=Rouge, 2=Vert, 3=Jaune)
		var player_idx = player_info.player_index
		if player_idx < PLAYER_COLORS.size():
			player_label.add_theme_color_override("font_color", PLAYER_COLORS[player_idx])
		
		player_label.text = "Joueur " + str(player_idx + 1) + ": " + player_info.name
		if player_info.ready:
			player_label.text += " [PRÊT]"
		if peer_id == multiplayer.get_unique_id():
			player_label.text += " (Vous)"
		if peer_id == 1:
			player_label.text += " (Hôte)"
		
		player_label.add_theme_font_size_override("font_size", 24)
		players_list.add_child(player_label)

func _on_player_connected(peer_id, player_info):
	refresh_players_list()

func _on_player_disconnected(peer_id):
	refresh_players_list()

func _on_player_ready_changed(peer_id, ready):
	refresh_players_list()

func _on_ready_button_pressed():
	local_player_ready = not local_player_ready
	ready_button.text = "PAS PRÊT" if local_player_ready else "PRÊT"
	NetworkManager.set_player_ready.rpc(multiplayer.get_unique_id(), local_player_ready)
	refresh_players_list()

func _on_start_button_pressed():
	if NetworkManager.is_host and NetworkManager.all_players_ready():
		NetworkManager.start_game.rpc()

func _on_leave_button_pressed():
	NetworkManager.disconnect_from_game()
	get_tree().change_scene_to_file("res://Scenes/Menus/MultiplayerMenu.tscn")

func _on_server_disconnected():
	get_tree().change_scene_to_file("res://Scenes/Menus/MultiplayerMenu.tscn")
