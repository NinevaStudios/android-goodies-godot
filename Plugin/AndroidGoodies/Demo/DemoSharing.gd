extends Node

onready var image = (load("res://icon.png") as Texture).get_data()

var sharer = AGShare.new()

const chooser_title = "Choose your destiny..."

func _onShareTextButtonClicked():
	sharer.share_text("Android Goodies", "Text message", true, chooser_title)

func _onShareTextWithImageButtonClicked():
	sharer.share_text_with_image("Android Goodies", "Text message", image, true, chooser_title)
