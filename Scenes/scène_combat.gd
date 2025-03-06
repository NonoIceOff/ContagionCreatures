extends Node2D

var ennemy_manager = EnnemyManager.new()
var craft_manager = CraftManager.new()



var speechbox =  preload("res://Scenes/speech_box_COMBAT.tscn")
var precombat_scene = preload("res://Scenes/Precombat.tscn")
var rng = RandomNumberGenerator.new()
var pv_player = 100
var pv_enemy = 100
var ennemye_texture : String
var defense_player = 0
var buttonP : Button
var buttonE : Button
var animalP : Sprite2D
var animalE : Sprite2D
var background_rect_info : ColorRect
var buttons_active = false  # Drapeau pour contrôler l'activation des boutons et des touches
var in_target_zone = false  # Indique si la barre est dans la zone cible
var space_pressed = false   # Indique si la barre espace a été pressée une fois
var current_attack_value = 0  # Stocke la valeur de l'attaque actuelle
var current_mode = ""
var current_difficulty= ""
@onready var spell_1_sound: AudioStreamPlayer2D = $Spell1_sound
@onready var spell_2_sound: AudioStreamPlayer2D = $Spell2_sound
@onready var spell_3_sound: AudioStreamPlayer2D = $Spell3_sound
@onready var spell_4_sound: AudioStreamPlayer2D = $Spell4_sound
var combat_started = false  # Indicateur de début de combat
@onready var start_overlay = ColorRect.new()
@onready var start_message = Label.new()

# Player bar
@onready var player_creature_name = $ContainerPLAYER/Pseudo
@onready var progress_bar_joueur = $ProgressBar_Joueur
@onready var zone_cible1 = $ProgressBar_Joueur/ZoneCible1
@onready var zone_cible2 = $ProgressBar_Joueur/ZoneCible2
@onready var zone_cible3 = $ProgressBar_Joueur/ZoneCible3
@onready var player_progress_bar_hp  = $ContainerPLAYER/TextureProgressBar
@onready var player_percentage_hp  = $ContainerPLAYER/TextureProgressBar/Percentage
@onready var player_percentage_shield  = $ContainerPLAYER/TextureProgressBar/Shield
@onready var spell_name_player = $ProgressBar_Joueur/SpellName


# Ennemy bar
@onready var mob_progress_bar_hp  = $ContainerMob/TextureProgressBar
@onready var progress_bar_ennemye = $ProgressBar_ennemye
@onready var zone_cible1_ennemye = $ProgressBar_Joueur/ZoneCible1
@onready var zone_cible2_ennemye = $ProgressBar_Joueur/ZoneCible2
@onready var zone_cible3_ennemye = $ProgressBar_Joueur/ZoneCible3
@onready var mob_pseudo_label  = $ContainerMob/Pseudo
@onready var mob_percentage_hp  = $ContainerMob/TextureProgressBar/Percentage
@onready var mob_percentage_shield  = $ContainerMob/TextureProgressBar/Shield
@onready var spell_name_ennemye = $ProgressBar_ennemye/SpellName




@onready var http_get_creatures = $GetCreaturesEnemy
@onready var http_get_creatures_spells = $GetSpellsPlayer
@onready var http_get_enemy_spells = $GetSpellsEnnemy
@onready var ennemy_canAttack = false
@onready var number_attack = 0

const API_URL = "https://contagioncreaturesapi.vercel.app/api/creatures"  # Remplacez par votre URL d'API
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
var success_count = 0  # Compte des succès accumulés pendant la barre de progression
var required_successes = {
	"easy": 1,
	"medium": 2,
	"hard": 3
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
	var zone_cible1 = $ProgressBar_Joueur/ZoneCible1
	zone_cible1.visible = false
	var zone_cible2 = $ProgressBar_Joueur/ZoneCible2
	zone_cible2.visible = false
	var zone_cibl3e = $ProgressBar_Joueur/ZoneCible3
	zone_cible3.visible = false
	
	var spell_name_player = $ProgressBar_Joueur/SpellName
	spell_name_player.visible = false
	var spell_name_ennemye = $ProgressBar_ennemye/SpellName
	spell_name_ennemye.visible = false
	
		# Initialiser l'affichage des sorts et masquer la zone cible
	var zone_cible1_ennemye = $ProgressBar_ennemye/ZoneCible1
	zone_cible1_ennemye.visible = false
	var zone_cible2_ennemye = $ProgressBar_ennemye/ZoneCible2
	zone_cible2_ennemye.visible = false
	var zone_cibl3e_ennemye = $ProgressBar_ennemye/ZoneCible3
	zone_cible3_ennemye.visible = false

	# Charger les données locales
	creatures_data = _load_local_json()

	print("enter in ready of sceneCombat")
	var precombat_instance = precombat_scene.instantiate()
	# add_child(precombat_instance)
	
	# Configurer l'overlay de départ
	start_overlay.color = Color(0, 0, 0, 0.7)  # Gris foncé semi-transparent
	start_overlay.size = get_viewport_rect().size
	add_child(start_overlay)

# Configurer le message d'instructions
	start_message.text = "Pour commencer le combat, appuyez sur Espace"
	start_message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	start_message.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	start_message.size = Vector2(300, 50)  # Exemple de taille
	start_message.add_theme_font_override("font", load("res://Font/8-BIT_WONDER.TTF"))

	# Configurer l'ancrage et le point pivot pour centrer correctement
	start_message.anchor_left = 0.5
	start_message.anchor_top = 0.5
	start_message.anchor_right = 0.5
	start_message.anchor_bottom = 0.5
	start_message.offset_left = -start_message.size.x / 2
	start_message.offset_top = -start_message.size.y / 2

	# Ajouter le label centré dans l'overlay
	start_overlay.add_child(start_message)

	# Obtenir les sorts du joueur si les données sont disponibles
	if creatures_data.size() > 0:
		http_get_creatures_spells.request(API_URL + "/" + str(creatures_data[0].id) + "/attacks")

	# Initialiser la barre de points de vie du joueur
	if creatures_data.size() > 0:
		player_progress_bar_hp.max_value = creatures_data[0].hp
		player_progress_bar_hp.value = creatures_data[0].hp
		
func setup_enemy_animal():
	for key in Global.animals_enemy:
		if Global.animals_enemy[key] == Global.animals_enemy[PlayerStats.animal_id]:
			var animalE = Sprite2D.new()
			animalE.name = "Sprite_animal_enemy"
			animalE.texture = load("res://Textures/Animals/Eagle_infected.png")
			animalE.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			animalE.position = Vector2(1102, 841)
			animalE.z_index = 0
			animalE.scale = Vector2(5.1, 5.1)
			add_child(animalE)
			
# Callback pour les données de créature de l'ennemi
func _on_get_creatures_request_completed(result: int, response_code: int, headers: Array, body: PackedByteArray) -> void:
	if response_code == 200:
		if enemy_creatures_data.size() > 1:
			mob_progress_bar_hp.max_value = enemy_creatures_data.hp
			mob_progress_bar_hp.value = enemy_creatures_data.hp
			mob_percentage_hp.text = str(enemy_creatures_data.hp) + "/" + str(mob_progress_bar_hp.max_value)
			mob_pseudo_label.text = enemy_creatures_data.name
			ennemye_texture = enemy_creatures_data.texture

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
	if event.is_action_pressed("ui_select"):
		if not combat_started:
			print("Appui sur espace détecté : Démarrage du combat.")
			start_combat()
		else:
			print("Appui sur espace détecté : Attaque.")
			_on_attack_bar_pressed()
	
	if not combat_started:
		return
	
	if not buttons_active:
		return
	
	if event.is_action_pressed("Spell_1"):
		ennemy_canAttack = true
		_execute_spell_action("Spell_1", creatures_spells, 0)
	elif event.is_action_pressed("Spell_2"):
		ennemy_canAttack = true
		_execute_spell_action("Spell_2", creatures_spells, 1)
	elif event.is_action_pressed("Spell_3"):
		ennemy_canAttack = true
		_execute_spell_action("Spell_3", creatures_spells, 2)
	elif event.is_action_pressed("Spell_4"):
		ennemy_canAttack = true
		_execute_spell_action("Spell_4", creatures_spells, 3)

func start_combat():
	combat_started = true
	buttons_active = true  # Active les boutons de sorts après le démarrage du combat
	start_overlay.hide()  # Masquer l'overlay de démarrage
	print("Combat commencé")
	
	# mettre de façon random une compétence entre 0 et 3 
	var rand_attack = rng.randi_range(0,3)
	_remplir_barre_ennemye(1.5,enemy_creatures_spells[rand_attack].difficulty,enemy_creatures_spells[rand_attack].value, enemy_creatures_spells[rand_attack].mode, rand_attack)

	
# Nouvelle fonction pour exécuter les actions de debug et de remplissage de la barre
func _execute_spell_action(button_name: String, spells: Array, index: int):
	if spells.size() > index:
		var spell_data = spells[index]
		# Appelle la fonction de debug pour afficher les informations du sort
		_debug_spell_info(spell_data)
		# Modifie le texte qui affiche la compétence en fonction du spell sélectionner 
		spell_name_player.text = spell_data.name
		spell_name_player.visible = true
		# changer la couleur du text en fonction de son élément 
		if attack_colors.has(spell_data.element):
			spell_name_player.modulate = attack_colors[spell_data.element]
		
		# Joue le son associé en fonction du sort utilisé
		match button_name:
			"Spell_1":
				spell_1_sound.play()
			"Spell_2":
				spell_2_sound.play()
			"Spell_3":
				spell_3_sound.play()
			"Spell_4":
				spell_4_sound.play()
		
		# Appelle la fonction pour remplir la barre et appliquer les dégâts
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
	print("---- Informations du Sort ----")
	print("Nom du sort :", spell_data.name)
	print("Type d'attaque :", spell_data.type)
	print("Valeur :", spell_data.value)
	print("Mode :", spell_data.mode)
	print("Difficulty :", spell_data.difficulty)
	print("---- Fin ----")

# Fonction pour configurer chaque bouton de sort
func configure_spell_button(button_name: String, spell_data: Dictionary) -> void:
	var button = get_node(button_name)
	if button != null:
		# Définir le texte du bouton avec le nom du sort et sa valeur
		button.text = spell_data.name + " : " + str(spell_data.value)
		
		# Définir la couleur de fond du bouton en fonction du type d'attaque
		var attack_type = spell_data.element
		if attack_colors.has(attack_type):
			button.modulate = attack_colors[attack_type]
		
		# Afficher la difficulté sous le bouton
		var difficulty_label = button.get_node("difficulty" + button_name.substr(-1))  # Récupère difficulty1, difficulty2, etc.
		if difficulty_label != null:
			difficulty_label.text = str(spell_data.difficulty)
			
func _load_local_json():

	var json_as_text = FileAccess.get_file_as_string(CREATURES_FILE_PATH)
	var parse_result = JSON.parse_string(json_as_text)

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
	

func desactivate_buttons():
	if buttonP != null and buttonE != null:
		buttonP.disabled = true
		buttonE.disabled = true
		get_node("Button").disabled = true
		get_node("Button2").disabled = true
		
	else:
		print("Les boutons ne sont pas initialisés.")

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
		
func spawn_dialogue(custom_texts):
	var dialogue = speechbox.instantiate()
	dialogue.position = Vector2(0,-380)
	dialogue.texts = custom_texts
	add_child(dialogue)

func _process(delta):
	rng.randomize()

func _on_spell_button_pressed(spell_data: Dictionary) -> void:
	set_spell_buttons_enabled(false)  # Désactive les boutons pendant la progression
	current_attack_value = spell_data.value  # Récupère la valeur de l'attaque actuelle
	current_mode = spell_data.mode
	current_difficulty = spell_data.difficulty
	print("Démarrage de la barre de progression pour la compétence :", current_difficulty)
	await _remplir_barre_automatiquement(1.5, current_difficulty)  # Démarre la barre de progression
	set_spell_buttons_enabled(true)  # Réactive les boutons après la progression
	print("Barre de progression terminée et boutons réactivés.")


func set_spell_buttons_enabled(enabled: bool) -> void:
	buttons_active = enabled  # Met à jour le drapeau pour bloquer/débloquer les touches

	for button in get_tree().get_nodes_in_group("spell_buttons"):
		button.disabled = not enabled
	print("Boutons activés :", enabled)

# Fonction pour remplir la barre automatiquement, avec des étapes claires pour le suivi
# Remplissage de la barre avec détection de la zone cible
func _remplir_barre_automatiquement(duree: float, difficulty: String) -> void:
	success_count = 0
	var difficulty_to_zones = {
		"easy": 1,
		"medium": 2,
		"hard": 3
	}
	var num_zones = difficulty_to_zones.get(difficulty, 1)
	
	var min_position_percentage = 20
	var max_position_percentage = 80
	var zone_width_percentage = 15
	
	var bar_width = progress_bar_joueur.get_size().x
	
	# Créer les zones cibles en fonction du nombre de zones
	var zones = []
	for i in range(num_zones):
		var range_start_percentage = min_position_percentage + i * (max_position_percentage - min_position_percentage) / num_zones
		var range_end_percentage = range_start_percentage + (max_position_percentage - min_position_percentage) / num_zones - zone_width_percentage
	
		var start_x_percentage = rng.randi_range(range_start_percentage, range_end_percentage)
		var start_x = bar_width * (start_x_percentage / 100.0)
		var zone_width = bar_width * (zone_width_percentage / 100.0)
	
		var zone_cible = progress_bar_joueur.get_node("ZoneCible" + str(i + 1))
		zone_cible.visible = true
		zone_cible.set_size(Vector2(zone_width, zone_cible.size.y))
		zone_cible.position.x = start_x
	
		zones.append([start_x, start_x + zone_width])
		
		# Débogage : Afficher les positions des zones
		print("ZoneCible" + str(i + 1) + " : Start X =", start_x, ", End X =", start_x + zone_width)
	
	# Remplir la barre de progression
	var elapsed_time = 0.0
	var start_value = 0.0
	var end_value = progress_bar_joueur.max_value
	
	while elapsed_time < duree:
		var t = elapsed_time / duree
		progress_bar_joueur.value = lerp(start_value, end_value, t)
		

		# Vérifier si la barre est dans une des zones cibles (pour feedback visuel si nécessaire)
		var progress_x = bar_width * (progress_bar_joueur.value / progress_bar_joueur.max_value)
		in_target_zone = false
		for zone in zones:
			if progress_x >= zone[0] and progress_x <= zone[1]:
				in_target_zone = true
				break
		
		await get_tree().process_frame
		elapsed_time += get_process_delta_time()
	
	# Remplir la barre jusqu'à la fin si elle ne l'est pas déjà
	progress_bar_joueur.value = end_value
	
	# Déterminer le niveau de réussite basé sur les succès accumulés et la difficulté
	var success_level = determine_success_level(success_count, difficulty)
	print("Niveau de réussite déterminé :", success_level)
	
	# Appliquer les dégâts en fonction du niveau de réussite
	apply_damage_to_enemy(current_attack_value, success_level, current_mode)
	
	# Jouer le son associé au niveau de réussite
	match success_level:
		0:
			spell_2_sound.play()  # Échec total
		1:
			spell_2_sound.play()  # Échec partiel ou Réussite Normale ou Partielle selon la difficulté
		2:
			spell_1_sound.play()  # Réussite normale ou Réussite Critique selon la difficulté
		3:
			spell_1_sound.play()  # Réussite Critique
		_:
			pass  # Aucun son pour les valeurs inconnues
	
	# Réinitialiser la barre de progression et les zones cibles
	progress_bar_joueur.value = 0
	for i in range(num_zones):
		var zone_cible = progress_bar_joueur.get_node("ZoneCible" + str(i + 1))
		zone_cible.visible = false
	
	in_target_zone = false
	space_pressed = false
	spell_name_player.text = ""
	print("Barre de progression réinitialisée.")

# Détecte l'appui sur la barre espace et vérifie si on est dans la zone cible
func _on_attack_bar_pressed():
	# Vérifier si la barre est dans une zone cible au moment de l'appui
	var progress_percentage = progress_bar_joueur.value / progress_bar_joueur.max_value
	var in_target = false
	print("Progression actuelle :", progress_percentage)

	var zones = [
		progress_bar_joueur.get_node("ZoneCible1"),
		progress_bar_joueur.get_node("ZoneCible2"),
		progress_bar_joueur.get_node("ZoneCible3")
	]

	for zone in zones:
		if not zone.visible:
			continue
		var zone_start_percentage = zone.position.x / progress_bar_joueur.get_size().x
		var zone_end_percentage = (zone.position.x + zone.size.x) / progress_bar_joueur.get_size().x
		if progress_percentage >= zone_start_percentage and progress_percentage <= zone_end_percentage:
			in_target = true
			break

	if in_target:
		success_count += 1
		print("Succès ajouté, total :", success_count)
		# Optionnel : Jouer un son de succès ou donner un feedback visuel
	else:
		print("Tentative échouée.")
		# Optionnel : Jouer un son d'échec ou donner un feedback visuel


		# Optionnel : Jouer un son d'échec ou donner un feedback visuel

func apply_damage_to_enemy(damage: int, success_level: int, mode: String) -> void:
	var final_damage = damage
	match success_level:
		0:
			final_damage = 0
		1:
			if mode == "att":
				final_damage = int(final_damage / 2)
			elif mode == "def":
				final_damage = int(final_damage / 2)
		2:
			pass
		3:
			final_damage = int(final_damage * 1.5)
			
	# Si mode "def", le lanceur (le joueur) gagne du bouclier
	if mode == "def":
		var current_shield = player_percentage_shield.text.to_int()
		current_shield += final_damage
		player_percentage_shield.text = str(current_shield)
	else:
		var current_shield = mob_percentage_shield.text.to_int()
		if current_shield > 0:
			current_shield -= final_damage
			mob_percentage_shield.text = str(current_shield)
			if current_shield < 0:
				final_damage = abs(current_shield)
				current_shield = 0
				mob_percentage_shield.text = str(current_shield)
				mob_progress_bar_hp.value -= final_damage
				mob_percentage_hp.text = str(mob_progress_bar_hp.value) + "/" + str(mob_progress_bar_hp.max_value)
		else:
			mob_progress_bar_hp.value -= final_damage
			mob_percentage_hp.text = str(mob_progress_bar_hp.value) + "/" + str(mob_progress_bar_hp.max_value)
			
	print("Niveau de réussite :", success_level)
	print("Mode :", mode)
	
	var damage_label = Label.new()
	damage_label.add_theme_font_size_override("font_size", 30)
	damage_label.modulate = Color(1.0, 0.2, 0.2, 0.0)
	
	var tween = create_tween()
	if mode == "def":
		# Mode défensif : le lanceur (joueur) gagne du bouclier, on affiche un "+"
		damage_label.text = "+" + str(final_damage)
		progress_bar_joueur.get_node("VBoxContainer").add_child(damage_label)
	else:
		# Mode attaque : l'ennemi subit des dégâts, on affiche un "-"
		damage_label.text = "-" + str(final_damage)
		progress_bar_ennemye.get_node("VBoxContainer").add_child(damage_label)
		
	tween.tween_property(damage_label, "modulate", Color(1.0, 0.2, 0.2, 1.0), 0.5).from(Color(1.0, 0.2, 0.2, 0.0))
	tween.tween_callback(Callable(self, "_do_nothing")).set_delay(3.0)
	tween.tween_property(damage_label, "modulate", Color(1.0, 0.2, 0.2, 0.0), 0.5)
	tween.tween_callback(Callable(damage_label, "queue_free"))

func _do_nothing() -> void:
	pass



func determine_success_level(success_count: int, difficulty: String) -> int:
	match difficulty:
		"hard":
			if success_count >= 3:
				return 3  # Réussite Critique
			elif success_count == 2:
				return 2  # Réussite Normale
			elif success_count == 1:
				return 1  # Échec Partiel
			else:
				return 0  # Échec Total
		"medium":
			if success_count >= 2:
				return 2  # Réussite Critique
			elif success_count == 1:
				return 1  # Réussite Normale
			else:
				return 0  # Échec Total
		"easy":
			if success_count >= 2:
				return 2  # Réussite Normale
			elif success_count == 1:
				return 1  # Réussite Partielle
			else:
				return 0  # Échec Total (si applicable)
		_:
			return 0  # Valeur par défaut en cas de difficulté inconnue

func _on_get_spells_player_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response_text = body.get_string_from_utf8()
	var parse_result = JSON.parse_string(response_text)
	creatures_spells = parse_result

func _on_get_spells_ennemy_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response_text = body.get_string_from_utf8()
	var parse_result = JSON.parse_string(response_text)
	enemy_creatures_spells = parse_result
	await get_ennemye_spell()
	

func get_ennemye_spell() -> void:
	if enemy_creatures_spells.size() > 0:
		print("---- Début de l'affichage des sorts de l'ennemi ----")
		
		for spell_data in enemy_creatures_spells:
			await ennemy_manager.display_enemy_spell(spell_data)
			
		print("---- Fin de l'affichage des sorts de l'ennemi ----")
	else:
		print("Erreur : Les sorts de l'ennemi n'ont pas été chargés correctement.")


func _on_get_creatures_enemy_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response_text = body.get_string_from_utf8()
	var parse_result = JSON.parse_string(response_text)
	enemy_creatures_data = parse_result


func _remplir_barre_ennemye(duree: float, difficulty: String,  ennemye_attack: int, ennemye_mode: String, competence_number) -> void:
	
	number_attack + 1
	
	var difficulty_to_zones = {
		"easy": 1,
		"medium": 2,
		"hard": 3
	}
	# récuperer le nom de la compétence choissi par l'ennemie 
	print("nom de la compétence :" + enemy_creatures_spells[competence_number].name)
	
	var num_zones = difficulty_to_zones.get(difficulty, 1)
	
	var min_position_percentage = 20
	var max_position_percentage = 80
	var zone_width_percentage = 15
	spell_name_ennemye.text = enemy_creatures_spells[competence_number].name
	spell_name_ennemye.visible = true
	if attack_colors.has(enemy_creatures_spells[competence_number].element):
		spell_name_ennemye.modulate = attack_colors[enemy_creatures_spells[competence_number].element]

	
	var bar_width = progress_bar_ennemye.get_size().x
	
	# Créer les zones cibles en fonction du nombre de zones
	var zones = []
	for i in range(num_zones):
		var range_start_percentage = min_position_percentage + i * (max_position_percentage - min_position_percentage) / num_zones
		var range_end_percentage = range_start_percentage + (max_position_percentage - min_position_percentage) / num_zones - zone_width_percentage
	
		var start_x_percentage = rng.randi_range(range_start_percentage, range_end_percentage)
		var start_x = bar_width * (start_x_percentage / 100.0)
		var zone_width = bar_width * (zone_width_percentage / 100.0)
	
		var zone_cible = progress_bar_ennemye.get_node("ZoneCible" + str(i + 1))
		zone_cible.visible = true
		zone_cible.set_size(Vector2(zone_width, zone_cible.size.y))
		zone_cible.position.x = start_x
	
		zones.append([start_x, start_x + zone_width])
		
		# Débogage : Afficher les positions des zones
		print("ZoneCible" + str(i + 1) + " : Start X =", start_x, ", End X =", start_x + zone_width)
	
	# Remplir la barre de progression
	var elapsed_time = 0.0
	var start_value = 0.0
	var end_value = progress_bar_ennemye.max_value
	
	while elapsed_time < duree:
		var t = elapsed_time / duree
		progress_bar_ennemye.value = lerp(start_value, end_value, t)
		

		# Vérifier si la barre est dans une des zones cibles (pour feedback visuel si nécessaire)
		var progress_x = bar_width * (progress_bar_ennemye.value / progress_bar_ennemye.max_value)

		var in_target_zone = false
		for zone in zones:
			if progress_x >= zone[0] and progress_x <= zone[1]:
				in_target_zone = true
				break
		
		await get_tree().process_frame
		elapsed_time += get_process_delta_time()
	
	# Remplir la barre jusqu'à la fin si elle ne l'est pas déjà
	progress_bar_ennemye.value = end_value

	var success_level = rng.randi_range(0, difficulty_to_zones[difficulty])
	print("Niveau de réussite déterminé :", success_level)

	apply_damage_to_player(ennemye_attack, success_level, ennemye_mode)
	
	# Réinitialiser la barre de progression et les zones cibles
	progress_bar_ennemye.value = 0
	for i in range(num_zones):
		var zone_cible = progress_bar_ennemye.get_node("ZoneCible" + str(i + 1))
		zone_cible.visible = false
	
	print("Barre de progression réinitialisée.")
	var random_number = rng.randi_range(0,3)
	_remplir_barre_ennemye(1.5,enemy_creatures_spells[random_number].difficulty,enemy_creatures_spells[random_number].value, enemy_creatures_spells[random_number].mode, random_number)


func apply_damage_to_player(damage: int, success_level: int, mode: String) -> void:
	var final_damage = damage
	match success_level:
		0:
			final_damage = 0
		1:
			if mode == "att":
				final_damage = int(final_damage / 2)
			elif mode == "def":
				final_damage = int(final_damage / 2)
		2:
			pass
		3:
			final_damage = int(final_damage * 1.5)
			
	# Si mode "def", le lanceur (l'ennemi) gagne du bouclier
	if mode == "def":
		var current_shield = mob_percentage_shield.text.to_int()
		current_shield += final_damage
		mob_percentage_shield.text = str(current_shield)
	else:
		var current_shield = player_percentage_shield.text.to_int()
		if current_shield > 0:
			current_shield -= final_damage
			player_percentage_shield.text = str(current_shield)
			if current_shield < 0:
				final_damage = abs(current_shield)
				current_shield = 0
				player_percentage_shield.text = str(current_shield)
				player_progress_bar_hp.value -= final_damage
				player_percentage_hp.text = str(player_progress_bar_hp.value) + "/" + str(player_progress_bar_hp.max_value)
		else:
			player_progress_bar_hp.value -= final_damage
			player_percentage_hp.text = str(player_progress_bar_hp.value) + "/" + str(player_progress_bar_hp.max_value)
			
	print("Niveau de réussite :", success_level)
	print("Mode :", mode)
	
	var damage_label = Label.new()
	damage_label.add_theme_font_size_override("font_size", 30)
	damage_label.modulate = Color(1.0, 0.2, 0.2, 0.0)
	
	var tween = create_tween()
	if mode == "def":
		# Mode défensif : le lanceur (ennemi) gagne du bouclier, on affiche un "+"
		damage_label.text = "+" + str(final_damage)
		progress_bar_ennemye.get_node("VBoxContainer").add_child(damage_label)
	else:
		# Mode attaque : le joueur subit des dégâts, on affiche un "-"
		damage_label.text = "-" + str(final_damage)
		progress_bar_joueur.get_node("VBoxContainer").add_child(damage_label)
		
	tween.tween_property(damage_label, "modulate", Color(1.0, 0.2, 0.2, 1.0), 0.5).from(Color(1.0, 0.2, 0.2, 0.0))
	tween.tween_callback(Callable(self, "_do_nothing")).set_delay(3.0)
	tween.tween_property(damage_label, "modulate", Color(1.0, 0.2, 0.2, 0.0), 0.5)
	tween.tween_callback(Callable(damage_label, "queue_free"))
