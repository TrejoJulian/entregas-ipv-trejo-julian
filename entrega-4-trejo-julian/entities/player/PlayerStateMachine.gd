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
	if PlayerData.health_bar_is_depleted():
		_change_state("dead")
		return
	print(PlayerData.current_health)
