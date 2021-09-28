extends Node2D

export (PackedScene) var turret_scene

func _ready():
	call_deferred("initialize")

func initialize():
	var spawn_area_extents = $Area2D/CollisionShape2D.get_shape().extents
	var x_axis_spawn_area:Vector2 = Vector2(global_position.x - spawn_area_extents.x, global_position.x + spawn_area_extents.x)
	var y_axis_spawn_area:Vector2 = Vector2(global_position.y - spawn_area_extents.y, global_position.y + spawn_area_extents.y)
	for i in 3:
		var turret_instance = turret_scene.instance()
		
		var turret_pos:Vector2 = Vector2(rand_range(x_axis_spawn_area.x, x_axis_spawn_area.y), rand_range(y_axis_spawn_area.x, y_axis_spawn_area.x))

		turret_instance.initialize(self, turret_pos, self)
