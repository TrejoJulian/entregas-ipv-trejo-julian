extends "res://entities/AbstractStateMachine.gd"


func _ready():
	states_map = {
		"idle": $Idle,
		"walk": $Walk,
		"jump": $Jump,
		"dead": $Dead,
		"dash": $Dash
	}


func notify_hit(amount):
	PlayerData.current_health += min(amount, PlayerData.max_health)
	print(PlayerData.current_health)
	if PlayerData.current_health == 0:
		_change_state("dead")

func notify_heal(amount):
	var new_possible_value = PlayerData.current_health + amount
	PlayerData.current_health = min(new_possible_value, PlayerData.max_health)
	print(PlayerData.current_health)
