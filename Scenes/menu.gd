extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.load_patreon()
	
	
func _process(delta):
	if Global.patreon_active == true:
		var time_next_month = Time.get_unix_time_from_system()
		time_next_month = Time.get_datetime_string_from_unix_time(time_next_month)
		time_next_month = Time.get_datetime_dict_from_datetime_string(time_next_month, false)
		time_next_month.day = 1
		time_next_month.hour = 0
		time_next_month.minute = 0
		time_next_month.second = 0
		if time_next_month.month >= 12:
			time_next_month.month = 1
			time_next_month.year += 1
		else:
			time_next_month.month += 1
		time_next_month = Time.get_unix_time_from_datetime_dict(time_next_month)
		
		var time_remaining = int(time_next_month-Time.get_unix_time_from_system())
		var time_remaining_sec = int(time_next_month-Time.get_unix_time_from_system())%60
		var time_remaining_min = int(time_next_month-Time.get_unix_time_from_system())/60%60
		var time_remaining_hour = int(time_next_month-Time.get_unix_time_from_system())/60/60%24
		var time_remaining_day = int(time_next_month-Time.get_unix_time_from_system())/60/60/24
		var str_next_code = str(time_remaining_day)+"j "+str(time_remaining_hour)+"h "+str(time_remaining_min)+"m "+str(time_remaining_sec)+"s"
		if time_remaining > 0:
			get_node("Patreon/PatreonCode").text = "Vous avez deja debloque\nProchain code dans : "+str_next_code
		else:
			get_node("Patreon/PatreonCode").text = "debloquer des fonctionnalites"
			get_node("Patreon").disabled = false
			Global.patreon_active = false
			Global.patreon_time = 0.0
			Global.save_patreon()
			
	if Global.patreon_active == true:
		get_node("PlayMulti/Icon").visible = false
		get_node("PlayMulti/Label").visible = false
		get_node("PlayMulti").disabled = false
