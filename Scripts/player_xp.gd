extends Node2D

@onready var panel = $Panel
@onready var level_label = $Panel/VBoxContainer/LevelLabel
@onready var xp_progress_bar = $Panel/VBoxContainer/XPProgressBar
@onready var xp_details_label = $Panel/VBoxContainer/XPDetailsLabel

var panel_visible = false

func _ready():
	panel.show()
	level_label.text = "Niveau : %d" % Global.level
	xp_progress_bar.value = float(Global.current_xp) / Global.xp_to_next_level * 100
	xp_details_label.text = "XP : %d / %d" % [Global.current_xp, Global.xp_to_next_level]

func gain_xp(amount: int):
	Global.target_xp += amount
	update_xp()

func update_xp():
	await animate_xp_update()

func animate_xp_update():
	var start_value = xp_progress_bar.value
	var end_value = float(Global.current_xp + Global.target_xp) / Global.xp_to_next_level * 100


	var tween = get_tree().create_tween()

	tween.tween_property(xp_progress_bar, "value", start_value, end_value)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN_OUT)


	await tween.finished

	Global.current_xp += Global.target_xp
	Global.target_xp = 0
	xp_details_label.text = "XP : %d / %d" % [Global.current_xp, Global.xp_to_next_level]

	# Check if the player leveled up
	if Global.current_xp >= Global.xp_to_next_level:
		level_up()

func level_up():
	Global.current_xp -= Global.xp_to_next_level
	Global.level += 1
	Global.xp_to_next_level = int(Global.xp_to_next_level * 1.5)
	level_label.text = "Niveau : %d" % Global.level
	xp_progress_bar.value = float(Global.current_xp) / Global.xp_to_next_level * 100
	xp_details_label.text = "XP : %d / %d" % [Global.current_xp, Global.xp_to_next_level]
