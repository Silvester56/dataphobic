extends Node2D

var totalDataErased: int = 0

func increaseTotalDataErased() -> void:
	totalDataErased = totalDataErased + 1
	$TotalDataErased.text = "Total data erased : " + str(totalDataErased) + " bytes"
