extends Pile


signal draw_card(deck)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not cfc.are_all_nodes_mapped:
		yield(cfc, "all_nodes_mapped")
	# warning-ignore:return_value_discarded
	$Control.connect("gui_input", self, "_on_Deck_input_event")

func _on_Deck_input_event(event) -> void:
	# TODO: update to check for godot input event instead of get_button_index
	if event.is_pressed()\
		and not cfc.game_paused\
		and event.get_button_index() == 1:
		var card: Card = self.get_top_card()
		if (DBGUtils.buy_card(card)):
			card.move_to(cfc.NMAP["discard"])
