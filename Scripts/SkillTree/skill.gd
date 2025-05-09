extends Control
class_name Skill          # nouveau type

@export var display_name : String = "Nom du skill"   # affiché dans le panneau
@export var cost         : int    = 1
@export var tier         : int    = 1                # « palier » (1, 2, 3…)
@export var description  : String = "Texte"
@export var unlocked     : bool   = false    
@export var icon_texture : Texture2D    # NEW  ← assignable dans l’inspecteur
		# verrouillé par défaut
var active   : bool = false

@onready var icon  : Sprite2D = $Icon            
@onready var btn   = $Button
@onready var panel = $Button/Panel
@onready var top   = $Button/Panel/Top_label
@onready var bot   = $Button/Panel/Bot_label
var skill_tree : Node = null          # référence vers le contrôleur


func _ready():
	print("[Skill::_ready] %s  tier=%d  cost=%d  unlocked=%s"
	% [name, tier, cost, unlocked])
	if icon_texture:
		icon.texture = icon_texture         
	_refresh()
	btn.pressed.connect(_on_pressed)
	btn.mouse_entered.connect(_on_mouse_entered)
	btn.mouse_exited.connect(_on_mouse_exited)

 # --------- trouver le bon parent -----------------
	var n := get_parent()
	while n and not n.has_method("_skill_pressed"):
		n = n.get_parent()
	skill_tree = n
	if skill_tree == null:
		push_error("Skill.gd : aucun ancêtre n’implémente _skill_pressed()")
	# -------------------------------------------------

func _on_pressed():
	print("[Skill::_on_pressed] clic sur", name)
	if skill_tree:
		skill_tree._skill_pressed(self)

func _refresh():
	# ---------- Texte ----------
	top.text = "%s\n%s" % [
		display_name,
		"Active" if active else "Inactive" if unlocked else "Coût : %d" % cost
	]
	bot.text = "Palier %d – %s" % [tier, description]

	# ---------- Couleur ----------
	var col : Color
	if unlocked:
		col = Color(1,1,1) if active else Color(0.5,0.5,0.5)   # blanc ou gris
	else:
		col = Color(0.2,0.2,0.2)                                # quasi noir

	icon.modulate = col
	btn.modulate  = col

	print("  %s  unlocked=%s  active=%s  col=%s"
		  % [name, unlocked, active, col])

func _on_mouse_entered():
	print("[Skill::hover] → mouse_enter", name)
	panel.visible = true

func _on_mouse_exited():
	print("[Skill::hover] ← mouse_exit ", name)
	panel.visible = false
