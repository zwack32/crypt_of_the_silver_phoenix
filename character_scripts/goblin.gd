extends Enemy
class_name Goblin

var should_run_away = false

func _ready():
	spawn_delay = 1.5
	spawn_delay_rand_range = 0.5

	enemy_max_health = 30
	enemy_atk = 10
	enemy_def = 0
	enemy_speed = 200

	idle_animation_name = "move"
	die_animation_name = "die"
	crumble_animation_name = "crumble"

	enemy_health = enemy_max_health

	health_bar = $HealthBar
	animated_sprite_2d = $AnimatedSprite2D

	await on_enemy_ready()

func _process(delta):
	if !on_enemy_process():
		return;

	velocity = Vector2.ZERO
	
	if !is_dead:
		var direction
		if should_run_away:
			direction = (position - player.position).normalized()
		else:
			direction = (player.position - position).normalized()
		velocity = direction * enemy_speed
	
	health_bar.value = enemy_health
	
	if (position.x > player.position.x):
		$AnimatedSprite2D.flip_h = true
	else: 
		$AnimatedSprite2D.flip_h = false
		
	if should_run_away:
		$AnimatedSprite2D.flip_h = !$AnimatedSprite2D.flip_h

func run_away():
	should_run_away = true
	await get_tree().create_timer(randf_range(1.5, 4)).timeout
	should_run_away = false

func _on_area_2d_area_entered(area):
	if !is_dead:
		on_enemy_area_entered(area)
		if area.owner is Player:
			run_away()
			$AnimatedSprite2D.play("attack")
