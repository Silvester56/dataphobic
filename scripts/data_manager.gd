extends Node2D
@export var Data: PackedScene

var dataHandlingCapacity: int = 1
var dataRemaining: int = 1
var dataFetchingTime: float = 3
var displayDataSearchingTimer = false

func retrieveData():
	var tmpData
	var squareSize = 360 / sqrt(dataHandlingCapacity)
	for i in range(0, sqrt(dataHandlingCapacity)):
		for j in range(0, sqrt(dataHandlingCapacity)):
			tmpData = Data.instantiate()
			tmpData.connect("data_erased", _on_data_erased)
			tmpData.setPostionAndScale(j * squareSize - 180, i * squareSize - 180, squareSize)
			add_child(tmpData)
	dataRemaining = dataHandlingCapacity
	displayDataSearchingTimer = false
	$DataSearchingTimerLabel.visible = false
	if dataFetchingTime > 0:
		$DataSearchingTimer.wait_time = dataFetchingTime

func eraseRandomData() -> void:
	var searchRandomChild = true
	var randomChlid
	while searchRandomChild:
		randomChlid = get_children().pick_random()
		if "deleteSelf" in randomChlid and !randomChlid.marked:
			randomChlid.marked = true
			randomChlid.deleteSelf(null)
			searchRandomChild = false

func eraseFirstData() -> void:
	var searchFirstChild = true
	var index = 0
	var firstChild
	while index >= 0:
		firstChild = get_children()[index]
		if "deleteSelf" in firstChild and !firstChild.marked:
			firstChild.marked = true
			firstChild.deleteSelf(null)
			index = -1
		else:
			index = index + 1

func _on_data_erased(newPosition) -> void:
	dataRemaining = dataRemaining - 1
	if dataRemaining == 0:
		if dataFetchingTime > 0:
			displayDataSearchingTimer = true
			$DataSearchingTimer.start()
			$DataSearchingTimerLabel.visible = true
		else:
			retrieveData()
	$GPUParticles2D.global_position = newPosition
	$GPUParticles2D.emitting = true
	get_parent().increaseTotalDataErased()

func _ready() -> void:
	$DataSearchingTimer.wait_time = dataFetchingTime
	retrieveData()

func roundingTime(time: float) -> String:
	var result = str(snapped(time, 0.1))
	if len(result) == 1:
		result = result + ".0"
	return result

func _process(delta: float) -> void:
	if dataFetchingTime > 0 and displayDataSearchingTimer:
		$DataSearchingTimerLabel.text = roundingTime($DataSearchingTimer.time_left)

func _on_data_searching_timer_timeout() -> void:
	$DataSearchingTimer.stop()
	retrieveData()
