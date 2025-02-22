extends Node2D

var upgradeIdentifier
signal upgrade_purchased

func _on_button_mouse_entered() -> void:
	$Label.visible = true

func _on_button_mouse_exited() -> void:
	$Label.visible = false

func _on_button_pressed() -> void:
	emit_signal("upgrade_purchased", upgradeIdentifier)
	queue_free()

func setProperties(buttonText, labelText, identifier) -> void:
	$Button.text = buttonText
	$Label.text = labelText
	upgradeIdentifier = identifier
