extends Node2D

# Variables pour stocker les stats (elles servent ici uniquement si besoin de conserver les valeurs)
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

func _ready() -> void:
	print("✅ _ready() de Stats.tscn exécuté")
	print("Label Total_damage Joueur :", total_damage_player_label)
	# Optionnel : pour confirmer que le label fonctionne, écris un texte de test
	total_damage_player_label.text = "Test stat OK"

func set_all_text_variable(
		total_damage_player, total_heal_player, total_shield_player,
		max_damage_player, max_heal_player, max_shield_player,
		total_damage_enemy, total_heal_enemy, total_shield_enemy,
		max_damage_enemy, max_heal_enemy, max_shield_enemy,
		critique_attaque_player, critique_attaque_ennemye,
		normal_attaque_player, normal_attaque_ennemye,
		echec_attaque_player, echec_attaque_ennemye
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
	
	# Mise à jour des labels Joueur en ajoutant (concatenant) au texte existant
	total_damage_player_label.text += " : " + str(total_damage_player)
	total_heal_player_label.text   += " : " + str(total_heal_player)
	total_shield_player_label.text += " : " + str(total_shield_player)
	max_damage_player_label.text   += " : " + str(max_damage_player)
	max_heal_player_label.text     += " : " + str(max_heal_player)
	max_shield_player_label.text   += " : " + str(max_shield_player)
	succes_player.text             += " : " + str(echec_attaque_player) + " | " + str(normal_attaque_player) + " | " + str(critique_attaque_player)
	
	# Mise à jour des labels Ennemi en ajoutant (concatenant) au texte existant
	total_damage_enemy_label.text += " : " + str(total_damage_enemy)
	total_heal_enemy_label.text   += " : " + str(total_heal_enemy)
	total_shield_enemy_label.text += " : " + str(total_shield_enemy)
	max_damage_enemy_label.text   += " : " + str(max_damage_enemy)
	max_heal_enemy_label.text     += " : " + str(max_heal_enemy)
	max_shield_enemy_label.text   += " : " + str(max_shield_enemy)
	succes_enemy.text             += " : " + str(echec_attaque_ennemye) + " | " + str(normal_attaque_ennemye) + " | " + str(critique_attaque_ennemye)
	
	print("----- Fin de set_all_text_variable() -----")
	print("Label Total_damage Joueur mis à jour :", total_damage_player_label.text)
