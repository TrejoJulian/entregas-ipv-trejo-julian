extends Sprite
class_name Turret

onready var fire_position:Position2D = $FirePosition

export (PackedScene) var projectile_scene

var projectile_container:Node
var player


func set_initial_values(player,projectile_container,starting_position):
	self.player = player
	self.projectile_container = projectile_container
	position = starting_position
	$Timer.start()


func _on_Timer_timeout():
	fire()

func fire():
	var projectile:Projectile = projectile_scene.instance()
	projectile_container.add_child(projectile)
	projectile.set_starting_values(fire_position.global_position, (player.global_position - fire_position.global_position).normalized())
	projectile.connect("delete_requested",self,"_on_projectile_delete_requested")

func _on_projectile_delete_requested(projectile):
	projectile_container.remove_child(projectile)
	projectile.queue_free()
