extends Tome

var velocity = Vector2.ZERO
var str = 3
var type = "null"
@export var cooldown = 3.0

#@onready var cpu_particles_2d = $CPUParticles2D
@onready var ice_cone_animation = $IceConeAnimation


func _ready():
	position = player.position
	rotation = global_position.direction_to(get_global_mouse_position()).angle() + PI / 2	
	#cpu_particles_2d.emitting = true
	ice_cone_animation.play("ice_cone")

func _on_area_entered(area):
	area.bounce_towards((position - area.position).normalized()*3)
	await get_tree().create_timer(0.5).timeout
	queue_free()
