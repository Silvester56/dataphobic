extends Node2D

signal data_erased

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		emit_signal("data_erased")
		queue_free()

func setPostionAndScale(x: int, y: int, s: int) -> void:
	scale.x = s
	scale.y = s
	position.x = x
	position.y = y
