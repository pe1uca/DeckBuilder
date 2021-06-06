extends "res://src/DeckBuilderGame/cards/BaseFront.gd"

func _ready():
	print("Ready creature front!")
	card_labels["Health"] = $Margin/CardText/HB/Health
	._ready()

