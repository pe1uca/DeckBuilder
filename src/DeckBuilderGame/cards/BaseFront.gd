extends "res://src/DeckBuilderGame/CardFront.gd"

func _ready():
	card_labels["Cost"] = $Margin/CardText/HB/Cost
	._ready()
