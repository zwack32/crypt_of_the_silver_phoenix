extends Area2D

@onready var collision_shape_2d = $CollisionShape2D
@export var player: Player
@export var enemy: Enemy

var str = 5

func _ready():
	pass

func _process(delta):
	pass

func _on_area_entered(area):
	#enemy_damage(player.get_player_atk(), enemy.get_enemy_def(), enemy.get_enemy_health())
	#print(player.get_player_atk())
	#print(enemy.get_enemy_def())
	#print(enemy.get_enemy_health())
	pass

func enemy_damage(player_atk,enemy_def,enemy_hp):
	var new_enemy_health = enemy_hp
	new_enemy_health -= (clamp(player_atk+str-enemy_def, 0, 9999999))+str
	#actually do the damage here
