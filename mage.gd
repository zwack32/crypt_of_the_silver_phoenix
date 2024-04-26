extends Enemy
class_name Mage

@export var speed = randi_range(50, 100)
var mage_spell = preload("res://scenes/mage_spell.tscn")

@onready var spell_cooldown_timer = $SpellCooldownTimer

func _ready():
	spawn_delay = 1.5
	spawn_delay_rand_range = 0.5

	enemy_max_health = 30
	enemy_atk = 7
	enemy_def = 5
	enemy_speed = 100

	idle_animation_name = "move"
	die_animation_name = "die"
	crumble_animation_name = "crumble"

	enemy_health = enemy_max_health

	health_bar = $MageHealthBar
	animated_sprite_2d = $AnimatedSprite2D

	await on_enemy_ready()

func _process(delta):
	if !on_enemy_process():
		return;	
	
	ranged_attack()

	velocity = Vector2.ZERO
	
	if !is_dead:
		var direction = (player.position - position).normalized()
		velocity = direction * enemy_speed

	
	health_bar.value = enemy_health

func ranged_attack():
	if !spell_cooldown_timer.time_left == 0:
		pass
	else:
		var spell = mage_spell.instantiate()
		spell_cooldown_timer.wait_time = spell.cooldown
		spell.mage = self
		spell.player = player
		get_parent().add_child(spell)
		spell_cooldown_timer.start()

func _on_area_2d_area_entered(area):
	if !is_dead:
		on_enemy_area_entered(area)
		if area.owner is Player:
			player.bounce_towards((player.position - position).normalized())
