extends Hand

func _ready():
	$Counters.visible = false

# Calls parent to take the top card from the specified [CardContainer]
# and add it to this node
# also adds special listener to buy card
# Returns a card object drawn
func draw_card(pile : Pile = cfc.NMAP.deck) -> Card:
	var card: Card = .draw_card(pile)
	card.scripts = {
		"manual": {
			"hand": [
				{
					"name": "custom_script",
					"function": "buy_card_from_market"
				}
			]
		}
	}
	return card
