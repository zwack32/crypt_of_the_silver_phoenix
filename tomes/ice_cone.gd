extends Tome

var velocity = Vector2.ZERO
var str = 7
var type = "ice"
@export var cooldown = 3.0

#@onready var cpu_particles_2d = $CPUParticles2D
@onready var ice_cone_animation = $IceConeAnimation
@onready var ice_sound = $IceSound

func _ready():
	position = player.position
	rotation = global_position.direction_to(get_global_mouse_position()).angle() + PI / 2
	player.apply_shake()
	ice_sound.play()
	#cpu_particles_2d.emitting = true
	ice_cone_animation.play("ice_cone")

func _process(delta):
	position = player.position

func _on_area_entered(area):
	await get_tree().create_timer(0.5).timeout
	queue_free()
