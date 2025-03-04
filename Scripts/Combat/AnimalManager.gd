# Scripts/Combat/AnimalManager.gd
extends Node
class_name AnimalManagerLocal

# Méthode d'initialisation de l'animal du joueur
func setup_player_animal(parent: Node) -> void:
    var animalP = Sprite2D.new()
    # Ici, vous chargez la texture à partir d'un chemin défini dans vos constantes/globales
    animalP.texture = load("res://Chemin/vers/texture_joueur.png")
    animalP.position = Vector2(774, 995)
    animalP.scale = Vector2(5.1, 5.1)
    parent.add_child(animalP)
    print("Animal du joueur configuré.")

# Méthode d'initialisation de l'animal ennemi
func setup_enemy_animal(parent: Node) -> void:
    var animalE = Sprite2D.new()
    animalE.texture = load("res://Chemin/vers/texture_ennemi.png")
    animalE.position = Vector2(1102, 841)
    animalE.scale = Vector2(5.1, 5.1)
    parent.add_child(animalE)
    print("Animal ennemi configuré.")
