extends Node
class_name CombatManager

# On utilise Range pour éviter les conflits entre ProgressBar et TextureProgressBar
var progress_bar_joueur: Range
var mob_progress_bar_hp: Range

# Labels
var player_percentage_shield: Label
var mob_percentage_hp: Label

# Sons
var spell_1_sound: AudioStreamPlayer2D
var spell_2_sound: AudioStreamPlayer2D

# Variables internes
var current_attack_value: int = 0
var current_mode: String = ""
var current_difficulty: String = ""
var success_count: int = 0
var in_target_zone: bool = false
var space_pressed: bool = false

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	print("CombatManager : prêt.")

# Appelé depuis la scène quand on appuie sur la barre d'attaque (Espace)
func on_attack_bar_pressed():
	var progress_percentage = progress_bar_joueur.value / progress_bar_joueur.max_value
	var in_target = false

	# Si vous avez trois zones cibles : ZoneCible1, ZoneCible2, ZoneCible3
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
	else:
		print("Tentative échouée.")

# Appelé depuis la scène quand un sort est lancé
func on_spell_button_pressed(spell_data: Dictionary):
	print("Sort lancé :", spell_data.name)
	current_attack_value = spell_data.value
	current_mode = spell_data.mode
	current_difficulty = spell_data.difficulty
	
	# (Optionnel) Désactiver les boutons dans la scène : get_parent().set_spell_buttons_enabled(false)
	
	await _remplir_barre_automatiquement(1.5, current_difficulty)
	
	# (Optionnel) Réactiver les boutons : get_parent().set_spell_buttons_enabled(true)

func _remplir_barre_automatiquement(duree: float, difficulty: String):
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
		
		print("ZoneCible" + str(i + 1) + " : Start =", start_x, ", End =", start_x + zone_width)
	
	var elapsed_time = 0.0
	var start_value = 0.0
	var end_value = progress_bar_joueur.max_value
	
	while elapsed_time < duree:
		var t = elapsed_time / duree
		progress_bar_joueur.value = lerp(start_value, end_value, t)
		
		var progress_x = bar_width * (progress_bar_joueur.value / progress_bar_joueur.max_value)
		in_target_zone = false
		for zone in zones:
			if progress_x >= zone[0] and progress_x <= zone[1]:
				in_target_zone = true
				break
		
		await get_tree().process_frame
		elapsed_time += get_process_delta_time()
	
	progress_bar_joueur.value = end_value
	
	var success_level = determine_success_level(success_count, difficulty)
	print("Niveau de réussite déterminé :", success_level)
	
	apply_damage_to_enemy(current_attack_value, success_level, current_mode)
	
	match success_level:
		0: spell_2_sound.play()  # Échec total
		1: spell_2_sound.play()  # Réussite partielle
		2: spell_1_sound.play()  # Réussite normale
		3: spell_1_sound.play()  # Réussite critique
	
	progress_bar_joueur.value = 0
	for i in range(num_zones):
		var zone_cible = progress_bar_joueur.get_node("ZoneCible" + str(i + 1))
		zone_cible.visible = false
	
	in_target_zone = false
	space_pressed = false
	print("Barre de progression réinitialisée.")

func determine_success_level(success_count: int, difficulty: String) -> int:
	match difficulty:
		"hard":
			if success_count >= 3:
				return 3
			elif success_count == 2:
				return 2
			elif success_count == 1:
				return 1
			else:
				return 0
		"medium":
			if success_count >= 2:
				return 2
			elif success_count == 1:
				return 1
			else:
				return 0
		"easy":
			if success_count >= 2:
				return 2
			elif success_count == 1:
				return 1
			else:
				return 0
		_:
			return 0

func apply_damage_to_enemy(damage: int, success_level: int, mode: String):
	var final_damage = damage
	
	match success_level:
		0: final_damage = 0
		1: final_damage = int(final_damage / 2)
		2: pass
		3: final_damage = int(final_damage * 1.5)
	
	if mode == "def":
		var current_shield = player_percentage_shield.text.to_int()
		current_shield += final_damage
		player_percentage_shield.text = str(current_shield)
		print("Bouclier ajouté :", final_damage)
	else:
		mob_progress_bar_hp.value -= final_damage
		mob_percentage_hp.text = str(int(mob_progress_bar_hp.value)) + "/" + str(int(mob_progress_bar_hp.max_value))
		print("Dégâts infligés :", final_damage)
	
	print("Niveau de réussite :", success_level)
	print("Mode :", mode)
