extends CharacterBody2D
class_name Enemy

@onready var health_stat = $Health
	
func handle_hit():
	health_stat.health -= 20
	if health_stat.health <= 0:
		queue_free()
