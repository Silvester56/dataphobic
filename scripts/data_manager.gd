extends Node2D
@export var Data: PackedScene

var dataHandlingCapacity = 1
var dataSearchingTime = 3
var currentlySearching = false

func retrieveData():
	print("Searching data")
	for i in range(0, dataHandlingCapacity):
		add_child(Data.instantiate())
	currentlySearching = false

func _ready() -> void:
	retrieveData()

func _process(delta: float) -> void:
	if len(get_children()) == 0 and !currentlySearching:
		currentlySearching = true
		await get_tree().create_timer(dataSearchingTime).timeout
		retrieveData()
