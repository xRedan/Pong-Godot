extends Node

# COMANDI DEL PLAYER.
enum CommandNames {
	UP,
	DOWN,
	DASH,
} 

enum Mode{
	CPU,
	VERSUS,
}


enum Players{
	PLAYER_ONE,
	PLAYER_TWO,
}

# PATH
const DASH_LOADER_PATH: String = "res://scenes/dash_loader_bar.tscn"
const MAIN_MENU_PATH: String = "res://scenes/start_screen.tscn"

# Nome del gruppo a cui appartiene l'entity container.
const ENTITY_CONTAINER: String = "entity_container"
const BACKGROUND: String = "background"
const FOREGROUND: String = "foreground"
const EFFECTS_MANAGER: String = "effects_manager"

# Variabile che tiene conto del punteggio del player one.
# Ha un metodo set che emettere il segnale "score_update"
# che permette di far aggiornare la label con il punteggio.
var player_one_score: int = 0: 
	set(value): 
		player_one_score = value
		last_point = Players.PLAYER_ONE
		SignalBus.emit_score_update(Players.PLAYER_ONE)

# Uguale a sopra ma per il player 2.
var player_two_score: int = 0:
	set(value):
		player_two_score = value
		last_point = Players.PLAYER_TWO
		SignalBus.emit_score_update(Players.PLAYER_TWO)

# Variabile per sapere se il gioco sta restartando.
var is_restart: bool = false

# Selezione della modalitá.
var select_mode: Mode = Mode.CPU

var last_point: Players = Players.PLAYER_ONE

#/
## Metoodo get dell'entity container.
func get_entity_container() -> Node:
	return get_tree().get_first_node_in_group(ENTITY_CONTAINER)

#/
## Metodo get per il background.
func get_background() -> Node:
	return get_tree().get_first_node_in_group(BACKGROUND)

#/
## Get Foreground.
func get_foreground() -> Node:
	return get_tree().get_first_node_in_group(FOREGROUND)

#/
## Get EffectsManager.
func get_effects_manager() -> Node:
	return get_tree().get_first_node_in_group(EFFECTS_MANAGER)

#/
## Reset del punteggio.
func reset_score() -> void:
	player_one_score = 0
	player_two_score = 0
