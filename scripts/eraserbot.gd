extends Node2D

var power: float = 0
var fullPower: float = 5.1

func chargePower(ammount: float) -> void:
	power = min(power + ammount, fullPower)
	$Label.text = str(floor(power * 100 / fullPower)) + "%"
