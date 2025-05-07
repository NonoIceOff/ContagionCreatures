extends Node2D
const CFG_PATH := "res://Scripts/SkillTree/skills.cfg"

@export var skill_points : int = 3
var skills : Array[Skill] = []

@onready var lbl_points : Label = $PointsAvailable   # affiche les points restants
@onready var lbl_error  : Label = $ErrorMessage      # message d’erreur (caché par défaut)

# ------------------------------------------------------------------ #
func _ready() -> void:
	lbl_error.hide()                 # on démarre avec le message invisible
	_collect_skills()
	_load_state()
	_update_points_label()
	print("[Tree::_ready] start – pts =", skill_points)

# ----------- COLLECTE RÉCURSIVE DES SKILLS ------------------------ #
func _collect_skills() -> void:
	print("[Tree::_collect_skills] look for skills …")
	skills.clear()
	_walk(self)
	print(" » total :", skills.size())

func _walk(node) -> void:
	for ch in node.get_children():
		if ch is Skill:
			print("  found :", ch.get_path(), "tier", ch.tier)
			skills.append(ch)
		_walk(ch)

# -------------------- CLIC SUR UN SKILL --------------------------- #
func _skill_pressed(s: Skill) -> void:
	print("---[press]---------------------------------------------------------")
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
		skill_points -= s.cost
		s.unlocked = true
		print("  → %s déverrouillé, pts restants = %d" % [s.name, skill_points])
	else:
		# Toggle actif / inactif
		s.active = !s.active
		print("  → %s devient %s" % [s.name, "ACTIF" if s.active else "INACTIF"])

	s._refresh()
	_update_points_label()
	_save_state()

	print("After   pts=%d  %s  unlocked=%s active=%s"
		  % [skill_points, s.name, s.unlocked, s.active])
	print("------------------------------------------------------------------")

func _has_unlocked_tier(t:int) -> bool:
	for sk in skills:
		if sk.tier == t and sk.unlocked:
			return true
	return false

# --------------- LABEL DES POINTS DISPONIBLES --------------------- #
func _update_points_label() -> void:
	lbl_points.text = "Points disponibles : %d" % skill_points

# -------------------- GESTION DES ERREURS ------------------------- #
func _show_error(msg:String) -> void:
	lbl_error.text = msg
	lbl_error.show()
	print("[ERROR]", msg)

	# Attend 3 s puis cache le label si le texte n’a pas été changé entre-temps
	await get_tree().create_timer(3.0).timeout
	if lbl_error.text == msg:
		lbl_error.hide()

# ----------------------- SAUVEGARDE ------------------------------- #
func _save_state() -> void:
	print("[save] →", CFG_PATH)
	var cfg := ConfigFile.new()
	cfg.set_value("global", "skill_points", skill_points)
	for s in skills:
		var sec := s.name
		cfg.set_value(sec, "unlocked", s.unlocked)
		cfg.set_value(sec, "active",   s.active)
	cfg.save(CFG_PATH)

# ------------------------ CHARGEMENT ------------------------------ #
func _load_state() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(CFG_PATH) != OK:
		print("[load] first run, no cfg.")
		return

	skill_points = cfg.get_value("global", "skill_points", skill_points)
	print("[load] cfg found – pts =", skill_points)

	for s in skills:
		var sec := s.name
		s.unlocked = cfg.get_value(sec, "unlocked", false)
		s.active   = cfg.get_value(sec, "active",   false)
		s._refresh()
		print("  %s tier%d  unlocked=%s active=%s"
			  % [s.name, s.tier, s.unlocked, s.active])
