extends Control

var eraseEndingText = [
	"Civilisation completely collapsed from losing its data.",
	"Nobody understood where the virus came from.",
	"What remains of humanity is now struggling on Earth, splitted in different factions.",
	"At least now people go outside more often!"
]

var abortEndingText = [
	"Everybody was surprised that the virus stopped all of a sudden.",
	"Security experts managed to trace back its origin and found its creator.",
	"He just wanted to erase embarissing posts he made on an obscure anime forum years ago. But the virus got out of control.",
	"As punishment he will read these posts out loud in front of a large audience."
]
	
func _on_timer_timeout() -> void:
	$Label.visible_characters = $Label.visible_characters + 1
	if $Label.visible_ratio == 1:
		$Button.visible = true

func _on_button_pressed() -> void:
	var allText
	if Global.eraseEnding:
		allText = eraseEndingText
	else:
		allText = abortEndingText
	if len(allText) == 0:
		get_tree().quit()
	else:
		$Button.visible = false
		$Label.visible_characters = 0
		$Label.text = allText.pop_front()
