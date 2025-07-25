@tool
extends Node2D

@export var max_score: int = 12

@export var end_game_scene: PackedScene = null

@export var score_area_p1: Area2D = null
@export var score_area_p2: Area2D = null

var victory: bool = false

#/
## TEST DEI WARNING:
## Controllo se ha dei nodi come figli.
## Se ne ha piú di due o meno di due, ritorno un warning.
## Se i nodi non sono di tipo Area2D ritono un warning.
## NOTE: Per far si che funzioni deve esserci @tool.
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	var REQ_CHILDREN: Array[bool]
	
	for child in get_children():
		if child is Area2D:
			REQ_CHILDREN.push_back(true)
	
	if get_children().size() > 2:
		warnings.push_back("Il limite massimo di nodi é 2.")
	
	if REQ_CHILDREN. size() < 2:
		warnings.push_back("Aggiungi come figli due nodi Area2D.")
	
	return warnings

#/
## READY.
func _ready() -> void:
	if not Engine.is_editor_hint():
		score_area_p2.body_entered.connect(_on_score.bind(GlobalVar.Players.PLAYER_ONE))
		score_area_p1.body_entered.connect(_on_score.bind(GlobalVar.Players.PLAYER_TWO))

#/
## Aumenta il punteggio in base a chi ha segnato il punto.
func _on_score(_body: Node2D, scoring_player: GlobalVar.Players):
	if scoring_player == GlobalVar.Players.PLAYER_ONE:
		GlobalVar.player_one_score += 1
	else:
		GlobalVar.player_two_score += 1
	round_restart()

#/
## Restart del round.
func round_restart() -> void:
	if GlobalVar.player_one_score < max_score and GlobalVar.player_two_score < max_score:
		GlobalVar.is_restart = true
		await get_tree().create_timer(0.3).timeout
		SignalBus.emit_restart()
	elif GlobalVar.player_one_score == max_score:
		victory = true
		end_game()
	elif GlobalVar.player_two_score == max_score:
		victory = false
		end_game()


#/
## Una volta raggiunto il max score termino il game.
func end_game() -> void:
	var end_game_menu = end_game_scene.instantiate()
	GlobalVar.get_foreground().add_child(end_game_menu)
	SignalBus.emit_end_game(victory)
	get_tree().paused = true
