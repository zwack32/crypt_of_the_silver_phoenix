extends Area2D

class_name Player
var speed = 300

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
	
	


#when you die
func _on_body_entered(body):
	hide()
