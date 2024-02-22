extends Area2D

class_name Player

var speed = 300

#adjustable stats
var max_health = 50
var player_atk = 10
var player_def = 10
var player_spd = 10

var health = max_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#create velocity, set it to zero
	var velocity = Vector2.ZERO
	
	#change velocity by player's input
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y += -1
	if Input.is_action_pressed("ui_left"):
		velocity.x += -1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	
	#normalize the velocity
	velocity = velocity.normalized()
	
	#move player
	position += velocity * speed * delta
	
	if Input.is_action_just_pressed("melee"):
		melee_attack()
		print("melee")
	
	if Input.is_action_just_pressed("ranged"):
		ranged_attack()
		print("ranged")

func melee_attack():
	pass

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

