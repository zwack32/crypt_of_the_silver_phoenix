extends CharacterBody2D
class_name Player

var movement_speed = 300

#adjustable stats
var player_max_health = 50
var player_atk = 10
var player_def = 10
var player_spd = 10

var health = player_max_health
var direction = Vector2.UP
var can_swing = true
var is_dead = false

@onready var game_over = preload("res://scenes/game_over.tscn")

@export var weapon_manager: WeaponManager

@onready var health_bar = $HealthBar
@onready var spell_bar = $SpellBar
@onready var animated_sprite_2d = $AnimatedSprite2D

@onready var spell_cooldown_timer = $SpellCooldownTimer

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
	health_bar.max_value = player_max_health
	spell_bar.max_value = spell_cooldown_timer.wait_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move()
	
	if Input.is_action_just_pressed("melee"):
		melee_attack()
	
	if Input.is_action_just_pressed("ranged"):
		ranged_attack()
	
	spell_bar.value = spell_cooldown_timer.time_left

func get_mouse_direction_from_player():
	var mouse_pos = get_viewport().get_mouse_position()
	var viewport = get_viewport().size
	var screen_mouse_pos = Vector2(mouse_pos.x / viewport.x, mouse_pos.y / viewport.y)
	var screen_coord = screen_mouse_pos * 2.0 - Vector2(1.0, 1.0)
	
	return screen_coord


func melee_attack():
	if !can_swing:
		return

	var weapon = weapon_manager.get_melee_scene().instantiate()
	weapon.player = self
	add_child(weapon)
	animated_sprite_2d.play("attack1")
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
		var spell = weapon_manager.get_tome_scene().instantiate()
		spell.player = self
		#TODO make this work with all spells. it might already, 
		#but if it does we need to rename the variable
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
		animated_sprite_2d.play("walk_left")
	if Input.is_action_pressed("move_right"):
		direction = Vector2.RIGHT
		player_velocity.x += 1
		animated_sprite_2d.play("walk_right")
	elif Input.is_action_just_released("move_left"):
		animated_sprite_2d.stop()
		animated_sprite_2d.play("default_left")
	elif Input.is_action_just_released("move_right"):
		animated_sprite_2d.stop()
		animated_sprite_2d.play("default_right")

	velocity = player_velocity.normalized() * movement_speed
	
	move_and_slide()

#die
func on_death():
	is_dead = true
	get_tree().paused = true
	await LevelTransition.fade_to_black(0.3)
	get_tree().change_scene_to_packed(game_over)
	LevelTransition.fade_from_black(0.3)

func take_damage(enemy_atk):
	var dmg = (clamp(enemy_atk-player_def, 0, 9999999))+enemy_atk
	set_health(health - dmg)
	print("Player takes " + str(dmg) + " damage and has " + str(health) + " hp left")

func renable_swing():
	can_swing = true

func get_health() -> float:
	return health
	
func set_health(new_health: float):
	health = clamp(new_health, 0.0, player_max_health)
	health = round(health)
	health_bar.value = health
	
	if health <= 0.0:
		if !is_dead:
			on_death()
		return
