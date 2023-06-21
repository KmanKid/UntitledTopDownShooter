extends CharacterBody2D
class_name Player

signal player_fired_bullet(bullet,position,direction)
signal remote_bullet_fired(position,direction)
signal dead(player: Player)
signal spawn(player: Player)

@export var Bullet = PackedScene.new()
@export var default_speed: int = 100.0

@onready var weapon: Weapon = $Weapon
@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_stat = $Health

var animation_speed = 1

func _ready():
	weapon.fired.connect(shoot)
	name = str(get_multiplayer_authority())

func _physics_process(delta):
	if is_multiplayer_authority():
		var movement_direction = Vector2.ZERO
		var animation = "idle"
		var speed = default_speed

		if Input.is_action_pressed("sprint"):
			animation_speed = 1.5
			speed = speed * 1.5
		else:
			animation_speed = 1
			speed = default_speed

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

		if animation == "gun_drawn":
			weapon.set_visibility(true)
		else:
			weapon.set_visibility(false)

		velocity = movement_direction.normalized() * speed
		move_and_slide()
		speed = default_speed
		_animated_sprite.play(animation,animation_speed)
		look_at(get_global_mouse_position())

		rpc("remote_set_position", global_position)
		rpc("remote_set_rotation", global_rotation)
		rpc("remote_animate",animation, animation_speed)


@rpc("unreliable")
func remote_set_position(authority_position):
	global_position = authority_position

@rpc("unreliable")
func remote_set_rotation(authority_rotation):
	global_rotation = authority_rotation

@rpc
func remote_animate(authority_animation, authority_animation_speed):
	animation_speed = authority_animation_speed
	_animated_sprite.play("enemy_"+authority_animation,authority_animation_speed)
	if authority_animation == "gun_drawn":
		weapon.set_visibility(true)
	else:
		weapon.set_visibility(false)


func _unhandled_input(event):
	if (event.is_action_pressed("shoot") && Input.is_action_pressed("aim") && is_multiplayer_authority()):
		weapon.shoot()
		rpc("shoot_remote")

@rpc
func shoot_remote():
	weapon.shoot()

func shoot(bullet_instance, location: Vector2, direction: Vector2):
	emit_signal("player_fired_bullet", bullet_instance, location, direction)

func handle_hit():
	health_stat.health -= 20
	if health_stat.health <= 0:
		emit_signal("dead",self)
	print("Player Health: ", health_stat.health)
