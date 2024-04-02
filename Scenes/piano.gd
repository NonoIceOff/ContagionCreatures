extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on__pressed():
	get_node("1/AudioStreamPlayer2D").playing = true


func _on_2_pressed():
	get_node("2/AudioStreamPlayer2D").playing = true


func _on_3_pressed():
	get_node("3/AudioStreamPlayer2D").playing = true




func _on_4_pressed():
	get_node("4/AudioStreamPlayer2D").playing = true


func _on_5_pressed():
	get_node("5/AudioStreamPlayer2D").playing = true


func _on_6_pressed():
	get_node("6/AudioStreamPlayer2D").playing = true


func _on_7_pressed():
	get_node("7/AudioStreamPlayer2D").playing = true


func _on_8_pressed():
	get_node("8/AudioStreamPlayer2D").playing = true


func _on_9_pressed():
	get_node("9/AudioStreamPlayer2D").playing = true


func _on_10_pressed():
	get_node("10/AudioStreamPlayer2D").playing = true


func _on_11_pressed():
	get_node("11/AudioStreamPlayer2D").playing = true


func _on_12_pressed():
	get_node("12/AudioStreamPlayer2D").playing = true


func _on_quit_pressed():
	queue_free()
