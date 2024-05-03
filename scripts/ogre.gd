extends Enemy
class_name Ogre

func _ready():
	spawn_delay = 1.5
	spawn_delay_rand_range = 0.5

	enemy_max_health = 50
	enemy_atk = 5
	enemy_def = 20
	enemy_speed = 50

	idle_animation_name = "idle"
	die_animation_name = "die"
	crumble_animation_name = "crumble"

	enemy_health = enemy_max_health

	health_bar = $HealthBar
	animated_sprite_2d = $AnimatedSprite2D
	
	var attacking = true

	await on_enemy_ready()

func _process(delta):
	if !on_enemy_process():
		return;
	var attacking = false
	velocity = Vector2.ZERO
	
	if !is_dead:
		var direction = (player.position - position).normalized()
		velocity = direction * enemy_speed
		
		if position.distance_to(player.position) < 300 and !attacking:
			attack()
		
		$Area2D/CollisionShape2D.scale = Vector2(1,1)
	
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
	var attacking = true
	animated_sprite_2d.play("attack")
	await animated_sprite_2d.animation_finished
	
	$Area2D/CollisionShape2D.scale = Vector2(3,3)
	
	attacking = false
	animated_sprite_2d.play("idle")

func _on_area_2d_area_entered(area):
	if !is_dead:
		on_enemy_area_entered(area)
		if area.owner is Player:
			player.bounce_towards((player.position - position).normalized()*10)
