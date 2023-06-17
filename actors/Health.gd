extends Node2D

@export var health: int = 100 :
	set (new_health):
		health = clamp(new_health, 0, 100)
