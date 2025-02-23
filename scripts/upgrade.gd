extends Control

signal upgrade_purchased

var upgradeIdentifier
var intelCost
var description

func checkButtonEnabling(totalIntel) -> void:
	if intelCost > 0:
		$Button.disabled = totalIntel < intelCost

func _on_button_mouse_entered() -> void:
	get_parent().changeDescription(description)

func _on_button_mouse_exited() -> void:
	get_parent().changeDescription("")

func _on_button_pressed() -> void:
	emit_signal("upgrade_purchased", upgradeIdentifier, intelCost)
	queue_free()

func setProperties(buttonText, labelText, identifier, inCo) -> void:
	$Button.text = buttonText
	description = labelText
	if inCo > 0:
		description = description + " (Cost " + str(inCo) + " INTEL)"
	upgradeIdentifier = identifier
	intelCost = inCo
