extends Tome

var str = 0
#actual strength is 5
var velocity = Vector2.ZERO
var speed = 700.0

@onready var bead_collison_shape = $BeadCollisionShape
@onready var bead_sprite = $BeadSprite
@onready var blast_collision_shape = $BlastCollisionShape
@onready var blast_sprite = $BlastSprite


# Called when the node enters the scene tree for the first time.
func _ready():
	bead_collison_shape.enable()
	bead_sprite.enable()
	
	blast_collision_shape.disable()
	blast_sprite.disable()
	
	var mouse_pos = get_viewport().get_mouse_position()
	
	var direction = (mouse_pos - position).normalized()
	velocity = direction * speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity
	

func _on_area_entered(area):
	str = 5
	
	bead_collison_shape.disable()
	bead_sprite.disable()
	
	blast_collision_shape.enable()
	blast_sprite.enable()
	
	await get_tree().create_timer(0.016).timeout
	set_collision_layer_value(1, 0)
