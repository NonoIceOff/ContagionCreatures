extends Node2D

# Variables pour stocker les stats (pour conserver les valeurs)
var win = false
var total_damage_player = 0
var total_heal_player = 0
var total_shield_player = 0
var max_damage_player = 0
var max_heal_player = 0
var max_shield_player = 0
var total_damage_enemy = 0
var total_heal_enemy = 0
var total_shield_enemy = 0
var max_damage_enemy = 0
var max_heal_enemy = 0
var max_shield_enemy = 0
var critique_attaque_player = 0
var critique_attaque_ennemye = 0
var normal_attaque_player = 0
var normal_attaque_ennemye = 0
var echec_attaque_player = 0
var echec_attaque_ennemye = 0
var ennemy_id = 0

@onready var total_damage_player_label = $Stats/Joueur/Total_damage
@onready var total_heal_player_label   = $Stats/Joueur/Total_heal
@onready var total_shield_player_label = $Stats/Joueur/Total_shield
@onready var max_damage_player_label   = $Stats/Joueur/Max_damage
@onready var max_heal_player_label     = $Stats/Joueur/Max_heal
@onready var max_shield_player_label   = $Stats/Joueur/Max_shield
@onready var succes_player             = $Stats/Joueur/succes

@onready var total_damage_enemy_label  = $Stats/Ennemi/Total_damage
@onready var total_heal_enemy_label    = $Stats/Ennemi/Total_heal
@onready var total_shield_enemy_label  = $Stats/Ennemi/Total_shield
@onready var max_damage_enemy_label    = $Stats/Ennemi/Max_damage
@onready var max_heal_enemy_label      = $Stats/Ennemi/Max_heal
@onready var max_shield_enemy_label    = $Stats/Ennemi/Max_shield
@onready var succes_enemy              = $Stats/Ennemi/succes
@onready var drops                     = $Stats/Drop

# ============================================================================
# Fonction globale pour vérifier si un drop existe déjà.
# Si l'item existe déjà (même "id" et "name") on renvoie son index,
# sinon -1.
# ============================================================================
func drop_index(drop_item: Dictionary, items_array: Array) -> int:
	for i in items_array.size():
		var item = items_array[i]
		if drop_item.has("id") and item.has("id") and drop_item["id"] == item["id"]:
			if drop_item.has("name") and item.has("name") and drop_item["name"] == item["name"]:
				return i
	return -1

# ============================================================================
func _ready() -> void:
	print("✅ _ready() de Stats.tscn exécuté")
	print("Label Total_damage Joueur :", total_damage_player_label)
	
	# Exemple d'utilisation d'une requête HTTP pour tester le label
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_on_get_creatures_request_completed"))
	
	var url = "https://contagioncreaturesapi.vercel.app/api/creatures/1/drops"
	print("URL demandée :", url)
	var err = http_request.request(url)
	if err != OK:
		print("Erreur lors de la requête HTTP : ", err)

# ============================================================================
func set_all_text_variable(
		win, total_damage_player, total_heal_player, total_shield_player,
		max_damage_player, max_heal_player, max_shield_player,
		total_damage_enemy, total_heal_enemy, total_shield_enemy,
		max_damage_enemy, max_heal_enemy, max_shield_enemy,
		critique_attaque_player, critique_attaque_ennemye,
		normal_attaque_player, normal_attaque_ennemye,
		echec_attaque_player, echec_attaque_ennemye, ennemy_id
	):
	print("----- Début de set_all_text_variable() -----")
	print("Valeurs reçues :")
	print("total_damage_player =", total_damage_player)
	print("total_heal_player =", total_heal_player)
	print("total_shield_player =", total_shield_player)
	print("max_damage_player =", max_damage_player)
	print("max_heal_player =", max_heal_player)
	print("max_shield_player =", max_shield_player)
	print("total_damage_enemy =", total_damage_enemy)
	print("total_heal_enemy =", total_heal_enemy)
	print("total_shield_enemy =", total_shield_enemy)
	print("max_damage_enemy =", max_damage_enemy)
	print("max_heal_enemy =", max_heal_enemy)
	print("max_shield_enemy =", max_shield_enemy)
	print("critique_attaque_player =", critique_attaque_player)
	print("critique_attaque_ennemye =", critique_attaque_ennemye)
	print("normal_attaque_player =", normal_attaque_player)
	print("normal_attaque_ennemye =", normal_attaque_ennemye)
	print("echec_attaque_player =", echec_attaque_player)
	print("echec_attaque_ennemye =", echec_attaque_ennemye)
	
	# Mise à jour des labels Joueur (on ajoute au texte existant)
	total_damage_player_label.text += " : " + str(total_damage_player)
	total_heal_player_label.text   += " : " + str(total_heal_player)
	total_shield_player_label.text += " : " + str(total_shield_player)
	max_damage_player_label.text   += " : " + str(max_damage_player)
	max_heal_player_label.text     += " : " + str(max_heal_player)
	max_shield_player_label.text   += " : " + str(max_shield_player)
	succes_player.text             += " : " + str(echec_attaque_player) + " | " + str(normal_attaque_player) + " | " + str(critique_attaque_player)
	
	# Mise à jour des labels Ennemi (on ajoute au texte existant)
	total_damage_enemy_label.text += " : " + str(total_damage_enemy)
	total_heal_enemy_label.text   += " : " + str(total_heal_enemy)
	total_shield_enemy_label.text += " : " + str(total_shield_enemy)
	max_damage_enemy_label.text   += " : " + str(max_damage_enemy)
	max_heal_enemy_label.text     += " : " + str(max_heal_enemy)
	max_shield_enemy_label.text   += " : " + str(max_shield_enemy)
	succes_enemy.text             += " : " + str(echec_attaque_ennemye) + " | " + str(normal_attaque_ennemye) + " | " + str(critique_attaque_ennemye)
	
	# Mise à jour du label Drop avec un message selon l'issue du combat
	if win == true:
		drops.text = "Victoire ! vous allez recevoir ces drops : "
	else:
		drops.text = "Défaite ! vous avez perdu ces potentiel drops : "
	
	# Attente pour s'assurer que l'interface est mise à jour
	await get_tree().create_timer(4.0).timeout
	
	print("----- Fin de set_all_text_variable() -----")
	print("Label Total_damage Joueur mis à jour :", total_damage_player_label.text)

# ============================================================================
func _on_get_creatures_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response_text = body.get_string_from_utf8()
	print("Response Body:", response_text)
	
	var parse_result = JSON.parse_string(response_text)
	var data = parse_result
	
	# Mise à jour du label Drop selon le format de la réponse
	if typeof(data) == TYPE_DICTIONARY and data.has("message"):
		drops.text += data["message"]
		print("Received dictionary with message: ", data["message"])
	elif typeof(data) == TYPE_ARRAY:
		var names = ""
		for drop in data:
			names += drop.get("name", "Item") + ", "
		if names.length() > 2:
			names = names.substr(0, names.length() - 2)
		drops.text += names
		print("Received array with items: ", names)
	else:
		drops.text = "Format de réponse inattendu"
		print("Unexpected response format:", data)
	
	print("Drops label after update:", drops.text)
	
	# S'assurer que le fichier items.json existe
	var filename = "res://Constantes/items.json"
	if not FileAccess.file_exists(filename):
		print("items.json n'existe pas, création du fichier.")
		var file_new = FileAccess.open(filename, FileAccess.WRITE)
		file_new.store_string("[]")
		file_new.close()
		print("Fichier items.json créé avec succès.")
	else:
		print("Fichier items.json existant trouvé.")
	
	# Lecture du contenu existant de items.json
	var file = FileAccess.open(filename, FileAccess.READ)
	var file_content = file.get_as_text()
	file.close()
	print("Contenu actuel de items.json:", file_content)
	
	var file_parse = JSON.parse_string(file_content)
	var items_array = file_parse
	
	# Traiter les drops reçus.
	# Pour chaque drop, si l'item existe déjà (même id et même name),
	# alors on incrémente sa quantity sinon on le crée en ajoutant une quantité par défaut (ici 1)
	if typeof(data) == TYPE_ARRAY:
		for drop in data:
			# S'assurer que le drop possède une propriété "quantity"
			if not drop.has("quantity"):
				drop["quantity"] = 1
			var index = drop_index(drop, items_array)
			if index != -1:
				# Incrémenter la quantité existante
				items_array[index]["quantity"] = int(items_array[index]["quantity"]) + drop["quantity"]
				print("Mise à jour du drop existant:", items_array[index])
			else:
				# Si l'item n'existe pas, on l'ajoute
				items_array.append(drop)
				print("Ajout du nouveau drop (array):", drop)
	elif typeof(data) == TYPE_DICTIONARY and data.has("id"):
		# Pour un seul drop, on vérifie et ajoute la propriété "quantity" s'il manque
		if not data.has("quantity"):
			data["quantity"] = 1
		var index = drop_index(data, items_array)
		if index != -1:
			items_array[index]["quantity"] = int(items_array[index]["quantity"]) + data["quantity"]
			print("Mise à jour du drop existant:", items_array[index])
		else:
			items_array.append(data)
			print("Ajout du nouveau drop (dictionary):", data)
	else:
		print("Aucun drop valide à ajouter.")
	
	# Écriture du contenu mis à jour dans items.json en utilisant JSON.stringify (Godot 4)
	file = FileAccess.open(filename, FileAccess.WRITE)
	file.store_string(JSON.stringify(items_array))
	file.close()
	print("Mise à jour écrite dans items.json:", JSON.stringify(items_array))
