extends Area2D

@onready var sprite_2d = $Sprite2D
var is_in_range = false

var world_scene = preload("res://scenes/test_world.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_in_range && Input.is_action_just_pressed("pick_up"):
		is_in_range = false
		await LevelTransition.fade_to_black(1)
		Progression.next_level()
		get_tree().change_scene_to_packed(world_scene)
		LevelTransition.fade_from_black(1)

func _on_area_entered(area):
	if area.owner is Player:
		is_in_range = true
		sprite_2d.modulate.a = 0.75

func _on_area_exited(area):
	if area.owner is Player:
		is_in_range = false	
		sprite_2d.modulate.a = 1.0
