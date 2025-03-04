extends Node2D

var pin_position

func _input(event):
	var tile_map = get_node("Ground")

	
	
	if Input.is_action_just_pressed(Controllers.a_input):


		
		var global_center_position = get_global_mouse_position()

		# Get the center of the screen in global coordinates
		Input.warp_mouse(Vector2(992/1.5,544/1.5))

		# Convert the global center position to local tile map coordinates
		var local_center_position = tile_map.to_local(global_center_position)
		
		# Get the tile position from the local coordinates
		var tile_position = tile_map.local_to_map(local_center_position)
		
		# Ensure the pin position is within the map boundaries
		var pin_position = floor(Vector2(tile_position)) * 16 * 3
		Global.pin_temp = pin_position

	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT:
			# Get the global mouse position
			var mouse_position = get_global_mouse_position()
			
			# Convert the global mouse position to local tile map coordinates
			var local_mouse_position = tile_map.to_local(mouse_position)
			
			# Get the tile position from the local coordinates
			var tile_position = tile_map.local_to_map(local_mouse_position)
			
			# Print the tile position for debugging
			print("Tile position : ", tile_position)
			
			# Ensure the pin position is within the map boundaries
			var pin_position = floor(Vector2(tile_position)) * 16 * 3
			Global.pin_temp = pin_position
