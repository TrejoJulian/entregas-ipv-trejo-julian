extends "res://entities/AbstractState.gd"

# Initialize the state. E.g. change the animation
func enter():
	print("You died")
	parent.velocity = Vector2.ZERO
	parent._remove()



func update(delta:float):
	parent._apply_movement()

