# This class contains very custom scripts definitionsa for objects that need them
#
# The definition happens via object name
class_name CustomScripts
extends Reference

var costs_dry_run := false

func _init(_dry_run) -> void:
	costs_dry_run = _dry_run
# This fuction executes custom scripts
#
# It relies on the definition of each script being based the object's name
# Therefore the only thing we need, is the object itself to grab its name
# And to have a self-reference in case it affects itself
#
# You can pass a predefined subject, but it's optional.
func custom_script(script: ScriptObject) -> void:
	var card: Card = script.owner
	var subjects: Array = script.subjects
	# I don't like the extra indent caused by this if, 
	# But not all object will be Card
	# So I can't be certain the "canonical_name" var will exist
	call(script.get_property(SP.KEY_FUNC_NAME), script)
	match script.owner.canonical_name:
		"Test Card 2":
			# No demo cost-based custom scripts
			if not costs_dry_run:
				print("This is a custom script execution.")
				print("Look! I am going to destroy myself now!")
				card.queue_free()
				print("You can do whatever you want here.")
		"Test Card 3":
			if not costs_dry_run:
				print("This custom script uses the _find_subject()"
						+ " to find a convenient target")
				for subject in subjects:
					subjects[0].queue_free()
					print("Destroying: " + subjects[0].canonical_name)

# warning-ignore:unused_argument
func custom_alterants(script: ScriptObject) -> int:
	var alteration := 0
	return(alteration)

func generate_resource(script: ScriptObject) -> void:
	print("Generar ", script.get_property(SP.KEY_AMOUNT), " de ", script.get_property(SP.KEY_TYPE))
	pass

func spend_resource(script: ScriptObject) -> void:
	var card: Card = script.owner
	var parent = card.get_parent()
	print(cfc.NMAP["board"].counters.get_counter("oro"))
	pass

func sacrifice_fire_gem(script: ScriptObject) -> void:
	if not script.is_accepted:
		return
	var card: Card = script.owner
	var dest_container: CardContainer = script.get_property(SP.KEY_DEST_CONTAINER)
	var tags: Array = ["Scripted"] + script.get_property(SP.KEY_TAGS)
	
	var counter_name: String = script.get_property(SP.KEY_COUNTER_NAME)
	var modification = script.get_property(SP.KEY_MODIFICATION)
	
	card.move_to(dest_container,-1, null, tags)
	
	cfc.NMAP.board.counters.mod_counter(
			counter_name,
			modification,
			false,
			false,
			script.owner,
			tags)
	pass

func buy_card_from_market(script: ScriptObject) -> void:
	var card: Card = script.owner
	var cost = card.get_property("Cost")
	if (DBGUtils.buy_card(card)):
		card.scripts = {}
		card.move_to(cfc.NMAP["discard"])
		cfc.NMAP.market.draw_card(cfc.NMAP.maindeck)
	pass
