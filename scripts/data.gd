extends Node2D

signal data_erased

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		emit_signal("data_erased")
		queue_free()

func setPostion(x: int, y: int) -> void:
	position.x = x
	position.y = y
