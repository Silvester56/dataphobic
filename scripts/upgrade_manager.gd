extends Node2D

@export var Upgrade: PackedScene

enum upgradeId {
	GRID_4,
	GRID_9,
	GRID_16,
	GRID_25,
	GRID_36,
	GRID_64
}

func createUpgrade(buttonText, labelText, identifier):
	var result = Upgrade.instantiate()
	result.setProperties(buttonText, labelText, identifier)
	result.connect("upgrade_purchased", _on_upgrade_purchased)
	return result

func handleDataErased(totalDataErased) -> void:
	if totalDataErased == 4:
		add_child(createUpgrade("2x2 grid", "Fetch 4 data blocks at once", upgradeId.GRID_4))

func _on_upgrade_purchased(upgradeIdentifier) -> void:
	if upgradeIdentifier == upgradeId.GRID_4:
		get_parent().increaseGridSize(4)
