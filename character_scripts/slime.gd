extends Enemy
class_name Slime

@export var speed: float = 100.0
@export var spawn_delay: float = 1.5
@export var spawn_delay_rand_range: float = 0.5

@onready var death_timer = $DeathTimer
@onready var animated_sprite_2d = $AnimatedSprite2D

var enemy_max_health = 30
var enemy_atk = 5
var enemy_def = 5

var enemy_health

@onready var enemy_health_bar = $EnemyHealth

var dead = false
var is_active = false

var on_fire = false
var on_fire_process = false
var frozen = false
var frozen_process = false

@onready var fire_tick_timer = $FireTickTimer
@onready var fire_timer = $FireTimer
@onready var frozen_timer = $FrozenTimer

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
	enemy_health = enemy_max_health
	#randomize stats
	enemy_atk += randi_range((-1 + roundf(room_level/2)), (2+room_level))
	enemy_def += randi_range((-1 + roundf(room_level/2)), (2+room_level))
	enemy_health += randi_range((-2 + roundf(room_level/2)), 5+(2*room_level))
	
	#if on room 3 or higher, start adding elemental enemies
	var type = "normal"
	if room_level >= 3:
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
	
	var tween = get_tree().create_tween()
	$AnimatedSprite2D.modulate = Color(1.0, 1.0, 1.0, 0.0)
	tween.tween_property($AnimatedSprite2D, "modulate", Color(1.0, 1.0, 1.0, 1.0), spawn_delay)
	
	var original_layer = collision_layer
	var original_mask = collision_mask
	
	collision_layer = 0
	collision_mask = 0
	
	await get_tree().create_timer(spawn_delay + randf_range(0.0, spawn_delay_rand_range)).timeout
	animated_sprite_2d.play("Slime_idle")
	is_active = true
	collision_layer = original_layer
	collision_mask = original_mask

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_active:
		return
	
	velocity = Vector2.ZERO
	if !dead:
		var direction = (player.position - position).normalized()
		velocity = direction * speed
	if death_timer.time_left <= 0 and dead:
		queue_free()
	move_and_slide()
	
	enemy_health_bar.value = enemy_health
	
	if on_fire:
		on_fire_process = true
		fire_tick_timer.start()
		fire_timer.start()
		on_fire = false
		
	if on_fire_process and fire_tick_timer.time_left == 0:
		enemy_health -= 2
		fire_tick_timer.start()
		
	if on_fire_process and fire_timer.time_left == 0:
		on_fire = false
		on_fire_process = false
		
	if enemy_health <= 0:
		enemy_health = 0
		enemy_health_bar.hide()
		enemy_die()
		
			
	if frozen:
			frozen_timer.start()
			frozen = false
			frozen_process = true
			speed /= 2
	
	if frozen_process and frozen_timer.time_left == 0:
		frozen_process = false
		speed *= 2


#differentiate between player hitting enemy and enemy hitting player
func _on_area_entered(area):
	if !is_active:
		return
		
	if !dead:
		if area is MeleeWeapon:
			#enemy takes damage
			enemy_health = enemy_take_damage(player.get_player_atk(), enemy_def, enemy_health, area.str)
			#print("enemy take damage")
			if area.type == "fire":
				on_fire = true
			if area.type == "ice":
				frozen = true
		elif area.owner is Player:
			#player takes damage
			player.take_damage(enemy_atk)
			#print("player take damage")
		elif area is Tome:
			enemy_health = enemy_take_damage(player.get_player_atk(), enemy_def, enemy_health, area.str)
			if area.type == "fire":
				on_fire = true
			if area.type == "ice":
				frozen = true
	

func enemy_take_damage(player_atk,enemy_def,enemy_health, sword_str):
	var dmg = clamp(clamp(player_atk+sword_str-enemy_def, 0, 9999999)+sword_str, 0, 9999999)
	enemy_health -= dmg
	if enemy_health <= 0:
		enemy_health = 0
		enemy_health_bar.hide()
		enemy_die()
	enemy_health_bar.value = enemy_health
	print("Enemy takes " + str(dmg) + " damage and has " + str(enemy_health) + " hp left")
	return enemy_health

func enemy_die():
	if dead:
		return
		
	print("did you die again")
	dead = true
	velocity = Vector2.ZERO
	animated_sprite_2d.play("Slime_die")
	death_timer.start()
	on_fire = false
	frozen = false
	room_battle_instance.pop_enemy()
