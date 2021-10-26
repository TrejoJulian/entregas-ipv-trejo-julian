extends Area2D

export var healing = 5

#No la desapareci para que sea mas facil probar si funciona bien o no
func _on_Area2D_body_entered(body):
	if body is Player:
		body.notify_heal(healing)
