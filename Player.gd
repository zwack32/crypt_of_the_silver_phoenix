extends Area2D

class_name Player
var speed = 300
var max_health = 50
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

#when you get hit
func _on_body_entered(body):
	health -= 10
	print(health)
