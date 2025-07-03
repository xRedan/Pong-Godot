class_name InputModule
extends Node2D

## CONTROLS
var CONTROLS: Dictionary = {
	"UP":		"move_up",
	"DOWN": 	"move_down",
	"DASH":		"move_dash",
}

#/
## Ritorno un valore float: -1 (move_up) 0 (null) 1 (move_down).
func handle_move_inputs() -> float:
	return Input.get_axis(CONTROLS["UP"], CONTROLS["DOWN"])

#/
## Check se il tasto é stato premuto.
func handle_dash_input() -> bool:
	return Input.is_action_just_pressed(CONTROLS["DASH"])

#/
## Set dei comandi (possibilmente da rivedere).
func set_controls(dict: Dictionary) -> void:
	CONTROLS = dict
