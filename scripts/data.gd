extends Node2D

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		print("click")
		queue_free()

func setPostion(x: int, y: int) -> void:
	position.x = x
	position.y = y
