extends Control

@onready var popup = $"."

var text_shown = "Pop Up"
var show_time = 10

@onready var label = $ColorRect/Label
@onready var popup_timer = $Timer

func _ready():
	label.text = text_shown
	popup_timer.start(show_time)
	


func _on_timer_timeout():
	popup.queue_free()
