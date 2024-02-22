extends Area2D
class_name Player

var speed = 300

#adjustable stats
var max_health = 50
var player_atk = 10
var player_def = 10
var player_spd = 10

var health = max_health
var direction = Vector2.UP

@export var weapon_test_stick: PackedScene

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
	if Input.is_action_pressed("move_up"):
		direction = Vector2.UP
		velocity.y += -1
	if Input.is_action_pressed("move_left"):
		direction = Vector2.LEFT
		velocity.x += -1
	if Input.is_action_pressed("move_right"):
		direction = Vector2.RIGHT
		velocity.x += 1
	
	#normalize the velocity
	velocity = velocity.normalized()

	#move player
	position += velocity * speed * delta
	
	if Input.is_action_just_pressed("melee"):
		melee_attack()
		print(get_mouse_direction_from_player())
	
	if Input.is_action_just_pressed("ranged"):
		ranged_attack()
		print("ranged")
		
func get_mouse_direction_from_player():
	var viewport_w = get_viewport().size.x
	var viewport_h = get_viewport().size.y
	
	var mouse_global_pos = get_viewport().get_mouse_position()
	
	return Vector2(mouse_global_pos.x / viewport_w, mouse_global_pos.y / viewport_h)

func melee_attack():
	var test_stick = weapon_test_stick.instantiate()
	add_child(test_stick)

func ranged_attack():
	pass


#die
func on_death():
	var dead = true

func deal_damage(enemy_atk):
	health -= (clamp(enemy_atk-player_def, 0, 9999999))+enemy_atk
	print(health)
	if health <=0:
		health = 0
		on_death()

