extends CharacterBody2D
class_name Player

var movement_speed = 350
@onready var camera = $Camera2D

#adjustable stats
var player_max_health = 50
var player_atk = 10
var player_def = 10
var player_spd = 10

var bounce_acceleration = -100.0
var bounce_initial_speed = 900.0

var health = Progression.get_player_health() if Progression.get_player_health() != null else player_max_health 
var direction = Vector2.UP
var bounce_velocity = Vector2.UP
var can_swing = true
var is_dead = false

@onready var game_over = preload("res://scenes/game_over.tscn")

@onready var health_bar = $HealthBar
@onready var spell_bar = $SpellBar
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var camera_2d = $Camera2D

@onready var footsteps = $Footsteps
@onready var spell_cooldown_timer = $SpellCooldownTimer
@onready var sword_swing = $SwordSwing
@onready var fire_swing = $FireSwing
@onready var ice_swing = $IceSwing

@onready var heal_particles = $HealParticles

#annoying functions so that we can use these in other scripts
func get_player_atk():
	return player_atk
func get_player_def():
	return player_def
func get_player_spd():
	return player_spd
func get_player_max_hp():
	return player_max_health

func _ready():
	health_bar.value = health
	health_bar.max_value = player_max_health
	spell_bar.max_value = spell_cooldown_timer.wait_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move()
	
	if Input.is_action_pressed("map_view"):
		camera_2d.zoom = Vector2(0.1, 0.1)
	else:
		camera_2d.zoom = Vector2(0.5, 0.5)
	
	if Input.is_action_just_pressed("melee"):
		melee_attack()
	
	if Input.is_action_just_pressed("ranged"):
		ranged_attack()
	
	spell_bar.value = spell_cooldown_timer.time_left

func get_mouse_direction_from_player():
	var target = get_global_mouse_position()
	return global_position.direction_to(target)

func melee_attack():
	if !can_swing:
		return

	var weapon = WeaponManager.get_melee_scene().instantiate()

	if WeaponManager.get_current_melee() == 3:
		fire_swing.play()
	elif WeaponManager.get_current_melee() == 4:
		ice_swing.play()
	else:
		sword_swing.play()
	
	weapon.player = self
	add_child(weapon)
	# animated_sprite_2d.play("attack1")
	can_swing = false

	var right_down_vec = Vector2(1, 1).normalized()
	var right_up_vec = Vector2(1, -1).normalized()
	var mouse_dir = get_mouse_direction_from_player().normalized()
	
	var theta_a = acos(right_down_vec.dot(mouse_dir) / (right_down_vec.length() * mouse_dir.length()))
	var theta_b = acos(right_up_vec.dot(mouse_dir) / (right_up_vec.length() * mouse_dir.length()))
	
	var swing_direction
	var swing_rot = 0
	if theta_a < PI / 2:
		if theta_b < PI / 2:
			# Right 
			swing_direction = Vector2.RIGHT
			swing_rot = -45 - 270
		else:
			# Down
			swing_direction = Vector2.DOWN
			swing_rot = -45 - 180
	else:
		if theta_b < PI / 2:
			# Up
			swing_direction = Vector2.UP
			swing_rot = -45
		else:
			# Left
			swing_direction = Vector2.LEFT
			swing_rot = -45 - 90

	weapon.rotation_degrees = swing_rot
	weapon.start_rot = swing_rot
	weapon.swing_speed = weapon.spd
	weapon.player = self
	weapon.rot = swing_rot

func ranged_attack():
	if !spell_cooldown_timer.time_left == 0:
		pass
	else:
		var spell = WeaponManager.get_tome_scene().instantiate()
		spell_cooldown_timer.wait_time = spell.cooldown
		spell_bar.max_value = spell_cooldown_timer.wait_time
		spell.player = self
		get_parent().add_child(spell)
		spell_cooldown_timer.start()

func move():
	var player_velocity = Vector2.ZERO
	
	#change velocity by player's input
	if Input.is_action_pressed("move_down"):
		direction = Vector2.DOWN
		player_velocity.y += 1
	if Input.is_action_pressed("move_up"):
		direction = Vector2.UP
		player_velocity.y += -1
	if Input.is_action_pressed("move_left"):
		direction = Vector2.LEFT
		player_velocity.x += -1
	if Input.is_action_pressed("move_right"):
		direction = Vector2.RIGHT
		player_velocity.x += 1
		
	if Input.is_action_pressed("move_left"):
		animated_sprite_2d.play("walk_left")
	elif Input.is_action_pressed("move_right"):
		animated_sprite_2d.play("walk_right")
	elif Input.is_action_pressed("move_down"):
		if !Input.is_action_pressed("move_left") or !Input.is_action_pressed("move_right"):
			animated_sprite_2d.play("walk_down")
	elif Input.is_action_pressed("move_up"):
		direction = Vector2.UP
		player_velocity.y += -1
		if !Input.is_action_pressed("move_left") or !Input.is_action_pressed("move_right"):
			animated_sprite_2d.play("walk_up")
		
	if Input.is_action_just_released("move_down"):
		animated_sprite_2d.stop()
		# animated_sprite_2d.play("idle_transition")
		# await get_tree().create_timer(1).timeout
		animated_sprite_2d.play("idle")
	elif Input.is_action_just_released("move_up"):
		animated_sprite_2d.stop()
		# animated_sprite_2d.play("idle_transition")
		# await get_tree().create_timer(1).timeeout
		animated_sprite_2d.play("idle")
	elif Input.is_action_just_released("move_left"):
		animated_sprite_2d.stop()
		# animated_sprite_2d.play("idle_transition")
		# await get_tree().create_timer(1).timeout
		animated_sprite_2d.play("idle")
	elif Input.is_action_just_released("move_right"):
		animated_sprite_2d.stop()
		# animated_sprite_2d.play("idle_transition")
		# await get_tree().create_timer(1).timeout
		animated_sprite_2d.play("idle")
		
		#if velocity != Vector2.ZERO:
		#	footsteps.play()
		#elif velocity == Vector2.ZERO:
		#	footsteps.stop()
	
	#TODO remove this before releasing the game
	if Input.is_action_just_pressed("reroll"):
		WeaponManager.reset()
	if Input.is_action_just_pressed("next_level"):
		await LevelTransition.fade_to_black(1)
		Progression.next_level()
		get_tree().change_scene_to_file("res://scenes/test_world.tscn")
		LevelTransition.fade_from_black(1)
	if Input.is_action_just_pressed("heal"):
		set_health(player_max_health)

	velocity = player_velocity.normalized() * movement_speed + bounce_velocity
	bounce_velocity += Vector2.ONE * bounce_acceleration
	bounce_velocity.x = clamp(bounce_velocity.x, 0.0, 999.0)
	bounce_velocity.y = clamp(bounce_velocity.y, 0.0, 999.0)
	
	move_and_slide()

#die
func on_death():
	is_dead = true
	get_tree().paused = true
	await LevelTransition.fade_to_black(0.3)
	get_tree().paused = false
	get_tree().change_scene_to_packed(game_over)
	LevelTransition.fade_from_black(0.3)

func take_damage(enemy_atk):
	var dmg = (clamp(enemy_atk-player_def, 0, 9999999))+enemy_atk
	set_health(health - dmg)
	camera.apply_shake()
	print("Player takes " + str(dmg) + " damage and has " + str(health) + " hp left")

func renable_swing():
	can_swing = true

func get_health() -> float:
	return health
	
func set_health(new_health: float):
	if new_health > health:
		heal_particles.emitting = true
	
	health = clamp(new_health, 0.0, player_max_health)
	health = round(health)
	health_bar.value = health
	
	Progression.set_player_health(health)
	
	if health <= 0.0:
		if !is_dead:
			on_death()
		return
		
func bounce_towards(direction: Vector2):
	bounce_velocity = direction * bounce_initial_speed

func apply_shake():
	camera.apply_shake()
