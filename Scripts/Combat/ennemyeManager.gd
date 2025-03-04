extends Node
class_name EnnemyManager

# Fonction asynchrone pour afficher un sort spécifique avec un délai
func display_enemy_spell(spell_data: Dictionary) -> void:
	print("Nom du sort :", spell_data.name)
	print("Type d'attaque :", spell_data.type)
	print("Valeur :", spell_data.value)
	print("Mode :", spell_data.mode)
	print("Difficulty :", spell_data.difficulty)
	print("------------")

# Fonction asynchrone pour incrémenter la barre de progression de l'ennemi
