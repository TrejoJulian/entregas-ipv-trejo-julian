extends KinematicBody2D
class_name Turret

onready var fire_position = $FirePosition
onready var fire_timer = $FireTimer
onready var raycast = $FirePosition/RayCast2D
onready var idle_timer:Timer = $IdleTimer
onready var detection_area:Area2D = $DetectionArea

export (PackedScene) var projectile_scene
export (Vector2) var wandering_range:Vector2
export (float) var speed:float = 10
export (float) var max_speed:float = 50

var target
var projectile_container
var path:Array = []
var desired_paths = 5
var pathfinding: PathfindAstar
var velocity:Vector2 = Vector2.ZERO
var gravity:int = 30

func _ready():
	fire_timer.connect("timeout", self, "fire")
	idle_timer.start()

func initialize(container, turret_pos, projectile_container):
	container.add_child(self)
	global_position = turret_pos
	self.projectile_container = projectile_container

func fire():
	if target != null:
		var proj_instance = projectile_scene.instance()
		if projectile_container == null:
			projectile_container = get_parent()
		proj_instance.initialize(projectile_container, fire_position.global_position, fire_position.global_position.direction_to(target.global_position))
		fire_timer.start()

func _physics_process(delta):
	_handle_fire_if_target_is_in_sight()
	
	if !path.empty():
		_patrol()


func _handle_fire_if_target_is_in_sight():
	if target != null:
		raycast.set_cast_to(to_local(target.global_position))
		if raycast.is_colliding() && raycast.get_collider() == target:
			if fire_timer.is_stopped():
				fire_timer.start()
		elif !fire_timer.is_stopped():
			fire_timer.stop()

func _patrol():
	var next_point:Vector2 = path.front()
	while (path.size() > 1) && global_position.distance_to(next_point) < 3: #si aca el size es 1, al sacar uno y pedir el primero se rompe
		path.pop_front()
		next_point = path.front()
		
	if global_position.distance_to(next_point) > 3:
		velocity.x = clamp(velocity.x + (next_point - global_position).normalized().x * speed, -max_speed, max_speed)
	else:
		path.pop_front()
		
	velocity.y += gravity
	velocity = move_and_slide(velocity,Vector2.UP)



func notify_hit(_amount):
	call_deferred("_remove")


func _remove():
	hide()
	detection_area.monitorable = false
	detection_area.monitoring = false
	collision_layer = 0
	collision_mask = 0


func _on_DetectionArea_body_entered(body):
	if target == null:
		target=body


func _on_DetectionArea_body_exited(body):
	if body == target:
		target = null



func _on_IdleTimer_timeout():
	if path.size() < desired_paths: #Como esto ejecuta muchas veces, no quiero que mi path tenga miles de elementos innecesariamente, entonces le pongo un cap.
		var point: Vector2 = Vector2(rand_range(-wandering_range.x,wandering_range.x), rand_range(-wandering_range.y,wandering_range.y))
		path.append_array(pathfinding.get_simple_path(global_position, global_position + point))
