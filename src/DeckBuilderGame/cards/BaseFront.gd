extends "res://src/DeckBuilderGame/CardFront.gd"

func _ready():
	print("Ready base front!")
	card_labels["Cost"] = $Margin/CardText/HB/Cost
	._ready()
