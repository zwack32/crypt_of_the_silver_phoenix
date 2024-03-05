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
var can_swing = false



@export var weapon_test_stick: PackedScene

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
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
	
	if Input.is_action_just_pressed("melee"):
		melee_attack()
	
	if Input.is_action_just_pressed("ranged"):
		ranged_attack()
		print("ranged")
		
func get_mouse_direction_from_player():
	var mouse_pos = get_viewport().get_mouse_position()
	var viewport = get_viewport().size
	var screen_mouse_pos = Vector2(mouse_pos.x / viewport.x, mouse_pos.y / viewport.y)
	var screen_coord = screen_mouse_pos * 2.0 - Vector2(1.0, 1.0)
	
	return screen_coord.normalized()

func melee_attack():
	var test_stick = weapon_test_stick.instantiate()
	test_stick.player = self
	var swing_weapon = test_stick
	add_child(test_stick)
	can_swing = false

	var right_down_vec = Vector2(1, 1).normalized()
	var right_up_vec = Vector2(1, -1).normalized()
	var mouse_dir = get_mouse_direction_from_player()
	
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
			
	swing_weapon.rotation_degrees = swing_rot
	swing_weapon.start_rot = swing_rot
	swing_weapon.swing_speed = player_spd
	swing_weapon.rot = swing_rot
	swing_weapon.player = self
			
	print(swing_direction)

func ranged_attack():
	pass

#die
func on_death():
	var dead = true

func take_damage(enemy_atk):
	var dmg = (clamp(enemy_atk-player_def, 0, 9999999))+enemy_atk
	health -= dmg
	#print(health)
	if health <=0:
		health = 0
		on_death()
	print("Player takes " + str(dmg) + " damage and has " + str(health) + " hp left")

func renable_swing():
	can_swing = true

