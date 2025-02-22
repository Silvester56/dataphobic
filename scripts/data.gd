extends Node2D

signal data_erased
var spriteOpacityPercentage: float = 100
var spriteOpacityPercentageDelta: float = -2
var blinking = false

func _process(delta: float) -> void:
	if blinking:
		spriteOpacityPercentage = spriteOpacityPercentage + spriteOpacityPercentageDelta
	if spriteOpacityPercentage == 50:
		spriteOpacityPercentageDelta = 2
	elif spriteOpacityPercentage == 100:
		spriteOpacityPercentageDelta = -2
	$Area2D/Sprite2D.self_modulate.a = spriteOpacityPercentage / 100
	
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		emit_signal("data_erased", event)
		queue_free()

func setPostionAndScale(x: int, y: int, s: int) -> void:
	scale.x = s
	scale.y = s
	position.x = x
	position.y = y


func _on_area_2d_mouse_entered() -> void:
	blinking = true

func _on_area_2d_mouse_exited() -> void:
	blinking = false
	spriteOpacityPercentage = 100
	spriteOpacityPercentageDelta = -2
	$Area2D/Sprite2D.self_modulate.a = 1
	
