extends Node2D
const CFG_PATH := "user://skill.cfg"  # chemin de la sauvegarde

var skill_points = Global.skill_points
var skills : Array[Skill] = []

@onready var lbl_points : Label = $Panel/PointsAvailable   # affiche les points restants
@onready var lbl_error  : Label = $Panel/ErrorMessage      # message d’erreur (caché par défaut)

# ------------------------------------------------------------------ #
func _ready() -> void:
	lbl_error.hide()                 
	_collect_skills()
	_load_state()
	_update_points_label()
	print(" start  pts =", skill_points)
	close()

func _collect_skills() -> void:
	print("look for skills")
	skills.clear()
	_walk(self)
	print("  total :", skills.size())

func _walk(node) -> void:
	for ch in node.get_children():
		if ch is Skill:
			print("  found :", ch.get_path(), "tier", ch.tier)
			skills.append(ch)
		_walk(ch)

func _skill_pressed(s: Skill) -> void:
	print("Before  pts=%d  %s (tier %d)  unlocked=%s active=%s"
		  % [skill_points, s.name, s.tier, s.unlocked, s.active])

	if !s.unlocked:
		# Vérifie le palier précédent
		if s.tier > 1 and !_has_unlocked_tier(s.tier - 1):
			_show_error("Débloque d'abord une compétence de palier %d !" % (s.tier - 1))
			return

		# Vérifie les points
		if skill_points < s.cost:
			_show_error("Pas assez de points (il en faut %d)" % s.cost)
			return

		# Déverrouillage
		Global.skill_points -= s.cost
		#remettre le label à jour
		skill_points = Global.skill_points
		lbl_points.text = "Points disponibles : %d" % skill_points
		s.unlocked = true
		print("  %s déverrouillé, pts restants = %d" % [s.name, Global.skill_points])
	else:
		# Toggle actif / inactif
		s.active = !s.active
		print(" %s devient %s" % [s.name, "ACTIF" if s.active else "INACTIF"])
	s._refresh()
	_update_points_label()
	_save_state()
	print("After  pts=%d  %s  unlocked=%s active=%s"
		  % [skill_points, s.name, s.unlocked, s.active])

func _has_unlocked_tier(t:int) -> bool:
	for sk in skills:
		if sk.tier == t and sk.unlocked:
			return true
	return false

func _update_points_label() -> void:
	lbl_points.text = "Points disponibles : %d" % Global.skill_points

func _show_error(msg:String) -> void:
	lbl_error.text = msg
	lbl_error.show()
	print("[ERROR]", msg)

	# Attend 3 s puis cache le label si le texte n’a pas été changé entre-temps
	await get_tree().create_timer(3.0).timeout
	if lbl_error.text == msg:
		lbl_error.hide()

func _save_state() -> void:
	print("save", CFG_PATH)
	var cfg := ConfigFile.new()
	cfg.set_value("global", "skill_points", skill_points)
	for s in skills:
		var sec := s.name
		cfg.set_value(sec, "unlocked", s.unlocked)
		cfg.set_value(sec, "active",   s.active)
	cfg.save(CFG_PATH)

func _load_state() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(CFG_PATH) != OK:
		print(" first run, no cfg.")
		return

	skill_points = cfg.get_value("global", "skill_points", skill_points)
	print(" cfg found – pts =", skill_points)

	for s in skills:
		var sec := s.name
		s.unlocked = cfg.get_value(sec, "unlocked", false)
		s.active   = cfg.get_value(sec, "active",   false)
		s._refresh()
		print("  %s tier%d  unlocked=%s active=%s"
			  % [s.name, s.tier, s.unlocked, s.active])

# crée une fonction qui rend la fenêtre invisible  
func close():
	$Panel.hide()
	print("skill tree closed")

# crée une fonction qui rend la fenêtre visible
func open():
	# réinitiliser la variable skill_points
	skill_points = Global.skill_points
	# réinitialiser le label
	lbl_points.text = "Points disponibles : %d" % skill_points
	
	$Panel.show()
	print("skill tree opened")

# écoute l'input pour ouvrir/fermer la fenêtre
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Skill_tree"):
		if $Panel.visible:
			close()
		else:
			open()
