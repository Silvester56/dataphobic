extends Node2D

@export var Eraserbot: PackedScene

var totalDataErased: int = 0
var eraserbotArray: Array = []
var eraserbotSpeed: float = 0
var eraserbotsPower: int = 1
var selfReplicationEnabled = false
var selfReplicationSpeed: float = 0
var intelSpeed: float = 0
var percentageOfDevicesInfectedUnits = 0
var percentageOfDevicesInfectedDecimals = 1
var spreadPower = 1
var bandwith = 1
var maximumSwarmPower = 0
var availableSwarmPower = 0
var devicesInfectedDecimalsThresholds = [10, 20, 50, 100, 200, 500, 1000, 10000, 100000]
var devicesInfectedUnitsThresholds = [1, 2, 5, 10, 30, 50]
var totalIntel = 0
var swarmPrediction = false
var eraserbotsCoordination = false
var datafuel = false

func _process(delta: float) -> void:
	for i in len(eraserbotArray):
		if eraserbotArray[i].power == eraserbotArray[i].fullPower:
			for ticks in eraserbotsPower:
				if $DataManager.dataRemaining > 0:
					if eraserbotsCoordination:
						$DataManager.eraseFirstData()
					else :
						$DataManager.eraseRandomData()
					eraserbotArray[i].power = 0
		else:
			eraserbotArray[i].chargePower(delta)

func increaseTotalDataErased() -> void:
	totalDataErased = totalDataErased + bandwith
	if datafuel:
		changeIntel(1)
	$TotalDataErased.text = "Total data erased : " + str(totalDataErased) + " bytes"
	$UpgradeManager.handleDataErased(totalDataErased)

func increaseGridSize(newSize: int) -> void:
	$DataManager.dataHandlingCapacity = newSize

func speedUpFetching(nolag: bool) -> void:
	$DataManager.dataFetchingTime = $DataManager.dataFetchingTime - 0.5
	if nolag:
		$DataManager.dataFetchingTime = 0

func addEraserbot() -> void:
	var newBot = Eraserbot.instantiate()
	newBot.position.x = 800 + (len(eraserbotArray) % 2) * 100
	newBot.position.y = 100 + (len(eraserbotArray) / 2) * 80
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
	$Swarm/IntelSpeedIncrease.visible = true
	$Swarm/IntelSpeedDecrease.visible = true
	$Swarm/IntelSpeed.visible = true

func turnOnSwarmPrediction() -> void:
	swarmPrediction = true

func turnOnDatafuel() -> void:
	datafuel = true

func increaseSpred() -> void:
	spreadPower = spreadPower + 1

func coordinateEraserbots() -> void:
	eraserbotsCoordination = true

func doulbeEraserbotsPower() -> void:
	eraserbotsPower = eraserbotsPower * 2

func _on_self_replication_timer_timeout() -> void:
	percentageOfDevicesInfectedDecimals = percentageOfDevicesInfectedDecimals + spreadPower
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
	if swarmPrediction:
		if len(devicesInfectedDecimalsThresholds) > 0:
			$PercentageOfDevicesInfected.text = $PercentageOfDevicesInfected.text + " (next swarm upgrade at 0." + paddingPercent(devicesInfectedDecimalsThresholds[0]) + "%)"
		else:
			$PercentageOfDevicesInfected.text = $PercentageOfDevicesInfected.text + " (next swarm upgrade at " + paddingPercent(devicesInfectedUnitsThresholds[0]) + "%)"

func updateSwarmLabelAndButtons() -> void:
	$Swarm/EraserBotIncrease.disabled = availableSwarmPower == 0 || eraserbotSpeed == 50
	$Swarm/EraserBotDecrease.disabled = eraserbotSpeed == 0
	$Swarm/SelfReplicationIncrease.disabled = availableSwarmPower == 0 || selfReplicationSpeed == 50
	$Swarm/SelfReplicationDecrease.disabled = selfReplicationSpeed == 0
	$Swarm/IntelSpeedIncrease.disabled = availableSwarmPower == 0 || intelSpeed == 50
	$Swarm/IntelSpeedDecrease.disabled = intelSpeed == 0
	$Swarm/AvailablePower.text = "Available swarm power : " + str(availableSwarmPower) + "/" + str(maximumSwarmPower)
	$Swarm/EraserbotSpeed.text = "Eraserbot : " + str(eraserbotSpeed)
	$Swarm/SelfReplicationSpeed.text = "Self replication : " + str(selfReplicationSpeed)
	$Swarm/IntelSpeed.text = "Neural network : " + str(intelSpeed)

func updateEraserbotFullPower() -> void:
	for i in len(eraserbotArray):
		eraserbotArray[i].fullPower = 5.1 - eraserbotSpeed / 10

func changeIntel(ammount) -> void:
	totalIntel = totalIntel + ammount
	$UpgradeManager.onIntelChange(totalIntel)
	$Intel.text = "INTEL : " + str(totalIntel)

func _on_intel_timer_timeout() -> void:
	changeIntel(1)

func _on_eraser_bot_decrease_pressed() -> void:
	availableSwarmPower = availableSwarmPower + 1
	eraserbotSpeed = eraserbotSpeed - 1
	updateEraserbotFullPower()
	$Swarm/EraserBotIncrease.disabled = false
	updateSwarmLabelAndButtons()

func _on_eraser_bot_increase_pressed() -> void:
	availableSwarmPower = availableSwarmPower - 1
	eraserbotSpeed = eraserbotSpeed + 1
	updateEraserbotFullPower()
	$Swarm/EraserBotDecrease.disabled = false
	updateSwarmLabelAndButtons()

func _on_self_replication_decrease_pressed() -> void:
	availableSwarmPower = availableSwarmPower + 1
	selfReplicationSpeed = selfReplicationSpeed - 1
	$SelfReplicationTimer.wait_time = 10.1 - selfReplicationSpeed / 5
	$Swarm/SelfReplicationIncrease.disabled = false
	updateSwarmLabelAndButtons()

func _on_self_replication_increase_pressed() -> void:
	availableSwarmPower = availableSwarmPower - 1
	selfReplicationSpeed = selfReplicationSpeed + 1
	$SelfReplicationTimer.wait_time = 10.1 - selfReplicationSpeed / 5
	$Swarm/SelfReplicationDecrease.disabled = false
	updateSwarmLabelAndButtons()

func _on_intel_speed_decrease_pressed() -> void:
	availableSwarmPower = availableSwarmPower + 1
	intelSpeed = intelSpeed - 1
	$IntelTimer.wait_time = 4 - intelSpeed * 0.6
	$Swarm/IntelSpeedIncrease.disabled = false
	updateSwarmLabelAndButtons()

func _on_intel_speed_increase_pressed() -> void:
	availableSwarmPower = availableSwarmPower - 1
	intelSpeed = intelSpeed + 1
	$IntelTimer.wait_time = 4 - intelSpeed * 0.6
	$Swarm/IntelSpeedDecrease.disabled = false
	updateSwarmLabelAndButtons()
