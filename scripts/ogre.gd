extends Enemy
class_name Ogre

const ATTACK_DISTANCE_X = 268
const ATTACK_DISTANCE_Y = 250
	
var attacking = false
@onready var heavy_breathing = $HeavyBreathing
@onready var thwack = $Thwack

func _ready():
	spawn_delay = 1.5
	spawn_delay_rand_range = 0.5

	enemy_max_health = 50
	# This is the "base attack" used only when you boop the ogre
	enemy_atk = 1
	enemy_def = 20
	enemy_speed = 50

	idle_animation_name = "idle"
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
		var direction = (player.position - position).normalized()
		velocity = direction * enemy_speed
		
		if can_attack_player() && !attacking:
			attack()
	
	health_bar.value = enemy_health
	
	if (position.x > player.position.x):
		$AnimatedSprite2D.flip_h = true
		$Area2D/CollisionShape2D.position = Vector2(15,0)
		$CollisionShape2D.position = Vector2(0,8)
	else: 
		$AnimatedSprite2D.flip_h = false
		$Area2D/CollisionShape2D.position = Vector2(0,0)
		$CollisionShape2D.position = Vector2(-20,8)

func attack():
	attacking = true
	animated_sprite_2d.play("attack")
	for _i in range(4):
		await animated_sprite_2d.frame_changed
	if !is_dead:
		if can_attack_player():
			player.take_damage(enemy_atk + 13)
			player.bounce_towards((player.position - position).normalized() * 18.0)
		else:
			player.apply_shake()
		attacking = false
	
	await animated_sprite_2d.animation_finished
	if !is_dead:
		animated_sprite_2d.play("idle")

func can_attack_player() -> bool:
	var to_player = player.position - position
	to_player.x = abs(to_player.x)
	to_player.y = abs(to_player.y)
	return to_player.x < ATTACK_DISTANCE_X && to_player.y < ATTACK_DISTANCE_Y && to_player.length() < 300

func _on_area_2d_area_entered(area):
	if !is_dead:
		on_enemy_area_entered(area)
