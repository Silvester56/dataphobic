extends Node2D
@export var Data: PackedScene

var dataHandlingCapacity: int = 16
var dataRemaining: int = 1
var dataSearchingTime = 3
var currentlySearching = false

func retrieveData():
	var tmpData
	for i in range(0, sqrt(dataHandlingCapacity)):
		for j in range(0, sqrt(dataHandlingCapacity)):
			tmpData = Data.instantiate()
			tmpData.connect("data_erased", _on_data_erased)
			tmpData.setPostion(position.x + j * 30, position.y + i * 30)
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
