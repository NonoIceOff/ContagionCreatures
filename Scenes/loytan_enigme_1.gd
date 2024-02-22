extends Node2D

var earn = 100
var looser = false
var looser_i = 0
var winner = false


# Called when the node enters the scene tree for the first time.
func _ready():
	launch()
	


func launch():
	get_node("ResultWin/Validate").visible = false
	get_node("ResultLoose/CPUParticles2D").visible = true
	get_node("ResultLoose/TextureRect").visible = false
	get_node("ResultLoose/Panel").visible = false
	get_node("ResultLoose").visible = false
	get_node("ResultWin/CPUParticles2D").visible = true
	get_node("ResultWin/TextureRect").visible = false
	get_node("ResultWin/Panel").visible = false
	get_node("ResultWin").visible = false
	get_node("TextureRect").visible = false
	get_node("ColorRect").visible = true
	get_node("ColorRect/Coins").text = str(earn)
	get_node("TextureRect/Coins").text = str(earn)
	get_node("AudioStreamPlayer2D").stream = load("res://Sounds/enigma_debut2.mp3")
	get_node("AudioStreamPlayer2D").play()
	await get_tree().create_timer(3).timeout
	get_node("AudioStreamPlayer2D").stream = load("res://Sounds/Puzzles_2.mp3")
	get_node("AudioStreamPlayer2D").play()
	get_node("ColorRect").visible = false
	get_node("TextureRect").visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_1_pressed():
	loose(1)


func _on_2_pressed():
	loose(2)


func _on_3_pressed():
	loose(3)


func _on_4_pressed():
	loose(4)


func _on_5_pressed():
	loose(5)


func _on_6_pressed():
	loose(6)


func _on_7_pressed():
	win()

func win():
	get_node("ColorRect").visible = false
	get_node("TextureRect").visible = false
	get_node("ResultWin").visible = true
	get_node("AudioStreamPlayer2D").stream = load("res://Sounds/enigma_correct2.mp3")
	get_node("AudioStreamPlayer2D").play()
	await get_tree().create_timer(3).timeout
	get_node("ResultWin/ColorRect").visible = true
	await get_tree().create_timer(3).timeout
	get_node("ResultWin/TextureRect").visible = true
	get_node("ResultWin/Panel").visible = true
	get_node("ResultWin/ColorRect").visible = false
	get_node("ResultWin/CPUParticles2D").visible = false
	await get_tree().create_timer(2).timeout
	get_node("AudioStreamPlayer2D").stream = load("res://Sounds/Puzzles_2.mp3")
	get_node("AudioStreamPlayer2D").play()
	get_node("ResultWin/Validate").visible = true
	get_node("ResultWin/AnimationPlayer").current_animation = "validate"
	winner = true
	
func loose(i):
	looser_i = i
	get_node("ColorRect").visible = false
	get_node("TextureRect").visible = false
	get_node("ResultLoose").visible = true
	get_node("AudioStreamPlayer2D").stream = load("res://Sounds/enigma_incorrect2.mp3")
	get_node("AudioStreamPlayer2D").play()
	await get_tree().create_timer(3).timeout
	get_node("ResultLoose/ColorRect").visible = true
	await get_tree().create_timer(3).timeout
	get_node("ResultLoose/TextureRect").visible = true
	get_node("ResultLoose/Panel").visible = true
	get_node("ResultLoose/ColorRect").visible = false
	get_node("ResultLoose/CPUParticles2D").visible = false
	await get_tree().create_timer(2).timeout
	get_node("AudioStreamPlayer2D").stream = load("res://Sounds/Puzzles_2.mp3")
	get_node("AudioStreamPlayer2D").play()
	get_node("ResultLoose/Validate").visible = true
	get_node("ResultLoose/AnimationPlayer").current_animation = "validate"
	looser = true
#	

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			if winner == true:
				win()
				winner = false
				PlayerStats.monnaie += earn
				get_tree().change_scene_to_file("res://Scenes/main_map_anti_conflits.tscn")
			elif looser == true:
				earn -= 100/7
				get_node("TextureRect/"+str(looser_i)).disabled = true
				launch()
				looser = false
