extends Node2D
class_name EnemyParticles

func play_burn():
	$Burn.emitting = true
	
func play_freeze():
	$Freeze.emitting = true

func play_glow():
	$Glow.emitting = true
	
func stop():
	$Burn.emitting = false
	$Freeze.emitting = false
	$Glow.emitting = false
