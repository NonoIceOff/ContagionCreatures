extends Node2D

var speechbox =  preload("res://Scenes/speech_box_COMBAT.tscn")
var precombat_scene = preload("res://Scenes/Precombat.tscn")
var rng = RandomNumberGenerator.new()
var pv_player = 100
var pv_enemy = 100
var defense_player = 0
var buttonP : Button
var buttonE : Button
var animalP : Sprite2D
var animalE : Sprite2D
var background_rect_info : ColorRect
var buttons_active = true  # Drapeau pour contrôler l'activation des boutons et des touches
var in_target_zone = false  # Indique si la barre est dans la zone cible
var space_pressed = false   # Indique si la barre espace a été pressée une fois
var current_attack_value = 0  # Stocke la valeur de l'attaque actuelle



@onready var player_creature_name = $ContainerPLAYER/Pseudo
@onready var progress_bar_joueur = $ProgressBar_Joueur
@onready var zone_cible = $ProgressBar_Joueur/ZoneCible
@onready var player_progress_bar_hp  = $ContainerPLAYER/TextureProgressBar
@onready var player_percentage_hp  = $ContainerPLAYER/TextureProgressBar/Percentage

@onready var spell_1_sound: AudioStreamPlayer2D = $Spell1_sound
@onready var spell_2_sound: AudioStreamPlayer2D = $Spell2_sound
@onready var spell_3_sound: AudioStreamPlayer2D = $Spell3_sound
@onready var spell_4_sound: AudioStreamPlayer2D = $Spell4_sound


@onready var spell_1_button = $Spell1
@onready var spell_2_button = $Spell2
@onready var spell_3_button = $Spell3
@onready var spell_4_button = $Spell4

@onready var spell_1_icon = $Spell1_icon
@onready var spell_2_icon = $Spell2_icon
@onready var spell_3_icon = $Spell3_icon
@onready var spell_4_icon = $Spell4_icon

@onready var mob_progress_bar_hp  = $ContainerMob/TextureProgressBar
@onready var mob_pseudo_label  = $ContainerMob/Pseudo
@onready var mob_percentage_hp  = $ContainerMob/TextureProgressBar/Percentage

@onready var http_get_creatures = $GetCreaturesEnemy
@onready var http_get_creatures_spells = $GetSpellsPlayer
@onready var http_get_enemy_spells = $GetSpellsEnnemy

const API_URL = "https://contagioncreaturesapi.vercel.app/api"  # Remplacez par votre URL d'API
const CREATURES_FILE_PATH = "res://Constantes/creatures.json"  # Chemin vers le fichier JSON local
var creatures_data = []
var enemy_creatures_data = []
var creatures_spells = []
var enemy_creatures_spells = []

# Définition des couleurs en fonction du type d'attaque
var attack_colors = {
	"fire": Color(1, 0, 0),          # Rouge pour Fire
	"physical": Color(0.72, 0.53, 0.04),  # Marron clair pour Physical
	"ice": Color(0, 0.5, 1),         # Bleu pour Ice
	"magic": Color(0.7, 0.3, 1)      # Violet clair pour Magic
}

func _ready():
	# Connecter les signaux de HTTPRequest pour gérer les réponses dès leur arrivée
	http_get_creatures.connect("request_completed", Callable(self, "_on_get_creatures_request_completed"))
	http_get_creatures_spells.connect("request_completed", Callable(self, "_on_get_creatures_spells_request_completed"))
	http_get_enemy_spells.connect("request_completed", Callable(self, "_on_get_enemy_spells_request_completed"))

	# Obtenir le mob de l'ennemi (en lançant les requêtes HTTP)
	var enemy_mob_id = randi_range(1, 10)
	http_get_creatures.request(API_URL + "/" + str(enemy_mob_id))
	http_get_enemy_spells.request(API_URL + "/" + str(enemy_mob_id) + "/attacks")

	# Initialiser l'affichage des sorts et masquer la zone cible
	var zone_cible = $ProgressBar_Joueur/ZoneCible
	zone_cible.visible = false

	# Charger les données locales
	creatures_data = _load_local_json()



	
	

	print("enter in ready of sceneCombat")
	var precombat_instance = precombat_scene.instantiate()
	add_child(precombat_instance)
	

	# Obtenir les sorts du joueur si les données sont disponibles
	if creatures_data.size() > 0:
		http_get_creatures_spells.request(API_URL + "/" + str(creatures_data[0].id) + "/attacks")

	# Configuration des animaux du joueur et de l'ennemi
	setup_player_animal()
	setup_enemy_animal()

	# Initialiser la barre de points de vie du joueur
	if creatures_data.size() > 0:
		player_progress_bar_hp.max_value = creatures_data[0].hp
		player_progress_bar_hp.value = creatures_data[0].hp
		player_percentage_hp.text = str(creatures_data[0].hp) + "/" + str(player_progress_bar_hp.max_value)
		
	$Spell1.add_to_group("spell_buttons")
	$Spell2.add_to_group("spell_buttons")
	$Spell3.add_to_group("spell_buttons")
	$Spell4.add_to_group("spell_buttons")
	set_spell_buttons_enabled(true)
	
func setup_player_animal():
	for key in Global.actual_animal:
		if Global.animals_player[key] == Global.animals_player[PlayerStats.animal_id]:
			var animalP = Sprite2D.new()
			animalP.name = "Sprite"
			animalP.texture = load(Global.actual_animal[PlayerStats.animal_id]["texture_animal_fight"])
			animalP.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			animalP.position = Vector2(774, 995)
			animalP.z_index = 0
			animalP.scale = Vector2(5.1, 5.1)
			add_child(animalP)
			
			var buttonP = Button.new()
			buttonP.name = str(key)
			buttonP.connect("pressed", Callable(self, "_create_and_display_label_player").bind(
				creatures_data[0]["name"], creatures_data[0]["type"], creatures_data[0]["description"]))
			buttonP.position = Vector2(660, 890)
			buttonP.custom_minimum_size = Vector2(70, 70)
			add_child(buttonP)
			
			var sprite = Sprite2D.new()
			sprite.texture = load("res://Textures/Info.png")
			sprite.scale = Vector2(2, 2)
			sprite.position = Vector2(35, 35)
			buttonP.add_child(sprite)

func setup_enemy_animal():
	for key in Global.animals_enemy:
		if Global.animals_enemy[key] == Global.animals_enemy[PlayerStats.animal_id]:
			var animalE = Sprite2D.new()
			animalE.name = "Sprite_animal_enemy"
			animalE.texture = load(Global.animals_enemy[PlayerStats.animal_id]["texture_infected"])
			animalE.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			animalE.position = Vector2(1102, 841)
			animalE.z_index = 0
			animalE.scale = Vector2(5.1, 5.1)
			add_child(animalE)
			
			var buttonE = Button.new()
			buttonE.name = str(key)
			buttonE.position = Vector2(1200, 821)
			buttonE.connect("pressed", Callable(self, "_create_and_display_label_enemy"))
			buttonE.modulate = Color(1, 0.54902, 0, 1)
			buttonE.custom_minimum_size = Vector2(70, 70)
			add_child(buttonE)
			
			var sprite = Sprite2D.new()
			sprite.texture = load("res://Textures/Info.png")
			sprite.scale = Vector2(2, 2)
			sprite.position = Vector2(35, 35)
			buttonE.add_child(sprite)

# Callback pour les données de créature de l'ennemi
func _on_get_creatures_request_completed(result: int, response_code: int, headers: Array, body: PackedByteArray) -> void:
	if response_code == 200:
		if enemy_creatures_data.size() > 1:
			mob_progress_bar_hp.max_value = enemy_creatures_data.hp
			mob_progress_bar_hp.value = enemy_creatures_data.hp
			mob_percentage_hp.text = str(enemy_creatures_data.hp) + "/" + str(mob_progress_bar_hp.max_value)
			mob_pseudo_label.text = enemy_creatures_data.name

# Callback pour les sorts du joueur
func _on_get_creatures_spells_request_completed(result: int, response_code: int, headers: Array, body: PackedByteArray) -> void:
	if response_code == 200:
		var response_text = body.get_string_from_utf8()
		var parse_result = JSON.parse_string(response_text)
		
		# Vérifie que le parsing a réussi et que des données sont disponibles
		

			# Assurez-vous qu'il y a au moins 4 sorts
		if creatures_spells.size() >= 4:
			# Configuration pour chaque bouton de sort
			configure_spell_button("Spell1", creatures_spells[0])
			configure_spell_button("Spell2", creatures_spells[1])
			configure_spell_button("Spell3", creatures_spells[2])
			configure_spell_button("Spell4", creatures_spells[3])

			# Affichage des informations supplémentaires pour chaque sort
			var spell1_difficulty1 = get_node("Spell1/difficulty1")
			spell1_difficulty1.text = str(creatures_spells[0].difficulty)
			var spell2_difficulty2 = get_node("Spell2/difficulty2")
			spell2_difficulty2.text = str(creatures_spells[1].difficulty)
			var spell3_difficulty3 = get_node("Spell3/difficulty3")
			spell3_difficulty3.text = str(creatures_spells[2].difficulty)
			var spell4_difficulty4 = get_node("Spell4/difficulty4")
			spell4_difficulty4.text = str(creatures_spells[3].difficulty)

			var spell1_type1 = get_node("Spell1/type1")
			spell1_type1.text = str(creatures_spells[0].mode)
			var spell2_type2 = get_node("Spell2/type2")
			spell2_type2.text = str(creatures_spells[1].mode)
			var spell3_type3 = get_node("Spell3/type3")
			spell3_type3.text = str(creatures_spells[2].mode)
			var spell4_type4 = get_node("Spell4/type4")
			spell4_type4.text = str(creatures_spells[3].mode)

			# Connexion des boutons pour afficher les informations de débogage lors d'un clic
			connect_spell_button_with_debug("Spell1", creatures_spells, 0)
			connect_spell_button_with_debug("Spell2", creatures_spells, 1)
			connect_spell_button_with_debug("Spell3", creatures_spells, 2)
			connect_spell_button_with_debug("Spell4", creatures_spells, 3)
		else:
			print("Erreur : Les sorts du joueur n'ont pas été chargés correctement.")
	else:
		print("Erreur de parsing JSON pour les sorts du joueur :")

# Modification de `_input` pour vérifier si les boutons sont actifs
func _input(event):
	
	# Vérifie si la barre espace (attack_barre) est pressée
	if event.is_action_pressed("attack_barre") and not space_pressed:
		_on_attack_bar_pressed()
		
	if not buttons_active:
		return

			# Vérifie si l'une des touches associées aux sorts est pressée
	if event.is_action_pressed("Spell_1"):
		_execute_spell_action("Spell_1", creatures_spells, 0)
	elif event.is_action_pressed("Spell_2"):
		_execute_spell_action("Spell_2", creatures_spells, 1)
	elif event.is_action_pressed("Spell_3"):
		_execute_spell_action("Spell_3", creatures_spells, 2)
	elif event.is_action_pressed("Spell_4"):
		_execute_spell_action("Spell_4", creatures_spells, 3)
						
   


# Nouvelle fonction pour exécuter les actions de debug et de remplissage de la barre
func _execute_spell_action(button_name: String, spells: Array, index: int):
	if spells.size() > index:
		var spell_data = spells[index]
		# Appelle la fonction de debug pour afficher les informations du sort
		_debug_spell_info(spell_data)
		# Appelle la fonction pour remplir la barre
		_on_spell_button_pressed(spell_data)
	else:
		print("Erreur : Index de sort invalide pour ", button_name)

# Fonction pour connecter le bouton de sort avec une fonction de débogage pour afficher les informations
# Fonction pour connecter le bouton avec les données de sort
func connect_spell_button_with_debug(button_name: String, spells: Array, index: int):
	if spells.size() > index:
		var button = get_node(button_name)
		if button != null:
			var spell_data = spells[index]
			# Connecte le bouton pour afficher les informations de debug et remplir la barre avec les données du sort
			button.connect("pressed", Callable(self, "_debug_spell_info").bind(spell_data))
			button.connect("pressed", Callable(self, "_on_spell_button_pressed").bind(spell_data))
		else:
			print("Erreur : Le bouton ", button_name, " n'existe pas dans la scène.")
	else:
		print("Erreur : Index de sort invalide pour le bouton ", button_name)
# Fonction de débogage pour afficher les informations du sort lorsqu'un bouton est pressé
func _debug_spell_info(spell_data: Dictionary):
	# Afficher les informations de débogage dans la console
	print("---- Informations du Sort ----")
	print("Nom du sort : ", spell_data.name)
	print("Type d'attaque : ", spell_data.type)
	print("Valeur : ", spell_data.value)
	print("Mode : ", spell_data.mode)
	print("---- Fin ----")
# Fonction pour configurer chaque bouton de sort
func configure_spell_button(button_name: String, spell_data: Dictionary) -> void:
	var button = get_node(button_name)
	if button != null:
		# Définir le texte du bouton avec le nom du sort et sa valeur
		button.text = spell_data.name + " : " + str(spell_data.value)
		
		# Définir la couleur de fond du bouton en fonction du type d'attaque
		var attack_type = spell_data.type
		if attack_colors.has(attack_type):
			button.modulate = attack_colors[attack_type]
		
		# Afficher la difficulté sous le bouton
		var difficulty_label = button.get_node("difficulty" + button_name.substr(-1))  # Récupère difficulty1, difficulty2, etc.
		if difficulty_label != null:
			difficulty_label.text = str(spell_data.difficulty)
			
func _load_local_json():


	var json_as_text = FileAccess.get_file_as_string(CREATURES_FILE_PATH)
	var parse_result = JSON.parse_string(json_as_text)
	print(parse_result)
	if parse_result == null:
		print("Erreur lors du chargement du fichier JSON local.")
	else:
		print("Type de données JSON correct pour le fichier local.")
	print(parse_result[0].name)
	player_creature_name.text = parse_result[0].name
	if parse_result == null:
		print("Erreur lors du chargement du fichier JSON local.")
		return []
		
	return parse_result
	
func _create_and_display_label_player(name, type, description):
	if background_rect_info != null:
		return

	# Création et configuration du panneau
	background_rect_info = ColorRect.new()
	var screen_size = get_viewport_rect().size
	background_rect_info.size = Vector2(800, 600)
	background_rect_info.position = (screen_size - background_rect_info.size) / 2
	background_rect_info.color = Color(0.0, 0.0, 0.2, 0.9)
	add_child(background_rect_info)

	# Configuration du label d'information
	var label_info = Label.new()
	label_info.text = name
	label_info.add_theme_font_override("font", load("res://Font/8-BIT_WONDER.TTF"))
	label_info.scale = Vector2(2, 2)
	label_info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label_info.position.x = background_rect_info.size.x / 2.5
	label_info.position.y = background_rect_info.size.y / 2
	background_rect_info.add_child(label_info)

	# Configuration du label de type
	var effects_label = Label.new()
	effects_label.text = "Description : " + str(description)
	effects_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	effects_label.size = Vector2(700, 50)
	effects_label.add_theme_font_override("font", load("res://Font/8-BIT_WONDER.TTF"))
	effects_label.scale = Vector2(1, 1)
	effects_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	effects_label.position = Vector2((background_rect_info.size.x - effects_label.size.x) / 2, background_rect_info.size.y - effects_label.size.y - 10)
	background_rect_info.add_child(effects_label)
	
	var type_label = Label.new()
	type_label.text = "Type: " + str(type)
	type_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	type_label.size = Vector2(700, 50)
	type_label.add_theme_font_override("font", load("res://Font/8-BIT_WONDER.TTF"))
	type_label.scale = Vector2(1, 1)
	type_label.position = Vector2((background_rect_info.size.x - type_label.size.x) / 2, effects_label.position.y - type_label.size.y - 10)
	background_rect_info.add_child(type_label)
	# Configuration du bouton de fermeture
	var close_button = Button.new()
	close_button.custom_minimum_size = Vector2(70, 70)
	close_button.position = Vector2(background_rect_info.size.x - close_button.size.x - 80, 10)
	close_button.connect("pressed", Callable(self, "_close_info_animalP"))
	background_rect_info.add_child(close_button)

	var sprite = Sprite2D.new()
	sprite.texture = load("res://Textures/Cross_Close.png")
	sprite.scale = Vector2(2.5, 2.5)
	sprite.position = Vector2(close_button.size.x / 2, close_button.size.y / 2)
	close_button.add_child(sprite)

	desactivate_buttons()
	
func _create_and_display_label_enemy():
	
	background_rect_info = ColorRect.new()
	var screen_size = get_viewport_rect().size
	var center_position = screen_size / 2
	background_rect_info.size = Vector2(800, 600)
	background_rect_info.position = (screen_size - background_rect_info.size) / 2
	background_rect_info.color = Color(0.2, 0.0, 0.0, 0.9)
	add_child(background_rect_info)
	
	var sprite_animal_info = Sprite2D.new()
	sprite_animal_info.texture_filter =  CanvasItem.TEXTURE_FILTER_NEAREST
	if Global.animals_enemy[PlayerStats.animal_id]["infected"] == false:
		sprite_animal_info.texture = load(Global.animals_enemy[PlayerStats.animal_id]["textureA"])
	else:
		sprite_animal_info.texture = load(Global.animals_enemy[PlayerStats.animal_id]["texture_infected"])
	sprite_animal_info.scale = Vector2(6,6)
	sprite_animal_info.position = Vector2(background_rect_info.size.x /2 , background_rect_info.size.y /3)
	background_rect_info.add_child(sprite_animal_info)
	
	var label_info = Label.new()
	label_info.text = enemy_creatures_data.name
	label_info.add_theme_font_override("font", load("res://Font/8-BIT_WONDER.TTF"))
	label_info.scale = Vector2(2, 2)
	label_info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label_info.position.x = background_rect_info.size.x / 2.5
	label_info.position.y = background_rect_info.size.y / 2
	background_rect_info.add_child(label_info)
	
	var close_button = Button.new()
	close_button.scale = Vector2(1,1)
	close_button.custom_minimum_size = Vector2(70,70)
	close_button.position = Vector2(background_rect_info.size.x - close_button.size.x - 80, 10)
	close_button.connect("pressed" , Callable( self , "_close_info_animalE"))
	background_rect_info.add_child(close_button)
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://Textures/Cross_Close.png")
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite.scale = Vector2(2.5,2.5)
	sprite.position = Vector2(close_button.size.x / 2, close_button.size.y / 2)
	close_button.add_child(sprite)
	
	var effects_label = Label.new()
	effects_label.text = "Description : " + enemy_creatures_data.description
	effects_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	effects_label.size = Vector2(700, 50)
	effects_label.add_theme_font_override("font", load("res://Font/8-BIT_WONDER.TTF"))
	effects_label.scale = Vector2(1, 1)
	effects_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	effects_label.position = Vector2((background_rect_info.size.x - effects_label.size.x) / 2, background_rect_info.size.y - effects_label.size.y - 10)
	background_rect_info.add_child(effects_label)
	
	var type_label = Label.new()
	type_label.text = "Type: " + enemy_creatures_data.type
	type_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	type_label.size = Vector2(700, 50)
	type_label.add_theme_font_override("font", load("res://Font/8-BIT_WONDER.TTF"))
	type_label.scale = Vector2(1, 1)
	type_label.position = Vector2((background_rect_info.size.x - type_label.size.x) / 2, effects_label.position.y - type_label.size.y - 10)
	background_rect_info.add_child(type_label)
	desactivate_buttons()

func _close_info_animalP():
	if background_rect_info != null:
		background_rect_info.queue_free()
		background_rect_info = null  # Reset to allow re-creation
		
func _close_info_animalE():
	if background_rect_info != null:
		background_rect_info.queue_free()
		
func desactivate_buttons():
	if buttonP != null and buttonE != null:
		buttonP.disabled = true
		buttonE.disabled = true
		get_node("Button").disabled = true
		get_node("Button2").disabled = true
		
	else:
		print("Les boutons ne sont pas initialisés.")

func spawn_dialogue(custom_texts):
	var dialogue = speechbox.instantiate()
	dialogue.position = Vector2(0,-380)
	dialogue.texts = custom_texts
	add_child(dialogue)

func _process(delta):
	rng.randomize()
	
	if Input.is_action_just_pressed("spell1"):
		spell_1_button.emit_signal("pressed")
	if Input.is_action_just_pressed("spell2"):
		spell_2_button.emit_signal("pressed")
	if Input.is_action_just_pressed("spell3"):
		spell_3_button.emit_signal("pressed")
	if Input.is_action_just_pressed("spell4"):
		spell_4_button.emit_signal("pressed")
	

func activate_buttons():
	buttons_active = true
	if buttonP != null and buttonE != null:
		buttonP.disabled = false
		buttonE.disabled = false
		get_node("Spell_1").disabled = false
		get_node("Spell_2").disabled = false
		get_node("Spell_3").disabled = false
		get_node("Spell_4").disabled = false
	else:
		print("Les boutons ne sont pas initialisés.")




func _on_spell_button_pressed(spell_data: Dictionary):
	set_spell_buttons_enabled(false)  # Désactive les boutons
	space_pressed = false  # Réinitialise l'état de l'appui sur espace
	current_attack_value = spell_data.value  # Récupère la valeur de l'attaque actuelle
	await _remplir_barre_automatiquement(1.0)
	set_spell_buttons_enabled(true)  # Réactive les boutons


func set_spell_buttons_enabled(enabled: bool) -> void:
	buttons_active = enabled  # Met à jour le drapeau pour bloquer/débloquer les touches

	for button in get_tree().get_nodes_in_group("spell_buttons"):
		button.disabled = not enabled
	print("Boutons activés :", enabled)

# Fonction pour remplir la barre automatiquement, avec des étapes claires pour le suivi
# Remplissage de la barre avec détection de la zone cible
func _remplir_barre_automatiquement(duree: float) -> void:
	var min_position_percentage = 20
	var max_position_percentage = 80
	var zone_width_percentage = 20

	var zone_cible = progress_bar_joueur.get_node("ZoneCible")
	var bar_width = progress_bar_joueur.get_size().x
	var start_x_percentage = randi_range(min_position_percentage, max_position_percentage - zone_width_percentage)
	var start_x = bar_width * (start_x_percentage / 100.0)
	var zone_width = bar_width * (zone_width_percentage / 100.0)

	zone_cible.visible = true
	zone_cible.set_size(Vector2(zone_width, zone_cible.size.y))
	zone_cible.position.x = start_x

	var elapsed_time = 0.0
	var start_value = progress_bar_joueur.value
	var end_value = progress_bar_joueur.max_value

	while elapsed_time < duree:
		var t = elapsed_time / duree
		progress_bar_joueur.value = lerp(start_value, end_value, t)

		# Vérifie si la barre de progression est dans la zone cible
		var progress_x = progress_bar_joueur.get_size().x * (progress_bar_joueur.value / progress_bar_joueur.max_value)
		in_target_zone = (progress_x >= start_x and progress_x <= start_x + zone_width)

		await get_tree().process_frame
		elapsed_time += get_process_delta_time()
	
	progress_bar_joueur.value = end_value

	# Réinitialiser la barre et la zone cible
	if progress_bar_joueur.value >= progress_bar_joueur.max_value:
		await get_tree().process_frame
		progress_bar_joueur.value = 0

	zone_cible.visible = false
	in_target_zone = false  # Réinitialiser après le remplissage
	space_pressed = false   # Réinitialiser pour le prochain remplissage


# Détecte l'appui sur la barre espace et vérifie si on est dans la zone cible
func _on_attack_bar_pressed():
	if space_pressed:
		return  # Empêche de réappuyer plusieurs fois

	space_pressed = true  # Indique que l'espace a été pressé

	# Calculer la position de la zone cible en pourcentage de la largeur de la barre
	var zone_start_percentage = zone_cible.position.x / progress_bar_joueur.get_size().x
	var zone_end_percentage = (zone_cible.position.x + zone_cible.size.x) / progress_bar_joueur.get_size().x

	# Convertir `progress_bar_joueur.value` en pourcentage de remplissage
	var progress_percentage = progress_bar_joueur.value / progress_bar_joueur.max_value

	# Vérifier si `progress_percentage` se trouve dans la plage de la zone cible
	if progress_percentage >= zone_start_percentage and progress_percentage <= zone_end_percentage:
		print("Réussite")
		apply_damage_to_enemy(current_attack_value, true)
	else:
		print("Échec")
		apply_damage_to_enemy(current_attack_value, false)

func apply_damage_to_enemy(damage: int, successful: bool) -> void:
	var final_damage = damage
	if not successful:
		final_damage /= 2  # Divise les dégâts par 2 en cas d'échec
	
	# Applique les dégâts finaux à la barre de vie de l'ennemi
	mob_progress_bar_hp.value -= final_damage
	mob_percentage_hp.text = str(mob_progress_bar_hp.value) + "/" + str(mob_progress_bar_hp.max_value)
	
	# Affiche un message pour indiquer les dégâts infligés
	print("Dégâts infligés à l'ennemi :", final_damage)

	
func _on_get_spells_player_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response_text = body.get_string_from_utf8()
	var parse_result = JSON.parse_string(response_text)
	creatures_spells = parse_result

	#await get_tree().create_timer(1).timeout
	#print(creatures_spells)

func _on_get_spells_ennemy_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response_text = body.get_string_from_utf8()
	var parse_result = JSON.parse_string(response_text)
	enemy_creatures_spells = parse_result
	#await get_tree().create_timer(1).timeout
	#print(enemy_creatures_spells)

func _on_get_creatures_enemy_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response_text = body.get_string_from_utf8()
	var parse_result = JSON.parse_string(response_text)
	print("ok")
	enemy_creatures_data = parse_result
	#await get_tree().create_timer(1).timeout
	#print(enemy_creatures_data)



func _on_spell_1_pressed() -> void:
	print("Vous avez utilisé : " + creatures_spells[0].name)
	spell_1_sound.play()
	
func _on_spell_2_pressed() -> void:
	print("Vous avez utilisé : " + creatures_spells[1].name)
	spell_2_sound.play()
	
func _on_spell_3_pressed() -> void:
	print("Vous avez utilisé : " + creatures_spells[2].name)
	spell_3_sound.play()

func _on_spell_4_pressed() -> void:
	print("Vous avez utilisé : " + creatures_spells[3].name)
	spell_4_sound.play()
