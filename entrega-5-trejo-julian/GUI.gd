extends MarginContainer

onready var bar = $HBoxContainer/Bar/Gauge
onready var number_label = $HBoxContainer/Bar/Count/Background/Number
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerData.connect("health_updated",self,"_on_health_updated")
	PlayerData.connect("max_health_updated",self,"_on_max_health_updated")

func _on_health_updated(amount, max_health):
	_set_max_hp(max_health)
	_update_health(amount)

func _on_max_health_updated(max_health, amount):
	_set_max_hp(max_health)
	_update_health(amount)

func _set_max_hp(max_health):
	bar.max_value = max_health
	
func _update_health(amount):
	number_label.text = str(amount)
	bar.value = amount


