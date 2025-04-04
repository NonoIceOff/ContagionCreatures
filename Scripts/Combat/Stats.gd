extends Node2D

# setting the text of the stats getting the variable
var total_damage_player
var total_heal_player
var total_shield_player
var max_damage_player
var max_heal_player
var max_shield_player
var total_damage_enemy
var total_heal_enemy
var total_shield_enemy
var max_damage_enemy
var max_heal_enemy
var max_shield_enemy
var critique_attaque_player = 0
var critique_attaque_ennemye = 0
var normal_attaque_player = 0
var normal_attaque_ennemye = 0
var echec_attaque_player = 0
var echec_attaque_ennemye = 0
var total_attaque_player = 0
var total_attaque_ennemye = 0

@onready var total_damage_player_label = $Stats/Joueur/Total_damage
@onready var total_heal_player_label = $Stats/Joueur/Total_heal
@onready var total_shield_player_label = $Stats/Joueur/Total_shield
@onready var max_damage_player_label = $Stats/Joueur/Max_damage
@onready var max_heal_player_label = $Stats/Joueur/Max_heal
@onready var max_shield_player_label = $Stats/Joueur/Max_shield
@onready var succes_player = $Stats/Joueur/succes


@onready var total_damage_enemy_label = $Stats/Ennemi/Total_damage
@onready var total_heal_enemy_label = $Stats/Ennemi/Total_heal
@onready var total_shield_enemy_label = $Stats/Ennemi/Total_shield
@onready var max_damage_enemy_label = $Stats/Ennemi/Max_damage
@onready var max_heal_enemy_label = $Stats/Ennemi/Max_heal
@onready var max_shield_enemy_label = $Stats/Ennemi/Max_shield
@onready var succes_enemy = $Stats/Ennemi/succes


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#test 
	total_damage_player_label.text += ": test"
	

func set_all_text_variable( total_damage_player, total_heal_player, total_shield_player, max_damage_player, max_heal_player, max_shield_player, total_damage_enemy, total_heal_enemy, total_shield_enemy, max_damage_enemy, max_heal_enemy, max_shield_enemy, critique_attaque_player, critique_attaque_ennemye, normal_attaque_player, normal_attaque_ennemye, echec_attaque_player, echec_attaque_ennemye):
	total_damage_player_label.text += str(total_damage_player)
	total_heal_player_label.text += str(total_heal_player)
	total_shield_player_label.text += str(total_shield_player)
	max_damage_player_label.text += str(max_damage_player)
	max_heal_player_label.text += str(max_heal_player)
	max_shield_player_label.text += str(max_shield_player)
	succes_player.text += str(echec_attaque_player) + " | " + str(normal_attaque_player) + " | " + str(critique_attaque_player)
	
	total_damage_enemy_label.text += str(total_damage_enemy)
	total_heal_enemy_label.text += str(total_heal_enemy)
	total_shield_enemy_label.text += str(total_shield_enemy)
	max_damage_enemy_label.text += str(max_damage_enemy)
	max_heal_enemy_label.text += str(max_heal_enemy)
	max_shield_enemy_label.text += str(max_shield_enemy)
	succes_enemy.text += str(echec_attaque_ennemye) + " | " + str(normal_attaque_ennemye) + " | " + str(critique_attaque_ennemye)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
