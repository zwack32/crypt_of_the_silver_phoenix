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
	print(player.get_player_atk())
	#print(enemy.enemy_def)
	#enemy_damage(player.player_atk, enemy.enemy_def, enemy.health)

func enemy_damage(player_atk,enemy_def,enemy_hp):
	player_atk+str-enemy_def+str
	#actually do the damage here
