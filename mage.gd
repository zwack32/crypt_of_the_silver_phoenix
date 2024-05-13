extends Enemy
class_name Mage

@export var speed = randi_range(50, 100)
var mage_spell = preload("res://scenes/mage_spell.tscn")

@onready var attack_timer = $AttackTimer

func _ready():
	spawn_delay = 1.5
	spawn_delay_rand_range = 0.5

	enemy_max_health = 30
	enemy_atk = 7
	enemy_def = 5
	enemy_speed = randi_range(50, 100)
	

	idle_animation_name = "move"
	die_animation_name = "die"
	crumble_animation_name = "crumble"

	enemy_health = enemy_max_health

	health_bar = $MageHealthBar
	animated_sprite_2d = $AnimatedSprite2D
	

	await on_enemy_ready()
	ranged_attack()

func _process(delta):
	if !on_enemy_process():
		return
	velocity = Vector2.ZERO
	var direction = Vector2.ZERO
	if !is_dead:
		#move away if distance is less than ten, and closer if distance is greater than 20
		if position.distance_to(player.position) > 600:
			direction = (player.position - position).normalized()
			velocity = direction * enemy_speed
		elif position.distance_to(player.position) < 600 and position.distance_to(player.position) > 400:
			velocity = Vector2.ZERO
		elif position.distance_to(player.position) < 400:
			direction = (player.position - position).normalized()
			direction *= -1
			velocity = direction * enemy_speed
	if (position.x > player.position.x):
		$AnimatedSprite2D.flip_h = true
	else: 
		$AnimatedSprite2D.flip_h = false

	
	health_bar.value = enemy_health

func ranged_attack():
	#await get_tree().create_timer(randf_range(4.0, 8.0) * 2.0).timeout
	#if !attack_timer.time_left == 0:
	#	pass
	while !is_dead:
		await get_tree().create_timer(randf_range(2.0, 8.0)).timeout
		if !is_dead:
			var spell = mage_spell.instantiate()
			attack_timer.wait_time = spell.cooldown
			spell.mage = self
			spell.player = player
			get_parent().add_child(spell)

func _on_area_2d_area_entered(area):
	if !is_dead:
		on_enemy_area_entered(area)
		if area.owner is Player:
			player.bounce_towards((player.position - position).normalized())
