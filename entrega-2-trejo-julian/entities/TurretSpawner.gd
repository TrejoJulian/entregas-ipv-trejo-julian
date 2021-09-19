extends Node

export (PackedScene) var turret_scene:PackedScene
onready var viewport_size = get_viewport().get_visible_rect().size

func spawn_turrets(player, number_of_torrets:int):
	
	var y_axis_above_player = player.global_position.y - player.texture.get_height() #y axis is inverted that's why i use (-)
	
	for i in range(number_of_torrets):
		var turret_instance:Turret = turret_scene.instance()
		
		var turret_size = turret_instance.texture.get_height()
		
		#set the x and y range we want our turrets to spawn between
		var x_range = Vector2(turret_size, viewport_size.x - turret_size)
		var y_range = Vector2(turret_size, y_axis_above_player)
		#randomize the spawn position
		var random_x = randi() % int(x_range[1]- x_range[0]) + 1 + x_range[0] 
		var random_y =  randi() % int(y_range[1]-y_range[0]) + 1 + y_range[0]
		var random_pos = Vector2(random_x, random_y)
		
		self.add_child(turret_instance)
		turret_instance.set_initial_values(player,self,random_pos)
