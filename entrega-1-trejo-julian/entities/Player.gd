extends Sprite

export (float) var speed:float = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	var direction =  int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	position.x += direction * speed * delta
