extends Enemy
class_name Slime

@export var stick: Area2D
@export var speed: float = 100.0

@onready var death_timer = $DeathTimer
@onready var sprite = $Sprite2D

var enemy_max_health = 30
var enemy_atk = 5
var enemy_def = 5

var enemy_health

@onready var enemy_health_bar = $EnemyHealth

var dead = false

var on_fire = false
var frozen = false

@onready var fire_tick_timer = $FireTickTimer

#annoying functions so that we can use these in other scripts
func get_enemy_atk():
	return enemy_atk
func get_enemy_def():
	return enemy_def
func get_enemy_max_hp():
	return enemy_max_health
func get_enemy_health():
	return enemy_health

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_health_bar.max_value = enemy_max_health
	fire_tick_timer.start()
	sprite.texture = load("res://icon.svg")
	enemy_health = enemy_max_health
	var room_number = 1
	#randomize stats
	enemy_atk += randi_range(-1, (2+room_number))
	enemy_def += randi_range(-1, (2+room_number))
	enemy_health += randi_range(-2, 5+(2*room_number))
	
	#if on room 3 or higher, start adding elemental enemies
	var type = "normal"
	if room_number >= 3:
		var type_determiner = randi_range(1, 4)
		if type_determiner == 1 or 2:
			type = "normal"
		elif type_determiner == 3:
			type = "fire"
			#load red godot icon here
		elif type_determiner == 4:
			type = "ice"
			#load cyan godot logo here
	
	print(str(enemy_atk) + "atk")
	print(str(enemy_def) + "def")
	print(str(enemy_health) + "health")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector2.ZERO
	if !dead:
		var direction = (player.position - position).normalized()
		velocity = direction * speed
	if death_timer.time_left <= 0 and dead:
		queue_free()
	move_and_slide()
	
	
	enemy_health_bar.value = enemy_health
	
	if on_fire:
		if fire_tick_timer.time_left == 0:
			enemy_health -= 2
			print(enemy_health)
			fire_tick_timer.start()
		if enemy_health <= 0:
			enemy_health = 0
			enemy_health_bar.hide()
			enemy_die()

#differentiate between player hitting enemy and enemy hitting player
func _on_area_entered(area):
	if !dead:
		if area is MeleeWeapon:
			#enemy takes damage
			enemy_health = enemy_take_damage(player.get_player_atk(), enemy_def, enemy_health, area.str)
			#print("enemy take damage")
		elif area.owner is Player:
			#player takes damage
			player.take_damage(enemy_atk)
			#print("player take damage")
		elif area is Tome:
			enemy_health = enemy_take_damage(player.get_player_atk(), enemy_def, enemy_health, area.str)
	

func enemy_take_damage(player_atk,enemy_def,enemy_health, sword_str):
	var dmg = (clamp(player_atk+sword_str-enemy_def, 0, 9999999))+sword_str
	enemy_health -= dmg
	if enemy_health <= 0:
		enemy_health = 0
		enemy_health_bar.hide()
		enemy_die()
	enemy_health_bar.value = enemy_health
	print("Enemy takes " + str(dmg) + " damage and has " + str(enemy_health) + " hp left")
	return enemy_health

func enemy_die():
	print("did you die again")
	dead = true
	velocity = Vector2.ZERO
	death_timer.start()
	sprite.texture = load("res://art/rect1.svg")
	
	on_fire = false
	frozen = false

