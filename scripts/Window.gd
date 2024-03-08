extends Window

@onready var instruction = $"."
@onready var instruction_button = $"../CenterContainer/VBoxContainer/Instructions"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_instructions_pressed():
	instruction.show()


func _on_close_requested():
	instruction.hide()
