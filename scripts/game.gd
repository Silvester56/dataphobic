extends Node2D

@export var Eraserbot: PackedScene

var totalDataErased: int = 0
var eraserbotArray: Array = []
var chargingCapacity: float = 0.25

func _process(delta: float) -> void:
	for i in len(eraserbotArray):
		if eraserbotArray[i].power == 100:
			if $DataManager.dataRemaining > 0:
				$DataManager.eraseRandomData()
				eraserbotArray[i].power = 0
		else:
			eraserbotArray[i].chargePower(chargingCapacity)

func increaseTotalDataErased() -> void:
	totalDataErased = totalDataErased + 1
	$TotalDataErased.text = "Total data erased : " + str(totalDataErased) + " bytes"
	$UpgradeManager.handleDataErased(totalDataErased)

func increaseGridSize(newSize: int) -> void:
	$DataManager.dataHandlingCapacity = newSize

func speedUpFetching() -> void:
	$DataManager.dataFetchingTime = $DataManager.dataFetchingTime - 0.5

func addEraserbot() -> void:
	var newBot = Eraserbot.instantiate()
	newBot.position.x = 900
	newBot.position.y = 100 + len(eraserbotArray) * 80
	eraserbotArray.push_back(newBot)
	add_child(newBot)
