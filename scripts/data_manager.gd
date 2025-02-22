extends Node2D
@export var Data: PackedScene

var dataHandlingCapacity: int = 1
var dataRemaining: int = 1
var dataSearchingTime = 3
var currentlySearching = false

func retrieveData():
	var tmpData
	var squareSize = 360 / sqrt(dataHandlingCapacity)
	for i in range(0, sqrt(dataHandlingCapacity)):
		for j in range(0, sqrt(dataHandlingCapacity)):
			tmpData = Data.instantiate()
			tmpData.connect("data_erased", _on_data_erased)
			tmpData.setPostionAndScale(position.x + j * squareSize, position.y + i * squareSize, squareSize)
			add_child(tmpData)
	dataRemaining = dataHandlingCapacity
	currentlySearching = false
	$DataSearchingTimerLabel.visible = false

func _on_data_erased() -> void:
	dataRemaining = dataRemaining - 1
	get_parent().increaseTotalDataErased()

func _ready() -> void:
	$DataSearchingTimer.wait_time = dataSearchingTime
	retrieveData()

func _process(delta: float) -> void:
	if dataRemaining == 0 and !currentlySearching:
		currentlySearching = true
		$DataSearchingTimer.start()
		$DataSearchingTimerLabel.visible = true
	if currentlySearching:
		$DataSearchingTimerLabel.text = str(ceil($DataSearchingTimer.time_left))

func _on_data_searching_timer_timeout() -> void:
	$DataSearchingTimer.stop()
	retrieveData()
