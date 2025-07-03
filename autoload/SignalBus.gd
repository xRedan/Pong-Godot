extends Node

signal score_update
signal restart
signal end_game(victory: bool)

func emit_score_update() -> void:
	score_update.emit()


func emit_restart() -> void:
	restart.emit()


func emit_end_game(victory: bool) -> void:
	end_game.emit(victory)
