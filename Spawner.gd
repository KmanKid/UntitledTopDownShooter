extends Node2D
class_name Spawner

func spawn_player(player: Player):
	var random_location = Vector2(randi_range(0,100),randi_range(0,100))
	player.position = random_location
	
func respawn_player(player: Player):
	var random_location = Vector2(randi_range(0,100),randi_range(0,100))
	player.position = random_location
	player.health_stat.health = 100
