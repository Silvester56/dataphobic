extends Control

var allText = [
	"Haha yes, it's alive!",
	"The first ever sentient computer virus, and I created it!",
	"What a genius hehe.",
	"Go my child, do what you have to do!"
]

func _on_timer_timeout() -> void:
	$Label.visible_characters = $Label.visible_characters + 1
	if $Label.visible_ratio == 1:
		$Button.visible = true

func _on_button_pressed() -> void:
	if len(allText) == 0:
		get_tree().change_scene_to_file("res://scenes/game.tscn")
	else:
		$Button.visible = false
		$Label.visible_characters = 0
		$Label.text = allText.pop_front()
