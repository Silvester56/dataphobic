extends Node2D

@export var Eraserbot: PackedScene

var totalDataErased: int = 0
var eraserbotArray: Array = []
var eraserbotSpeed: float = 0
var selfReplicationEnabled = false
var selfReplicationSpeed: float = 0
var percentageOfDevicesInfectedUnits = 0
var percentageOfDevicesInfectedDecimals = 1
var bandwith = 1
var maximumSwarmPower = 0
var availableSwarmPower = 0
var devicesInfectedDecimalsThresholds = [10, 20, 50, 100, 150, 300, 500, 1000, 5000, 10000, 50000, 100000, 500000]
var devicesInfectedUnitsThresholds = [1, 2, 5, 10, 15, 30, 50, 100]
var totalIntel = 0

func _process(delta: float) -> void:
	for i in len(eraserbotArray):
		if eraserbotArray[i].power == 100:
			if $DataManager.dataRemaining > 0:
				$DataManager.eraseRandomData()
				eraserbotArray[i].power = 0
		else:
			eraserbotArray[i].chargePower(0.5 + eraserbotSpeed / 10)

func increaseTotalDataErased() -> void:
	totalDataErased = totalDataErased + bandwith
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

func increaseBandwidth() -> void:
	bandwith = bandwith * 4
	totalDataErased = totalDataErased + bandwith - totalDataErased % bandwith

func turnOnSwarm() -> void:
	$Swarm.visible = true

func turnOnNeuralNetwork() -> void:
	$IntelTimer.start()
	$Intel.visible = true

func _on_self_replication_timer_timeout() -> void:
	percentageOfDevicesInfectedDecimals = percentageOfDevicesInfectedDecimals + 1
	if len(devicesInfectedDecimalsThresholds) > 0 and percentageOfDevicesInfectedDecimals >= devicesInfectedDecimalsThresholds[0]:
		devicesInfectedDecimalsThresholds.pop_front()
		maximumSwarmPower = maximumSwarmPower + 10
		availableSwarmPower = availableSwarmPower + 10
		updateSwarmLabelAndButtons()
	if len(devicesInfectedUnitsThresholds) > 0 and percentageOfDevicesInfectedUnits >= devicesInfectedUnitsThresholds[0]:
		devicesInfectedUnitsThresholds.pop_front()
		maximumSwarmPower = maximumSwarmPower + 10
		availableSwarmPower = availableSwarmPower + 10
		updateSwarmLabelAndButtons()
	if percentageOfDevicesInfectedDecimals >= 1000000:
		percentageOfDevicesInfectedUnits = percentageOfDevicesInfectedUnits + 1
		percentageOfDevicesInfectedDecimals = 0
	$PercentageOfDevicesInfected.text = "Percentage of devices infected : " + str(percentageOfDevicesInfectedUnits) + "." + paddingPercent(percentageOfDevicesInfectedDecimals) + "%"

func updateSwarmLabelAndButtons() -> void:
	$Swarm/EraserBotIncrease.disabled = availableSwarmPower == 0
	$Swarm/SelfReplicationIncrease.disabled = availableSwarmPower == 0 || selfReplicationSpeed == 50
	$Swarm/EraserBotDecrease.disabled = eraserbotSpeed == 0
	$Swarm/SelfReplicationDecrease.disabled = selfReplicationSpeed == 0
	$Swarm/AvailablePower.text = "Available swarm power : " + str(availableSwarmPower) + "/" + str(maximumSwarmPower)
	$Swarm/EraserbotSpeed.text = "Eraserbot boost : " + str(eraserbotSpeed)
	$Swarm/SelfReplicationSpeed.text = "Self replication boost : " + str(selfReplicationSpeed)

func _on_eraser_bot_decrease_pressed() -> void:
	availableSwarmPower = availableSwarmPower + 1
	eraserbotSpeed = eraserbotSpeed - 1
	$Swarm/EraserBotIncrease.disabled = false
	updateSwarmLabelAndButtons()

func _on_eraser_bot_increase_pressed() -> void:
	availableSwarmPower = availableSwarmPower - 1
	eraserbotSpeed = eraserbotSpeed + 1
	$Swarm/EraserBotDecrease.disabled = false
	updateSwarmLabelAndButtons()

func _on_self_replication_decrease_pressed() -> void:
	availableSwarmPower = availableSwarmPower + 1
	selfReplicationSpeed = selfReplicationSpeed - 1
	$SelfReplicationTimer.wait_time = 10 - selfReplicationSpeed
	$Swarm/SelfReplicationIncrease.disabled = false
	updateSwarmLabelAndButtons()

func _on_self_replication_increase_pressed() -> void:
	availableSwarmPower = availableSwarmPower - 1
	selfReplicationSpeed = selfReplicationSpeed + 1
	$SelfReplicationTimer.wait_time = 10.1 - selfReplicationSpeed / 5
	$Swarm/SelfReplicationDecrease.disabled = false
	updateSwarmLabelAndButtons()

func changeIntel(ammount) -> void:
	totalIntel = totalIntel + ammount
	$UpgradeManager.onIntelChange(totalIntel)
	$Intel.text = "INTEL : " + str(totalIntel)

func _on_intel_timer_timeout() -> void:
	changeIntel(1)
