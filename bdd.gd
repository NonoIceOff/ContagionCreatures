extends Node

# Assurez-vous d'avoir un nœud HTTPRequest dans la scène
@onready var http_request: HTTPRequest = $HTTPRequest
@onready var data_node: CodeEdit = $Data  # `CodeEdit` pour afficher le JSON complet
@onready var vbox_container: VBoxContainer = $ScrollContainer/VBoxContainer  # `VBoxContainer` pour afficher chaque créature

# URL de l'API
const API_URL = "https://contagioncreaturesapi.vercel.app/api/creatures/1"  # Remplacez par votre URL d'API
const FILE_PATH = "res://Constantes/creatures.json"  # Chemin vers le fichier JSON local

func _ready():
	# Connecte le signal pour gérer la réponse
	http_request.request_completed.connect(_on_request_completed)
	
	# Charger les données JSON locales initiales
	_load_local_json()

# Fonction pour charger les données JSON locales et les afficher
func _load_local_json():
	# Supprime tous les enfants existants du VBoxContainer
	for child in vbox_container.get_children():
		vbox_container.remove_child(child)
		child.queue_free()  # Libère la mémoire de l'enfant

	var json_as_text = FileAccess.get_file_as_string(FILE_PATH)
	var parse_result = JSON.parse_string(json_as_text)

	if parse_result == null:
		data_node.text = "Erreur lors du chargement du fichier JSON local."
	elif typeof(parse_result) == TYPE_ARRAY:
		# Affiche le tableau complet dans data_node
		data_node.text = "Données locales (Tableau) :\n" + str(parse_result)
		
		# Parcourt chaque créature dans le tableau JSON et crée une interface pour elle
		for creature in parse_result:
			_add_creature_to_ui(creature)
	else:
		data_node.text = "Type de données JSON inattendu pour le fichier local."

# Fonction pour ajouter une créature au fichier JSON local
func _add_creature_to_local_json(new_creature_data: Dictionary):
	var json_as_text = FileAccess.get_file_as_string(FILE_PATH)
	var parse_result = JSON.parse_string(json_as_text)

	# Si le fichier est vide ou le parsing échoue, on initialise avec une liste vide
	var creatures_data = []
	if parse_result != null and typeof(parse_result) == TYPE_ARRAY:
		creatures_data = parse_result  # Charge les créatures existantes si le fichier contient un tableau valide

	# Ajoute la nouvelle créature et sauvegarde dans le fichier
	creatures_data.append(new_creature_data)
	var updated_json_text = JSON.stringify(creatures_data, "\t")  # Formate avec des tabulations pour la lisibilité
	var file = FileAccess.open(FILE_PATH, FileAccess.WRITE)
	
	if file:
		file.store_string(updated_json_text)
		file.close()
		print("Les données de la créature ont été ajoutées au fichier JSON.")
		_load_local_json()  # Recharge les données mises à jour pour les afficher
	else:
		print("Erreur lors de l'ouverture du fichier pour écriture.")

# Fonction pour ajouter une créature à l'interface utilisateur dans le VBoxContainer
func _add_creature_to_ui(creature_data: Dictionary):
	# Crée un VBoxContainer pour contenir les informations de la créature
	var creature_panel = Panel.new()
	creature_panel.self_modulate = Color(1,0,1,1)
	creature_panel.custom_minimum_size = Vector2(100,348)
	var creature_vbox = VBoxContainer.new()
	
	# Parcourt chaque clé-valeur dans les données de la créature et crée un Label pour chaque info
	for key in creature_data.keys():
		var label = Label.new()
		label.text = str(key) + ": " + str(creature_data[key])
		label.add_theme_font_size_override("font_size", 32)  # Définit la taille de police à 24
		creature_vbox.add_child(label)

	# Ajoute le VBoxContainer de la créature au VBoxContainer principal
	vbox_container.add_child(creature_panel)
	creature_panel.add_child(creature_vbox)



# Fonction déclenchée pour envoyer la requête à l'API
func _on_capture_pressed() -> void:
	var error = http_request.request(API_URL, [], HTTPClient.METHOD_GET)
	if error != OK:
		print("Erreur lors de l'envoi de la requête :", error)
	else:
		print("Requête envoyée à l'API.")

# Fonction pour gérer la réponse de l'API
func _on_request_completed(result: int, response_code: int, headers: Array, body: PackedByteArray):
	var response_text = body.get_string_from_utf8()
	print("Réponse de la requête :", response_text)

	var parse_result = JSON.parse_string(response_text)

	# Vérifie si le parsing a réussi
	if parse_result == null or typeof(parse_result) != TYPE_DICTIONARY:
		data_node.text = "Erreur lors du parsing de la réponse de l'API."
		return
	
	# Ajoute les nouvelles données de la créature au fichier JSON local
	_add_creature_to_local_json(parse_result)
