extends Enemy
class_name Slime

@onready var squish = $Squish

func _ready():
	spawn_delay = 1.5
	spawn_delay_rand_range = 0.5

	enemy_max_health = 30
	enemy_atk = 7
	enemy_def = 5
	enemy_speed = 100

	idle_animation_name = "idle"
	die_animation_name = "die"
	crumble_animation_name = "crumble"

	enemy_health = enemy_max_health

	health_bar = $HealthBar
	animated_sprite_2d = $AnimatedSprite2D
	
	squish.play()

	await on_enemy_ready()

func _process(delta):
	if is_dead:
		squish.stop()
	
	if !on_enemy_process():
		return;

	velocity = Vector2.ZERO
	
	if !is_dead:
		var direction = (player.position - position).normalized()
		velocity = direction * enemy_speed
	
	health_bar.value = enemy_health
	
	if (position.x > player.position.x):
		$AnimatedSprite2D.flip_h = true
	else: 
		$AnimatedSprite2D.flip_h = false

func _on_area_entered(area):
	if !is_dead:
		on_enemy_area_entered(area)
		# For example
		if area.owner is Player:
			pass
