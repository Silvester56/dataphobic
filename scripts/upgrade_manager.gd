extends Node2D

@export var Upgrade: PackedScene

enum upgradeId {
	GRID_SIZE,
	FETCH_FASTER,
	AUTO_CLICK
}

var gridSizeArray = [4, 9, 16, 25, 36, 64]

func createUpgrade(buttonText, labelText, identifier):
	var result = Upgrade.instantiate()
	result.setProperties(buttonText, labelText, identifier)
	result.connect("upgrade_purchased", _on_upgrade_purchased)
	return result

func handleDataErased(totalDataErased) -> void:
	if totalDataErased == 4:
		add_child(createUpgrade("2x2 grid", "Fetch 4 data blocks at once", upgradeId.GRID_SIZE))
	if totalDataErased == 32:
		add_child(createUpgrade("Anti-lag", "Fetch data blocks slightly faster", upgradeId.FETCH_FASTER))
	if totalDataErased == 48:
		add_child(createUpgrade("Eraserbot", "Autoclick on random data blocks", upgradeId.AUTO_CLICK))
	if totalDataErased == 64:
		add_child(createUpgrade("3x3 grid", "Fetch 9 data blocks at once", upgradeId.GRID_SIZE))

func _on_upgrade_purchased(upgradeIdentifier) -> void:
	if upgradeIdentifier == upgradeId.GRID_SIZE:
		get_parent().increaseGridSize(gridSizeArray.pop_front())
	if upgradeIdentifier == upgradeId.FETCH_FASTER:
		get_parent().speedUpFetching()
	if upgradeIdentifier == upgradeId.AUTO_CLICK:
		get_parent().addEraserbot()
