extends Sprite2D


func take_damage(damage):
		get_node("/root/SceneCombat/AnimationPlayer").play("enemy_damaged") 
