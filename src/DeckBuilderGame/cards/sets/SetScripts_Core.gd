# See README.md
extends Reference

# This fuction returns all the scripts of the specified card name.
#
# if no scripts have been defined, an empty dictionary is returned instead.
func get_scripts(card_name: String) -> Dictionary:
	var scripts := {
		"Test Card 1": {
			"manual": {
				"board": [
					{
						"name": "rotate_card",
						"subject": "self",
						"degrees": 90,
					}
				],
				"hand": [
					{
						"name": "spawn_card",
						"card_name": "Spawn Card",
						"board_position": Vector2(500,200),
					}
				]
			},
		},
		"Test Card 2": {
			"manual": {
				"board": [
					{
						"name": "move_card_to_container",
						"subject": "target",
						"dest_container": cfc.NMAP.discard,
					},
					{
						"name": "move_card_to_container",
						"subject": "self",
						"dest_container": cfc.NMAP.discard,
					}
				],
				"hand": [
					{
						"name": "custom_script",
					}
				]
			},
		},
		"Oro": {
			"card_moved_to_board": {
				"trigger": "self",
				"filter_source": cfc.NMAP["hand"],
				"filter_destination": cfc.NMAP["board"],
				"board": [
					{
						"name": "mod_counter",
						SP.KEY_COUNTER_NAME: "oro",
						SP.KEY_MODIFICATION: 1
					},
#					{
#						"name": "move_card_to_container",
#						"subject": "self",
#						"dest_container": cfc.NMAP["discard"],
#					}
				]
			}
		},
		"Rubí": {
			"card_moved_to_board": {
				"trigger": "self",
				"filter_source": cfc.NMAP["hand"],
				"filter_destination": cfc.NMAP["board"],
				"board": [
					{
						"name": "mod_counter",
						SP.KEY_COUNTER_NAME: "oro",
						SP.KEY_MODIFICATION: 2
					},
				]
			}
		},
		"Gema de Fuego" : {
			"manual": {
				"trigger": "self",
				"filter_source": cfc.NMAP['discard'],
				"board": [
					{
						"name": "move_card_to_container",
						"subject": "self",
						"dest_container": cfc.NMAP["deck"],
					}
				]
			},
			"card_moved_to_board": {
				"trigger": "self",
				"filter_source": cfc.NMAP["hand"],
				"filter_destination": cfc.NMAP["board"],
				"board": [
					{
						"name": "mod_counter",
						SP.KEY_COUNTER_NAME: "oro",
						SP.KEY_MODIFICATION: 2
					},
					{
						"is_optional_task": true,
						"dialog_text": "¿Deseas sacrificar esta carta para obtener dos puntos de daño?",
						"name": "custom_script",
						"function": "sacrifice_fire_gem",
						"subject": "self",
						"dest_container": cfc.NMAP["gempile"],
						SP.KEY_COUNTER_NAME: "dano",
						SP.KEY_MODIFICATION: 2
					}
				]
			},
		},
		"Daga" : {
			"card_moved_to_board": {
				"trigger": "self",
				"filter_source": cfc.NMAP["hand"],
				"filter_destination": cfc.NMAP["board"],
				"board": [
					{
						"name": "mod_counter",
						SP.KEY_COUNTER_NAME: "dano",
						SP.KEY_MODIFICATION: 1
					},
				]
			}
		},
		"Espada corta" : {
			"card_moved_to_board": {
				"trigger": "self",
				"filter_source": cfc.NMAP["hand"],
				"filter_destination": cfc.NMAP["board"],
				"board": [
					{
						"name": "mod_counter",
						SP.KEY_COUNTER_NAME: "dano",
						SP.KEY_MODIFICATION: 2
					},
				]
			}
		},
	}
	# We return only the scripts that match the card name and trigger
	return(scripts.get(card_name,{}))
