# This file contains just card definitions. See also `CardConfig.gd`

extends Reference

const SET = "Core Set"
const CARDS := {
	"Oro": {
		"_scene": "Base",
		"Type": "Ítem",
		"Tags": ["Divisa", "Moneda"],
		"Abilities": "Proporciona uno de oro",
		"Cost": 0
	},
	"Rubí": {
		"_scene": "Base",
		"Type": "Ítem",
		"Tags": ["Divisa", "Gema"],
		"Abilities": "Proporciona dos de oro",
		"Cost": 0
	},
	"Espada corta": {
		"_scene": "Base",
		"Type": "Ítem",
		"Tags": ["Arma corto alcance", "Espada"],
		"Abilities": "Proporciona dos puntos de daño",
		"Cost": 0
	},
	"Daga": {
		"_scene": "Base",
		"Type": "Ítem",
		"Tags": ["Arma corto alcance", "Daga"],
		"Abilities": "Proporciona un punto de daño",
		"Cost": 0
	},
	"Gema de Fuego": {
		"_scene": "Base",
		"Type": "Ítem",
		"Tags": ["Divisa", "Gema"],
		"Abilities": "Proporciona dos de oro. Sacrificar: Proporciona tres puntos de daño",
		"Cost": 2
	}
#	"Battle Beast": {
#		"_scene": "Creature",
#		"Type": "Creature",
#		"Tags": ["Brutal", "Slow"],
#		"Abilities": " ",
#		"Cost": 2,
##		"Power": 3,
#		"Health": 3,
#	},
#	"Beast in Black": {
#		"_scene": "Creature",
#		"Type": "Creature",
#		"Tags": ["Fast", "Flanking"],
#		"Abilities": " ",
#		"Cost": 1,
##		"Power": 2,
#		"Health": 1,
#	},
}
