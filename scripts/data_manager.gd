extends Node2D
@export var Data: PackedScene

var dataHandlingCapacity: int = 16
var dataSearchingTime = 3
var currentlySearching = false

func retrieveData():
	print("Searching data")
	var tmpData
	for i in range(0, sqrt(dataHandlingCapacity)):
		for j in range(0, sqrt(dataHandlingCapacity)):
			tmpData = Data.instantiate()
			tmpData.setPostion(position.x + j * 30, position.y + i * 30)
			add_child(tmpData)
	currentlySearching = false

func _ready() -> void:
	retrieveData()

func _process(delta: float) -> void:
	if len(get_children()) == 0 and !currentlySearching:
		currentlySearching = true
		await get_tree().create_timer(dataSearchingTime).timeout
		retrieveData()
