extends Node

onready var player = $Environment/Player

func _ready():
	randomize()
	player.initialize(self)
	GameState.connect("level_won",self,"_on_level_won")

func _unhandled_input(event):
	if event.is_action("restart"):
		_restart_level()

func _restart_level():
	get_tree().reload_current_scene()

func _on_level_won():
	$Tween.interpolate_property($WinLayer,"layer",-2,2,0)
	$Tween.start()
	var t = Timer.new()
	t.set_wait_time(3)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	_restart_level()
