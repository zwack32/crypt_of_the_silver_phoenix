extends Area2D
class_name Enemy

@export var player: Area2D
@export var speed: float = 2.0

var enemy_max_health = 20
var enemy_atk = 5
var enemy_def = 5

var enemy_health = enemy_max_health

#annoying functions so that we can use these in other scripts
func get_enemy_atk():
	return enemy_atk
func get_enemy_def():
	return enemy_def
func get_enemy_max_hp():
	return enemy_max_health
func get_enemy_health():
	return enemy_health
	
	
func _ready():
	pass 

#Move toward player
func _process(delta):
	var direction = (player.position - position).normalized()
	position += direction * speed

#Hit player
func _on_area_entered(area):
	player.deal_damage(enemy_atk)
