extends CharacterBody2D

signal  player_fired_bullet(bullet,position,direction)

@export var Bullet = PackedScene.new()
@export var default_speed: int = 100.0
@onready var _animated_sprite = $AnimatedSprite2D
@onready var end_of_gun = $EndOfGun
@onready var gun_direction = $GunDirection
@onready var shoot_cooldown = $ShootCooldown
@onready var animation_player = $AnimationPlayer

var can_shoot = true
var health = 100

func _physics_process(delta):
	var speed = default_speed
	var movement_direction = Vector2.ZERO
	var animation = "idle"
	if Input.is_action_pressed("walk_up"):
		movement_direction.y = -1
		animation = "walk"
	if Input.is_action_pressed("walk_down"):
		movement_direction.y = 1
		animation = "walk"
	if Input.is_action_pressed("walk_left"):
		movement_direction.x = -1
		animation = "walk"
	if Input.is_action_pressed("walk_right"):
		movement_direction.x = 1
		animation = "walk"
	if Input.is_action_pressed("aim"):
		speed = 0
		animation = "gun_drawn"
	velocity = movement_direction.normalized() * speed
	move_and_slide()
	speed = default_speed
	_animated_sprite.play(animation)
	
	look_at(get_global_mouse_position())

func _unhandled_input(event):
	if (event.is_action_released("shoot") && Input.is_action_pressed("aim") && can_shoot):
		shoot_cooldown.start()
		shoot()
		can_shoot = false

func shoot():
	var bullet_instance = Bullet.instantiate()
	var target = get_global_mouse_position()
	var direction = gun_direction.global_position - end_of_gun.global_position
	emit_signal("player_fired_bullet", bullet_instance, end_of_gun.global_position, direction)
	animation_player.play("MuzzleFlash")


func _on_shoot_cooldown_timeout():
	can_shoot = true
	
func handle_hit():
	health -= 20
	print("Cop Health: ", health)
