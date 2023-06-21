extends Node2D
class_name Spawner

func spawn_player(player: Player):
	var random_location = Vector2(randi_range(40,3310),randi_range(25,1740))
	player.global_position = random_location
	print(random_location)
	
func respawn_player(player: Player):
	var random_location = Vector2(randi_range(40,3310),randi_range(25,1740))
	player.position = random_location
	player.health_stat.health = 100
