# Code for a sample playspace, you're expected to provide your own ;)
extends Board

var isMarketFocused = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	counters = $Counters
	cfc.map_node(self)
	# We use the below while to wait until all the nodes we need have been mapped
	# "hand" should be one of them.
	# We're assigning our positions programmatically,
	# instead of defining them on the scene.
	# This way any they will work with any size of viewport in a game.
	# Discard pile goes bottom right
	$FancyMovementToggle.pressed = cfc.game_settings.fancy_movement
	$OvalHandToggle.pressed = cfc.game_settings.hand_use_oval_shape
	$ScalingFocusOptions.selected = cfc.game_settings.focus_style
	$Debug.pressed = cfc._debug
	# Fill up the deck for demo purposes
	if not cfc.ut:
		cfc.game_rng_seed = CFUtils.generate_random_seed()
		$SeedLabel.text = "Game Seed is: " + cfc.game_rng_seed
	if not get_tree().get_root().has_node('Gut'):
		# load_test_cards($Deck)
		load_test_cards($MainDeck, 20)
	
	for x in range(5):
		cfc.NMAP.market.draw_card(cfc.NMAP.maindeck)
	# warning-ignore:return_value_discarded
	load_base_deck($Deck)
	load_fire_gems($GemPile)


# This function is to avoid relating the logic in the card objects
# to a node which might not be there in another game
# You can remove this function and the FancyMovementToggle button
# without issues
func _on_FancyMovementToggle_toggled(_button_pressed) -> void:
#	cfc.game_settings.fancy_movement = $FancyMovementToggle.pressed
	cfc.set_setting('fancy_movement', $FancyMovementToggle.pressed)


func _on_OvalHandToggle_toggled(_button_pressed: bool) -> void:
	cfc.set_setting("hand_use_oval_shape", $OvalHandToggle.pressed)
	for c in cfc.NMAP.hand.get_all_cards():
		c.reorganize_self()


# Reshuffles all Card objects created back into the deck
func _on_ReshuffleAllDeck_pressed() -> void:
	reshuffle_all_in_pile(cfc.NMAP.discard, cfc.NMAP.deck)


func _on_ReshuffleAllDiscard_pressed() -> void:
	reshuffle_all_in_pile(cfc.NMAP.deck, cfc.NMAP.discard)

func reshuffle_all_in_pile(source = cfc.NMAP.discard, pile = cfc.NMAP.deck):
	for c in source.get_all_cards():
		if c.get_parent() != pile:
			c.move_to(pile)
			yield(get_tree().create_timer(0.1), "timeout")
	# Last card in, is the top card of the pile
	var last_card : Card = pile.get_top_card()
	if last_card._tween.is_active():
		yield(last_card._tween, "tween_all_completed")
	yield(get_tree().create_timer(0.2), "timeout")
	pile.shuffle_cards()


# Button to change focus mode
func _on_ScalingFocusOptions_item_selected(index) -> void:
	cfc.set_setting('focus_style', index)


# Button to make all cards act as attachments
func _on_EnableAttach_toggled(button_pressed: bool) -> void:
	for c in get_tree().get_nodes_in_group("cards"):
		c.is_attachment = button_pressed


func _on_Debug_toggled(button_pressed: bool) -> void:
	cfc._debug = button_pressed

# Loads a sample set of cards to use for testing
func load_test_cards(pile := $Deck, extras := 11) -> void:
	var test_cards := []
	for ckey in cfc.card_definitions.keys():
		if not ckey in ["Oro", "Rub??", "Espada corta", "Daga", "Gema de Fuego"]:
			test_cards.append(ckey)
	var test_card_array := []
	for _i in range(extras):
		if not test_cards.empty():
			var random_card_name = \
					test_cards[CFUtils.randi() % len(test_cards)]
			test_card_array.append(cfc.instance_card(random_card_name))
	# 11 is the cards GUT expects. It's the testing standard
	if extras == 11:
	# I ensure there's of each test card, for use in GUT
		for card_name in test_cards:
			test_card_array.append(cfc.instance_card(card_name))
	for card in test_card_array:
		pile.add_child(card)
		#card.set_is_faceup(false,true)
		card._determine_idle_state()
	pile.shuffle_cards(false)
		
func load_base_deck(pile := $Deck):
	var card
	for i in range(7):
		card = cfc.instance_card("Oro")
		pile.add_child(card)
		card._determine_idle_state()
	card = cfc.instance_card("Rub??")
	pile.add_child(card)
	card._determine_idle_state()
	card = cfc.instance_card("Espada corta")
	pile.add_child(card)
	card._determine_idle_state()
	card = cfc.instance_card("Daga")
	pile.add_child(card)
	card._determine_idle_state()
	pile.shuffle_cards()

func load_fire_gems(pile := $GemPile):
	for i in range(16):
		var card = cfc.instance_card("Gema de Fuego")
		pile.add_child(card)
		card._determine_idle_state()


func _on_ShowMarket_pressed():
	var market = $Market
	var hand = $Hand
	if isMarketFocused:
		market.placement = CardContainer.Anchors.LEFT_MIDDLE
		market.rotation_degrees = 90
		hand.placement = CardContainer.Anchors.BOTTOM_MIDDLE
		market.re_place()
		hand.re_place()
		isMarketFocused = false
	else:
		market.placement = CardContainer.Anchors.BOTTOM_MIDDLE
		market.rotation_degrees = 0
		hand.placement = CardContainer.Anchors.TOP_MIDDLE
		hand.re_place()
		market.re_place()
		isMarketFocused = true
	pass # Replace with function body.


func _on_EndTurn_pressed():
	# At the end of the turn we clean up the board
	# We send all card that do not have health to the discard
	for c in cfc.NMAP.board.get_all_cards():
		var health = c.get_property("Vida")
		if health == null or health <= 0:
			c.move_to(cfc.NMAP.discard)
			yield(get_tree().create_timer(0.1), "timeout")
	# All un-used card in the hand are also sent to the discard
	for c in cfc.NMAP.hand.get_all_cards():
		c.move_to(cfc.NMAP.discard)
		yield(get_tree().create_timer(0.1), "timeout")
	# Last card in, is the top card of the pile
	var last_card : Card = cfc.NMAP.discard.get_top_card()
	if last_card and last_card._tween.is_active():
		yield(last_card._tween, "tween_all_completed")
	yield(get_tree().create_timer(0.2), "timeout")
	
	# The counters should also be emptied
	# gold and damage should be zeroed
	var counters_list = cfc.NMAP.board.counters.counters
	for c in counters_list:
		cfc.NMAP.board.counters.mod_counter(
			c,
			0,
			true,
			false,
			null,
			["Scripted", "EndTurn"])
	
	# After we finished with the clean up we fill up the hand
	var cards_to_draw := 5
	var deck_size = cfc.NMAP.deck.get_all_cards().size()
	var tmp: Array = []
	# We check if there are less cards that the max we need to draw
	if deck_size < cards_to_draw:
		# We substract the cards that we can draw
		cards_to_draw -= deck_size
		# We draw all the cards from the deck
		for x in range(deck_size):
			cfc.NMAP.hand.draw_card(cfc.NMAP.deck)
			yield(get_tree().create_timer(0.1), "timeout")
		reshuffle_all_in_pile(cfc.NMAP.discard, cfc.NMAP.deck)
	
	# We draw cards until our max
	for x in range(cards_to_draw):
		cfc.NMAP.hand.draw_card(cfc.NMAP.deck)
		yield(get_tree().create_timer(0.1), "timeout")
	
	pass # Replace with function body.
