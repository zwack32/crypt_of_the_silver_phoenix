extends Area2D

@onready var collision_shape_2d = $CollisionShape2D
var player: Player
var enemy: Enemy

var str = 5

func _ready():
	pass

func _process(delta):
	pass

func _on_area_entered(area):
	enemy_damage(player.player_atk, enemy.enemy_atk)

func enemy_damage(player_atk,enemy_def):
	player_atk+str-enemy_def+str
	#actually do the damage here
