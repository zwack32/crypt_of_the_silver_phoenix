extends Enemy
class_name Bat

@export var speed = 700.0

var charge_to_position = Vector2.ZERO
var is_attacking = false

var last_position: Vector2

signal attack_finished

@export var charge_overshoot: float = 500.0

func _ready():
	spawn_delay = 1.5
	spawn_delay_rand_range = 3.0

	enemy_max_health = 20
	enemy_atk = 5
	enemy_def = 3
	
	health_bar = $HealthBar

	idle_animation_name = "idle"
	die_animation_name = "die"
	crumble_animation_name = "crumble"
	
	enemy_health = enemy_max_health
	enemy_die_callback = on_die

	health_bar = $HealthBar
	animated_sprite_2d = $AnimatedSprite2D
	
	await on_enemy_ready()
	prepare_attack(true)

func _process(delta):
	if (is_on_ceiling() || is_on_floor() || is_on_wall()) && is_attacking && (position - last_position).normalized() != charge_to_position.normalized():
		attack_finished.emit()
	
	last_position = position
	
	if !on_enemy_process():
		return;
	
	if !is_attacking:
		velocity = Vector2.ZERO
	
	#if death_timer.time_left <= 0 and dead:
	#	animated_sprite_2d.play("Bat_die")
	#	collision_layer = 0
	#	collision_mask = 0
		# STUB: Remove this gross hardcoded time
	#	await get_tree().create_timer(3).timeout
	#	queue_free()
	
	if position.distance_to(charge_to_position) < 4.0:
		attack_finished.emit()
	
func prepare_attack(is_inital=false):
	while !is_dead:
		await get_tree().create_timer(randf_range(4.0, 8.0) * 2.0).timeout
		var direction = (player.position - position).normalized()
		charge_to_position = player.position + direction * charge_overshoot
		velocity = direction * speed
		is_attacking = true
		await attack_finished
		is_attacking = false

		# Workaround to prevent sticking to wall
		position -= direction

func on_die():
	collision_layer |= 2

func _on_area_entered(area):
	if !is_dead:
		on_enemy_area_entered(area)
		if area is MeleeWeapon:
			velocity /= 8
			attack_finished.emit()
