extends Sprite

onready var lifetime_timer = $LifetimeTimer
onready var parent = get_parent()
export (float) var VELOCITY:float = 800.0

var direction:Vector2

func initialize(container, spawn_position:Vector2, direction:Vector2):
	container.add_child(self)
	self.direction = direction
	global_position = spawn_position
	lifetime_timer.connect("timeout", self, "_on_lifetime_timer_timeout")
	lifetime_timer.start()

func _physics_process(delta):
	position += direction * VELOCITY * delta
	
	# Necesitamos que desaparezca en algun momento
	
	# Si está fuera de la pantalla
	#var visible_rect:Rect2 = get_viewport().get_visible_rect()
	#if !visible_rect.has_point(global_position):
		#_remove()

# Si supero una cantidad de tiempo de vida
func _on_lifetime_timer_timeout():
	_remove()

func _remove():
	parent.call_deferred("remove_child",self) #This function can not be called during IO/OUT 
	queue_free()
	


func _on_Area2D_body_entered(body):
	lifetime_timer.stop()
	_remove()
