extends Area2D
class_name Player

var movement_speed = 300

#adjustable stats
var player_max_health = 50
var player_atk = 10
var player_def = 10
var player_spd = 10

var health = player_max_health
var direction = Vector2.UP

@export var weapon_test_stick: PackedScene

var swing_weapon
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
	#create velocity, set it to zero
	var velocity = Vector2.ZERO
	
	#change velocity by player's input
	if Input.is_action_pressed("move_down"):
		direction = Vector2.DOWN
		velocity.y += 1
		rotation_degrees = 180
	if Input.is_action_pressed("move_up"):
		direction = Vector2.UP
		velocity.y += -1
		rotation_degrees = 0
	if Input.is_action_pressed("move_left"):
		direction = Vector2.LEFT
		velocity.x += -1
		rotation_degrees = 270
	if Input.is_action_pressed("move_right"):
		direction = Vector2.RIGHT
		velocity.x += 1
		rotation_degrees = 90
	
	#normalize the velocity
	velocity = velocity.normalized()

	#move player
	position += velocity * movement_speed * delta
	
	if swing_weapon:
		swing_weapon.rotation_degrees += 12
		if swing_weapon.rotation_degrees >= 45:
			swing_weapon = null
	
	if Input.is_action_just_pressed("melee"):
		melee_attack()
		var right_down_vec = Vector2(1, 1).normalized()
		var right_up_vec = Vector2(1, -1).normalized()
		var mouse_dir = get_mouse_direction_from_player()
		
		var theta_a = acos(right_down_vec.dot(mouse_dir) / (right_down_vec.length() * mouse_dir.length()))
		var theta_b = acos(right_up_vec.dot(mouse_dir) / (right_up_vec.length() * mouse_dir.length()))
		
		var swing_direction
		if theta_a < PI / 2:
			if theta_b < PI / 2:
				# Right 
				swing_direction = Vector2.RIGHT
			else:
				# Down
				swing_direction = Vector2.DOWN
		else:
			if theta_b < PI / 2:
				# Up
				swing_direction = Vector2.UP
			else:
				# Left
				swing_direction = Vector2.LEFT
				
		swing_weapon.rotation_degrees = -45
				
		print(swing_direction)
	
	if Input.is_action_just_pressed("ranged"):
		ranged_attack()
		print("ranged")
		
func get_mouse_direction_from_player():
	var mouse_pos = get_viewport().get_mouse_position()
	var viewport = get_viewport().size
	var screen_mouse_pos = Vector2(mouse_pos.x / viewport.x, mouse_pos.y / viewport.y)
	var screen_coord = (screen_mouse_pos - (Vector2(position.x / viewport.x, position.y / viewport.y))) * 2
	
	return screen_coord.normalized()

func melee_attack():
	if !swing_weapon:
		var test_stick = weapon_test_stick.instantiate()
		test_stick.player = self
		swing_weapon = test_stick
		add_child(test_stick)

func ranged_attack():
	pass

#die
func on_death():
	var dead = true

func take_damage(enemy_atk):
	health -= (clamp(enemy_atk-player_def, 0, 9999999))+enemy_atk
	print(health)
	if health <=0:
		health = 0
		on_death()
