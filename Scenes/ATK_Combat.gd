extends Node2D



var ArrowAttack = 6


func button_Attaque():
	queue_free()
	#await get_tree().create_timer(1).timeout
	take_damage(ArrowAttack)
	print("Attaque!")
	
	
	
var texts = {
	0: {
		"text": "Vous avez inflige "+str(ArrowAttack)+" degats au mechant !",
		"has_choices": false,
		"text_choices": ["Oui", "Non"],
		"has_suite": true,
		"choices_jump_to": [0, 0]
	},
	1: {
		"text": "C'est à ... d'attaquer maintenant ",
		"has_choices": false,
		"text_choices": ["Oui", "Non"],
		"has_suite": false,
		"choices_jump_to": [0, 0]
	},
}
	
func take_damage(damage):
	texts[1]["text"] = "C'est à "+get_node("/root/SceneCombat/ContainerMob/Pseudo").text+" d'attaquer maintenant "
	get_node("/root/SceneCombat").spawn_dialogue(texts)
	get_node("/root/SceneCombat").pv_enemy -= ArrowAttack
	
	


