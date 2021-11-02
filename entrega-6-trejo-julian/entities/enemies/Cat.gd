extends KinematicBody2D
class_name Turret

onready var fire_position = $FirePosition
onready var raycast = $FirePosition/RayCast2D
onready var detection_area = $DetectionArea
onready var remove_anim_player = $RemoveAnimPlayer

onready var body_sprite:AnimatedSprite = $Body

onready var state_machine = $StateMachine

onready var cat_sfx = $CatSfx
export (PackedScene) var projectile_scene
export (AudioStream) var fire_sfx 

var target
var projectile_container

var pathfinding:PathfindAstar

var velocity:Vector2 = Vector2.ZERO

func _ready():
	state_machine.set_parent(self)


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
		_fire_audio()

func _can_see_target()->bool:
	if target == null:
		return false
	raycast.set_cast_to(to_local(target.global_position))
	raycast.force_raycast_update()
	return raycast.is_colliding() && raycast.get_collider() == target


func apply_movement():
	velocity.y += 20
	velocity = move_and_slide(velocity)


func _play_animation(animation_name:String):
	if body_sprite.frames.has_animation(animation_name):
		body_sprite.play(animation_name)

func _fire_audio():
	cat_sfx.stream = fire_sfx
	cat_sfx.play()


func notify_hit(amount):
	state_machine.notify_hit(amount)


func _remove():
	hide()
	collision_layer = 0
	collision_mask = 0


func _on_DetectionArea_body_entered(body):
	state_machine.notify_body_entered(body)


func _on_DetectionArea_body_exited(body):
	state_machine.notify_body_exited(body)


func _on_Body_animation_finished():
	state_machine._on_animation_finished(body_sprite.animation)
