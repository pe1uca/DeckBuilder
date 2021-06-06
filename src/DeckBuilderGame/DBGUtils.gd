class_name DBGUtils
extends Node


static func can_buy_card(card: Card) -> bool:
	var counters: Counters = cfc.NMAP["board"].counters
	return counters.mod_counter("oro", -card.get_property("Cost"), false, true) ==\
		CFConst.ReturnCode.CHANGED 

static func buy_card(card: Card) -> bool:
	if can_buy_card(card):
		var counters: Counters = cfc.NMAP["board"].counters
		counters.mod_counter(
			"oro", 
			-card.get_property("Cost"), 
			false, 
			false,
			null,
			["Manual", "Buy"])
		return true
	return false

static func node_exists(node):
	if node == null:
		return false
	if !is_instance_valid(node):
		return false
	if node.is_queued_for_deletion():
		return false
	
	var ref = weakref(node).get_ref()
	
	if ref == null:
		return false
	if ref.is_queued_for_deletion():
		return false
	return true
	pass

static func queue_free_object(node):
	if node_exists(node):
		node.queue_free()
		pass
	pass
