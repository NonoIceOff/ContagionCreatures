extends Node2D

var pin_position

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT:
			# Obtenir la position globale de la souris en pixels
			var mouse_position = get_global_mouse_position()
			
			# Récupérer le TileMap (assurez-vous que "Ground" est bien un TileMap)
			var tile_map = get_node("Ground")
			
			# Convertir la position globale de la souris en coordonnées locales au TileMap
			var local_mouse_position = tile_map.to_local(mouse_position)
			
			# Obtenir la position de la tuile à partir des coordonnées locales
			var tile_position = tile_map.local_to_map(local_mouse_position)
			
			# Afficher la position de la tuile dans la console
			print("Tile position : ", tile_position)
			
			# Exemple d'appel à une méthode personnalisée (change_pin) sur un autre noeud
			var pin_position = floor(Vector2(tile_position)) * 16 * 3
			#Global.pin = pin_position
			Global.pin_temp = pin_position
			#get_node("../../../../.").change_pin(pin_position)
