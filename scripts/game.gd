extends Node2D

var totalDataErased: int = 0

func increaseTotalDataErased() -> void:
	totalDataErased = totalDataErased + 1
	$TotalDataErased.text = "Total data erased : " + str(totalDataErased) + " bytes"
	$UpgradeManager.handleDataErased(totalDataErased)

func increaseGridSize(newSize: int) -> void:
	$DataManager.dataHandlingCapacity = newSize

func speedUpFetching() -> void:
	$DataManager.dataFetchingTime = $DataManager.dataFetchingTime - 0.5
