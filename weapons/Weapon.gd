extends Node2D
class_name Weapon

signal fired(bullet, location, direction)

@export var Bullet = PackedScene.new()

@onready var end_of_gun: Marker2D = $EndOfGun
@onready var gun_direction: Marker2D = $GunDirection
@onready var attack_cooldown: Timer = $AttackCooldown
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var gun_sfx: AudioStreamPlayer2D = $GunSound

func shoot():
	if attack_cooldown.is_stopped() and Bullet != null:
		var bullet_instance = Bullet.instantiate()
		var direction = (gun_direction.global_position - end_of_gun.global_position).normalized()
		emit_signal("fired",bullet_instance,end_of_gun.global_position,direction)
		attack_cooldown.start()
		animation_player.play("MuzzleFlash")
		gun_sfx.play()
		
func set_visibility(isVisible: bool):
	if(isVisible):
		sprite.visible = true
	else:
		sprite.visible = false
	
