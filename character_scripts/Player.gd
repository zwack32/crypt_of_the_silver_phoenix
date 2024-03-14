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

@export var weapon_manager: WeaponManager

@onready var health_bar = $HealthBar
@onready var spell_bar = $SpellBar
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
	spell_cooldown_timer.start()
	spell_bar.max_value = spell_cooldown_timer.time_left

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move()
	
	if Input.is_action_just_pressed("melee"):
		melee_attack()
	
	if Input.is_action_just_pressed("ranged"):
		ranged_attack()
	
	pick_up_item()
	
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
		var fireball = weapon_manager.get_tome_scene().instantiate()
		fireball.player = self
		#TODO make this work with all spells. it might already, 
		#but if it does we need to rename the variable
		get_parent().add_child(fireball)
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

	velocity = player_velocity.normalized() * movement_speed
	
	move_and_slide()

func pick_up_item():
	#var able_to_pickup = (position-pickup_position)
	if Input.is_action_pressed("pick_up"): #and able_to_pickup <= whatever range we want
		#player is within range of item
		pass
		#inventory manager, manage inventory!

#die
func on_death():
	var dead = true

func take_damage(enemy_atk):
	var dmg = (clamp(enemy_atk-player_def, 0, 9999999))+enemy_atk
	health -= dmg
	
	if health <=0:
		health = 0
		on_death()
	health_bar.value = health
	print("Player takes " + str(dmg) + " damage and has " + str(health) + " hp left")

func renable_swing():
	can_swing = true

