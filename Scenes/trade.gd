extends Control

@onready var grid_container = get_node("ColorRect/ColorRect2/ResourcesList")
@onready var trade_container = get_node("ColorRect/ColorRect")
@onready var http_request = $HTTPRequest # Assurez-vous d'avoir un nœud HTTPRequest dans la scène
var items_data = []
var game_items_daata = []
var trade_items = []

# Simuler la variable d'argent du joueur
var player_money = 1000

func _ready():
	load_items()
	fetch_online_items()
	populate_inventory()

# Charger les données du fichier JSON local
func load_items():
	var file = FileAccess.open("res://Constantes/items.json", FileAccess.READ)
	if file:
		var json_data = file.get_as_text()
		file.close()

		# Créer une instance de JSON
		var json = JSON.new()
		var parse_result = json.parse(json_data)

		# Vérifie si le parsing a réussi
		if parse_result == OK:
			items_data = json.data # Accéder directement aux données parsées
			print("Chargement des items locaux réussi:")
			print(items_data) # Afficher les données chargées
		else:
			print("Erreur lors du parsing JSON : ", json.error_string())
	else:
		print("Erreur d'ouverture du fichier JSON.")

# Récupérer les items depuis l'API
func fetch_online_items():
	var url = "https://contagioncreaturesapi.vercel.app/api/items"
	http_request.request(url)

# Afficher les items disponibles au trade
# Afficher les items disponibles au trade
func display_trade_items():
	# Accéder au conteneur d'items dans le ColorRect
	var trade_container = get_node("ColorRect/ColorRect/VBoxContainer")

	# Vider le conteneur avant d'ajouter les items
	for child in trade_container.get_children():
		trade_container.remove_child(child)
		child.queue_free()

	for item in trade_items:
		if typeof(item) == TYPE_DICTIONARY:
			var name = str(item.get("name", "Sans nom"))
			var description = str(item.get("description", "Pas de description"))
			var texture_name = str(item.get("texture", "default.png"))
			var texture_path = "res://Textures/Items/" + texture_name
			var price = item.get("price", 0)

			# Vérifie la validité de la texture
			var icon_texture = null
			if ResourceLoader.exists(texture_path):
				icon_texture = load(texture_path)
			else:
				print("Texture non trouvée : ", texture_path)

			# Création du bouton d'achat
			var button = Button.new()
			button.text = "%s\n%d 🪙" % [name, price]
			button.custom_minimum_size = Vector2(150, 128) # Ajuster la taille du bouton
			button.add_theme_font_size_override("font_size", 32)
			if icon_texture:
				button.icon = icon_texture
			button.tooltip_text = description

			# Connexion avec la méthode d'achat via Callable
			button.connect("pressed", Callable(self, "_on_buy_item").bind(item))
			trade_container.add_child(button)



# Sélectionner des items aléatoires pour le trade
func generate_trade_items():
	trade_items.clear()
	var num_items = 5 # Nombre d'items aléatoires à afficher
	var available_items = game_items_daata.duplicate()
	
	while trade_items.size() < num_items and available_items.size() > 0:
		var random_index = randi() % available_items.size()
		var random_item = available_items[random_index]
		trade_items.append(random_item)
		available_items.remove_at(random_index)

	display_trade_items()

# Gérer l'achat d'un item
func _on_buy_item(item):
	var price = item.get("price", 0)
	if player_money >= price:
		player_money -= price
		print("Achat de l'item : %s pour %d 🪙. Argent restant : %d" % [item["name"], price, player_money])
		trade_items.erase(item) # Retirer l'item acheté de la liste
		display_trade_items() # Mettre à jour l'affichage
	else:
		print("Pas assez d'argent pour acheter %s" % item["name"])
	populate_inventory()

# Remplir l'ItemList avec les items
func populate_inventory():
	grid_container.clear()

	for item in items_data:
		if typeof(item) == TYPE_DICTIONARY:
			# Récupérer les champs avec des valeurs par défaut
			var name = str(item.get("name", "Sans nom"))
			var description = str(item.get("description", "Pas de description"))
			var texture_name = str(item.get("texture", "default.png"))
			var texture_path = "res://Textures/Items/" + texture_name
			var quantity = int(item.get("quantity", 0))
			var price = item.get("price", 0)

			# Vérifie la validité de la texture
			var icon_texture = null
			if ResourceLoader.exists(texture_path):
				icon_texture = load(texture_path)
			else:
				print("Texture non trouvée : ", texture_path)

			# Texte de l'item (nom, quantité, prix)
			var item_text = "%s\nx%d\n%d 🪙" % [name, quantity, price]

			# Ajouter l'item dans l'ItemList avec l'icône et les informations
			var item_id = grid_container.add_item(item_text, icon_texture)
			grid_container.set_item_tooltip(item_id, description)

			# Configurer l'affichage des icônes
			grid_container.fixed_icon_size = Vector2(64, 64)
			grid_container.icon_mode = ItemList.ICON_MODE_TOP
			grid_container.icon_scale = 1.2

# Callback pour la réponse HTTP
func _on_http_request_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var json = JSON.new()
		var parse_result = json.parse(body.get_string_from_utf8())
		
		if parse_result == OK:
			game_items_daata = json.data
			print("Items récupérés depuis l'API:")
			print(game_items_daata)
			generate_trade_items()
		else:
			print("Erreur lors du parsing des items API : ", json.error_string())
	else:
		print("Erreur lors de la requête HTTP. Code : ", response_code)


func _on_quit_pressed() -> void:
	queue_free()
