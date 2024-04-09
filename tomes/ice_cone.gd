extends Tome

var velocity = Vector2.ZERO
var str = 7
var type = "ice"
@export var cooldown = 3.0

#@onready var cpu_particles_2d = $CPUParticles2D
@onready var ice_cone_animation = $IceConeAnimation


func _ready():
	var mouse_pos = get_viewport().get_mouse_position()
	var viewport = get_viewport().size
	var screen_mouse_pos = Vector2(mouse_pos.x / viewport.x, mouse_pos.y / viewport.y)
	var coord = screen_mouse_pos * 2.0 - Vector2(1.0, 1.0)
	rotation = coord.angle() + PI / 2
	position = player.position
	#cpu_particles_2d.emitting = true
	ice_cone_animation.play("ice_cone")

func _on_area_entered(area):
	await get_tree().create_timer(0.5).timeout
	queue_free()
	
