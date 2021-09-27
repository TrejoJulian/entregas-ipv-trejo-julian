extends Sprite

onready var fire_position = $FirePosition
onready var fire_timer = $FireTimer
onready var parent = get_parent()

export (PackedScene) var projectile_scene

var target:Node2D
var projectile_container

func _ready():
	fire_timer.connect("timeout", self, "fire_at_player")

func initialize(container, turret_pos, projectile_container):
	container.add_child(self)
	global_position = turret_pos
	self.projectile_container = projectile_container

func fire_at_player():
	var proj_instance = projectile_scene.instance()
	proj_instance.initialize(projectile_container, fire_position.global_position, fire_position.global_position.direction_to(target.global_position))

func _on_DetectionArea_body_entered(body):
	if target == null:
		target = body
		fire_timer.start()



func _on_DetectionArea_body_exited(body):
	if body == target:
		target = null
		fire_timer.stop()


func _remove():
	parent.call_deferred("remove_child",self) #This function can not be called during IO/OUT 
	queue_free()

func _on_Area2D_area_entered(area):
	if area.is_in_group("PlayerProjectile"):
		call_deferred("_remove")



