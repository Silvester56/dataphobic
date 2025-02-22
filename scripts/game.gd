extends Node2D

var totalDataErased: int = 0
var eraserbotArray: Array = []

func _process(delta: float) -> void:
	for i in len(eraserbotArray):
		if eraserbotArray[i] == 100:
			if $DataManager.dataRemaining > 0:
				$DataManager.eraseRandomData()
				eraserbotArray[i] = 0
		else:
			eraserbotArray[i] = eraserbotArray[i] + 1

func increaseTotalDataErased() -> void:
	totalDataErased = totalDataErased + 1
	$TotalDataErased.text = "Total data erased : " + str(totalDataErased) + " bytes"
	$UpgradeManager.handleDataErased(totalDataErased)

func increaseGridSize(newSize: int) -> void:
	$DataManager.dataHandlingCapacity = newSize

func speedUpFetching() -> void:
	$DataManager.dataFetchingTime = $DataManager.dataFetchingTime - 0.5

func addEraserbot() -> void:
	eraserbotArray.push_back(0)
