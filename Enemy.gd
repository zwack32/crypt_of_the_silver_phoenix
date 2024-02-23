extends Area2D
class_name Enemy

@export var player: Area2D
@export var speed: float = 2.0

var enemy_health = 20
var enemy_atk = 5
var enemy_def = 5

func _ready():
	pass 

#Move toward player
func _process(delta):
	var direction = (player.position - position).normalized()
	position += direction * speed

#Hit player
func _on_area_entered(area):
	player.deal_damage(enemy_atk)
