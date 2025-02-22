extends Node2D

@export var Eraserbot: PackedScene

var totalDataErased: int = 0
var eraserbotArray: Array = []
var chargingCapacity: float = 0.25
var selfReplicationEnabled = false
var percentageOfDevicesInfectedUnits = 0
var percentageOfDevicesInfectedDecimals = 1

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

func turnOnSelfReplication() -> void:
	$PercentageOfDevicesInfected.visible = true
	$SelfReplicationTimer.start()

func paddingPercent(percent: int) -> String:
	var result = str(percent)
	while len(result) < 6:
		result = "0" + result
	return result

func _on_self_replication_timer_timeout() -> void:
	percentageOfDevicesInfectedDecimals = percentageOfDevicesInfectedDecimals + 1
	if percentageOfDevicesInfectedDecimals >= 1000000:
		percentageOfDevicesInfectedUnits = percentageOfDevicesInfectedUnits + 1
		percentageOfDevicesInfectedDecimals = 0
	$PercentageOfDevicesInfected.text = "Percentage of devices infected : " + str(percentageOfDevicesInfectedUnits) + "." + paddingPercent(percentageOfDevicesInfectedDecimals) + "%"
