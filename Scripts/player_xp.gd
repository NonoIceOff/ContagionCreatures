extends Node2D

@onready var panel = $Panel
@onready var level_label = $Panel/VBoxContainer/LevelLabel
@onready var xp_progress_bar = $Panel/VBoxContainer/XPProgressBar
@onready var xp_details_label = $Panel/VBoxContainer/XPDetailsLabel

var panel_visible = false
var target_xp = 0
var current_xp = 0
var xp_to_next_level = 100
var level = 1

func show_panel():
	if panel_visible:
		return
	panel_visible = true
	panel.visible = true
	panel.rect_position.y = get_viewport().size.y
	var tween = Tween.new()
	add_child(tween)
	tween.tween_property(panel, "rect_position:y", get_viewport().size.y, get_viewport().size.y - panel.rect_size.y)
	tween.set_duration(0.5)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	remove_child(tween)

func hide_panel():
	panel_visible = false
	var tween = Tween.new()
	add_child(tween)
	tween.tween_property(panel, "rect_position:y", get_viewport().size.y - panel.rect_size.y, get_viewport().size.y)
	tween.set_duration(0.5)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	panel.visible = false
	remove_child(tween)

func update_xp(new_xp: int):
	target_xp += new_xp
	show_panel()
	await animate_xp_update()

func animate_xp_update():
	var tween = Tween.new()
	add_child(tween)
	tween.tween_property(
		xp_progress_bar, "value", xp_progress_bar.value, float(current_xp + target_xp) / xp_to_next_level * 100
	)
	tween.set_duration(1.0)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	current_xp += target_xp
	xp_details_label.text = "XP : %d / %d" % [current_xp, xp_to_next_level]
	if current_xp >= xp_to_next_level:
		level_up()
	hide_panel()
	remove_child(tween)

func level_up():
	current_xp -= xp_to_next_level
	level += 1
	xp_to_next_level = int(xp_to_next_level * 1.5)
	level_label.text = "Niveau : %d" % level
	xp_progress_bar.value = float(current_xp) / xp_to_next_level * 100
	xp_details_label.text = "XP : %d / %d" % [current_xp, xp_to_next_level]
