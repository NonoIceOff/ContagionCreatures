extends CPUParticles2D

var compteur = 0

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	compteur += 0.1
	gravity.y = cos(compteur) * 128
