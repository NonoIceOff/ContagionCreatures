extends Node2D

@onready var main_menu = $CanvasLayer/MultiplayerSettings
@onready var address_entry = $CanvasLayer/MultiplayerSettings/IpAddress
@onready var pseudo_entry = $CanvasLayer/MultiplayerSettings/Pseudo
@onready var player_list_label = $CanvasLayer/Stats/PlayerListLabel
@onready var stats = $CanvasLayer/Stats
@onready var chat = $CanvasLayer/Chat

const Player = preload("res://Scenes/Player_Multiplayer.tscn")
const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()

var testing = 0
var is_connected_testing = false

var server_list = {
	0:{
		"name":"Serveur de Nonoice",
		"ip":"10.57.32.114",
		"motd":"\n[color=gray]Serveur principal du jeu parce que la flemme de taper l'ip[/color]",
		"is_open":false
	}
}

func _ready():
	stats.hide()
	chat.hide()
	enet_peer.connect("peer_disconnected", Callable(self, "_on_peer_disconnected"))
	enet_peer.connect("peer_connected", Callable(self, "_on_peer_connected"))
	
	refresh_server_list()

func refresh_server_list():
	var result = get_node("CanvasLayer/MultiplayerSettings/ScrollContainer/ServerList")
	for j in result.get_children():
		j.queue_free()
	testing = 1
	for i in server_list:
		spawn_server(i)
	await get_tree().create_timer(0.1).timeout
	testing = 0
	if is_connected_testing == true:
		refresh_server_list()
		is_connected_testing = false

func spawn_server(i):
	var result = get_node("CanvasLayer/MultiplayerSettings/ScrollContainer/ServerList")
	
	var panel = Panel.new()
	panel.custom_minimum_size = Vector2(1280,96)
	panel.position = Vector2(320,824)
	panel.name = str(i)
	result.add_child(panel)
	
	var titre = Label.new()
	titre.custom_minimum_size = Vector2(864,51)
	titre.position = Vector2(8,4)
	titre.name = "Title"
	titre.text = server_list[i]["name"]
	titre.add_theme_font_size_override("font_size", 32)
	panel.add_child(titre)
	
	var description = RichTextLabel.new()
	description.custom_minimum_size = Vector2(736,56)
	description.position = Vector2(32,40)
	description.name = "Description"
	description.text = "[color=red]SERVEUR FERME[/color]"+server_list[i]["motd"]
	description.bbcode_enabled = true
	description.scroll_active = false
	panel.add_child(description)
	
	var joinbut = Button.new()
	joinbut.custom_minimum_size = Vector2(280,37)
	joinbut.position = Vector2(968,40)
	joinbut.name = "Button"
	joinbut.text = "Rejoindre"
	joinbut.add_theme_stylebox_override("normal",load("res://Thème/button_normal.tres"))
	joinbut.add_theme_stylebox_override("hover",load("res://Thème/button_hover.tres"))
	joinbut.add_theme_stylebox_override("pressed",load("res://Thème/button_pressed.tres"))
	joinbut.add_theme_stylebox_override("disabled",load("res://Thème/button_disabled.tres"))
	#joinbut.disabled = true
	panel.add_child(joinbut)
	
	if if_server_exists(i) == true:
		description.text = "[color=green]SERVEUR OUVERT[/color]"+server_list[i]["motd"]
		joinbut.disabled = false
		

func if_server_exists(i):
	#get_node("CanvasLayer/MultiplayerSettings/IpAddress").text = str("10.57.32.114")
	if address_entry.text != "":
		enet_peer.create_client(str("10.57.32.114"), PORT)
		multiplayer.multiplayer_peer = enet_peer


	if is_connected_testing == false:
		print("Fermé")
		return false
	else:
		print("Ouvert")
		return true

func _process(_delta):
	stats.show()
	
	if get_node("CanvasLayer/MultiplayerSettings/Pseudo").text != "":
		if get_node("CanvasLayer/MultiplayerSettings/IpAddress").text != "":
			get_node("CanvasLayer/MultiplayerSettings/JoinGame").disabled = false
		else:
			get_node("CanvasLayer/MultiplayerSettings/JoinGame").disabled = true
	else:
		get_node("CanvasLayer/MultiplayerSettings/JoinGame").disabled = true
		
	var server_address = IP.get_local_addresses()[3]
	get_node("CanvasLayer/Stats/ServerInfo").text = "[rainbow freq=0.05][b]INFO DU SERVEUR :[/b][/rainbow]\n[font_size=16]Ip du serveur: [font=res://Font/Inter-Medium.ttf]" + str(server_address) + "[/font]\nJoueurs: [font=res://Font/Inter-Medium.ttf]" + str(multiplayer.get_peers().size() + 1) + "[/font][/font_size]"
	
	for i in server_list:
		if get_node_or_null("CanvasLayer/MultiplayerSettings/ScrollContainer/ServerList/"+str(i)) != null:
			if get_node("CanvasLayer/MultiplayerSettings/ScrollContainer/ServerList/"+str(i)+"/Button").button_pressed == true:
				main_menu.hide()
				stats.hide()
				chat.show()

				enet_peer.create_client(server_list[i]["ip"], PORT)
				multiplayer.multiplayer_peer = enet_peer
				if enet_peer.get_connection_status() == 0:
					stats.hide()
					chat.hide()
					main_menu.show()
					get_node("CanvasLayer/Error/Panel/RichTextLabel").text = "[center][b][wave amp=50.0 freq=5.0 connected=1]ERREUR[/wave][/b]\n\n[i][font_size=32]Serveur non existant, veuillez mettre la bonne IP[/font_size]"
					get_node("CanvasLayer/Error").visible = true
	
func add_player(peer_id,pseudo="pseudo"):
	var player = Player.instantiate()
	player.name = str(peer_id)
	player.pseudo = str(pseudo)
	player.position = Vector2(250, 250)
	add_child(player)

func remove_player(peer_id,pseudo="pseuo"):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()

func _on_multiplayer_spawner_spawned(player):
	if player.is_multiplayer_authority():
		player.pseudo = str(pseudo_entry.text)
		player.rpc("add_to_list", str(player.pseudo).strip_edges())
		player.added_to_list = true

func _on_join_game_pressed():
	if address_entry.text != "localhost":
		main_menu.hide()
		stats.hide()
		chat.show()

		enet_peer.create_client(address_entry.text, PORT)
		multiplayer.multiplayer_peer = enet_peer
		if enet_peer.get_connection_status() == 0:
			stats.hide()
			chat.hide()
			main_menu.show()
			get_node("CanvasLayer/Error/Panel/RichTextLabel").text = "[center][b][wave amp=50.0 freq=5.0 connected=1]ERREUR[/wave][/b]\n\n[i][font_size=32]Serveur non existant, veuillez mettre la bonne IP[/font_size]"
			get_node("CanvasLayer/Error").visible = true
		print(enet_peer.get_connection_status())
	else:
		get_node("CanvasLayer/Error/Panel/RichTextLabel").text = "[center][b][wave amp=50.0 freq=5.0 connected=1]ERREUR[/wave][/b]\n\n[i][font_size=32]Impossible de se connecter a localhost pour le moment.[/font_size]"
		get_node("CanvasLayer/Error").visible = true
		

func _on_host_game_pressed():
	main_menu.hide()
	stats.show()
	chat.show()

	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_disconnected.connect(remove_player)
	multiplayer.peer_connected.connect(add_player)
	add_player(multiplayer.get_unique_id(),"serveur")
	print(stats.visible)


func _on_join_global_server_pressed():
	pass

func _on_peer_disconnected(id):
	print("Déconnecté du serveur. ID du pair déconnecté :", id)
	stats.hide()
	chat.hide()
	main_menu.show()
	get_node("CanvasLayer/Error/Panel/RichTextLabel").text = "[center][b][wave amp=50.0 freq=5.0 connected=1]ERREUR[/wave][/b]\n\n[i][font_size=32]Deconnecte du serveur ( serveur ferme )[/font_size]"
	get_node("CanvasLayer/Error").visible = true
	
func _on_peer_connected(id):
	print("Connecté du serveur. ID du pair connecté :", id)
	print("connected : "+str(is_connected_testing))
	if testing == 1:
		is_connected_testing = true
		multiplayer.multiplayer_peer = null
		enet_peer = ENetMultiplayerPeer.new()


func _on_errorok_pressed():
	get_node("CanvasLayer/Error").visible = false


func _on_refresh_server_list_pressed():
	refresh_server_list()
