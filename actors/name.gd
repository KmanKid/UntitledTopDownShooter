extends Label
		
func _process(delta):
	var parent_rotation = get_parent().rotation
	var parent_position = get_parent().position
	set_rotation(- parent_rotation)
	set_global_position(Vector2(parent_position.x + 515,parent_position.y+200))
