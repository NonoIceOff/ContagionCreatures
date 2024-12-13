extends CanvasLayer

func _ready():
	pass
	#if get_node_or_null("/root/main_map/ui") != null:
		#get_node("Minimap").map = 1
		#get_node("Minimap").change_map()
	#elif get_node_or_null("/root/map2/ui") != null:
		#get_node("Minimap").map = 2
		#get_node("Minimap").change_map()
	#elif get_node_or_null("/root/HomeOfHector/ui") != null:
		#get_node("Minimap").map = 3
		#get_node("Minimap").change_map()
		
func _process(delta):
	if Global.current_quest_id > -1 and get_node_or_null("CPUParticles2D") != null:
		get_node("CPUParticles2D").visible = true
		get_node("CPUParticles2D/QuestTextBar").text = "[right][rainbow freq=0.05]"+tr(Global.quests[Global.current_quest_id]["title"])+" [/rainbow]\n[color=white][i]"+tr(Global.quests[Global.current_quest_id]["mini_descriptions"][ Global.quests[Global.current_quest_id]["stade"]])
	
