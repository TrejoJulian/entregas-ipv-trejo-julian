extends "res://entities/AbstractState.gd"

onready var duration_timer = $DurationTimer

func enter():
	duration_timer.start(parent.dash_duration)
	parent._handle_move_input()
	if parent.move_direction >=0:
		parent.velocity.x = parent.dash_speed
	else:
		parent.velocity.x = -parent.dash_speed


func update(delta:float):
	parent._handle_cannon_actions()
	parent._apply_movement()
	if parent.move_direction == 0:
		parent._handle_deacceleration()


func _on_DurationTimer_timeout():
	if !PlayerData.health_bar_is_depleted(): # esto lo hago porque sino se genera un bug que si me muero dasheando vuelve a idle/walk igual
		if parent.move_direction != 0:
			emit_signal("finished","walk")
		else:
			emit_signal("finished","idle")
