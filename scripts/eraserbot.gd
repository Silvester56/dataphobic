extends Node2D

var power = 0

func chargePower(ammount: float) -> void:
	power = min(power + ammount, 100)
	$Label.text = str(floor(power)) + "%"
