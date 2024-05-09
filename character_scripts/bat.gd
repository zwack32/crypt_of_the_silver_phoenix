extends Enemy
class_name Bat

var is_attacking = false
var charge_velocity: Vector2

signal attack_finished

func _ready():
	spawn_delay = 1.5
	spawn_delay_rand_range = 3.0

	enemy_max_health = 20
	enemy_atk = 5
	enemy_def = 3
	enemy_speed = 700
	
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
	queue_redraw()
	
	if (is_on_ceiling() || is_on_floor() || is_on_wall()) && is_attacking:
		var normal
		if is_on_floor():
			normal = get_floor_normal()
		elif is_on_wall():
			normal = get_wall_normal()
		else:
			normal = Vector2.DOWN
		charge_velocity = charge_velocity.bounce(normal)
		velocity = charge_velocity
		
		# Nudge out of wall
		position += normal * 5.0
		move_and_slide()
		
		# attack_finished.emit()
	
	if !on_enemy_process():
		return;
	
	if !is_attacking:
		velocity = Vector2.ZERO
	else:
		velocity = charge_velocity
	
func prepare_attack(is_inital=false):
	while !is_dead:
		await get_tree().create_timer(randf_range(3.0, 8.0)).timeout
		var direction = (player.position - position).normalized()
		velocity = direction * enemy_speed
		charge_velocity = velocity
		is_attacking = true
		await_end_attack()
		await attack_finished
		is_attacking = false

		# Workaround to prevent sticking to wall
		position -= direction

func await_end_attack():
	await get_tree().create_timer(randf_range(3.0, 6.0)).timeout
	attack_finished.emit()

func on_die():
	collision_layer |= 2

func _on_area_entered(area):
	if !is_dead:
		on_enemy_area_entered(area)
		if area is MeleeWeapon:
			charge_velocity /= 2
			# attack_finished.emit()
