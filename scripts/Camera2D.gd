extends Camera2D

@export var random_strength = 30.0
@export var shake_fade = 5.0
@onready var area2d = $"../Area2D"

var rng = RandomNumberGenerator.new()
var shake_strength = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
	
	offset = randomOffset()
	
	

func apply_shake():
	shake_strength = random_strength
	
func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))



