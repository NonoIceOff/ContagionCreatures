extends Node2D

@onready var panel = $Panel
@onready var level_label = $Panel/VBoxContainer/LevelLabel
@onready var xp_progress_bar = $Panel/VBoxContainer/XPProgressBar
@onready var xp_details_label = $Panel/VBoxContainer/XPDetailsLabel

var panel_visible = false
var is_leveling_up = false

func _ready():
	panel.show()
	level_label.text = "Niveau : %d" % Global.level
	xp_progress_bar.value = float(Global.current_xp) / Global.xp_to_next_level * 100
	xp_details_label.text = "XP : %d / %d" % [Global.current_xp, Global.xp_to_next_level]

func gain_xp(amount: int):
	print("Gaining XP: %d" % amount)
	Global.target_xp += amount
	update_xp()

func update_xp():
	Global.current_xp += Global.target_xp
	Global.target_xp = 0

	xp_details_label.text = "XP : %d / %d" % [Global.current_xp, Global.xp_to_next_level]

	animate_xp_update()

	if Global.current_xp >= Global.xp_to_next_level and not is_leveling_up:
		level_up()

func animate_xp_update():
	var _start_value = xp_progress_bar.value
	var end_value = float(Global.current_xp) / Global.xp_to_next_level * 100

	var tween = get_tree().create_tween()
	tween.tween_property(xp_progress_bar, "value", end_value, 0.5)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN_OUT)

func level_up():
	is_leveling_up = true

	var excess_xp = Global.current_xp - Global.xp_to_next_level

	var tween = get_tree().create_tween()
	tween.tween_property(xp_progress_bar, "value", 0, 0.5)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.finished.connect(func():
		Global.level += 1
		Global.current_xp = excess_xp
		Global.xp_to_next_level = int(Global.xp_to_next_level * 1.1)

		level_label.text = "Niveau : %d" % Global.level
		xp_progress_bar.value = float(Global.current_xp) / Global.xp_to_next_level * 100
		xp_details_label.text = "XP : %d / %d" % [Global.current_xp, Global.xp_to_next_level]

		if Global.current_xp >= Global.xp_to_next_level:
			level_up()
		is_leveling_up = false
	)
