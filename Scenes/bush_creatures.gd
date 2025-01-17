extends TileMap

# Nom du TileMap contenant les hautes herbes
const TILEMAP_NAME = "bush"
# ID des hautes herbes dans le TileSet
const BUSH_TILE_ID = 1
# Probabilités minimales et maximales pour tomber sur une créature
const MIN_PROBABILITY = 0.1 # 10%
const MAX_PROBABILITY = 0.5 # 50%

# Variable interne pour ajuster la probabilité à chaque pas
var current_probability = MIN_PROBABILITY

func _process(_delta):
    var tilemap = get_node(TILEMAP_NAME)
    if tilemap:
        var position_in_map = tilemap.world_to_map(global_position)
        var cell = tilemap.get_cell(position_in_map.x, position_in_map.y)
        
        if cell == BUSH_TILE_ID:
            # On est dans les hautes herbes, on tente une rencontre aléatoire
            if randf() < current_probability:
                print("Rencontre une créature dans les hautes herbes !")
                # Réinitialise la probabilité après une rencontre
                current_probability = MIN_PROBABILITY
            else:
                # Augmente progressivement la probabilité pour la prochaine tentative
                current_probability = clamp(current_probability + 0.05, MIN_PROBABILITY, MAX_PROBABILITY)

func _ready():
    var tilemap = get_node(TILEMAP_NAME)
    if not tilemap or not tilemap.has_method("get_cell"):
        print("Erreur : TileMap introuvable ou non valide.")



	