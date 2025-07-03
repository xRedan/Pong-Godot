extends Node

signal score_update(player: GlobalVar.Players)
signal restart
signal end_game(victory: bool)

func emit_score_update(player: GlobalVar.Players) -> void:
	score_update.emit(player)


func emit_restart() -> void:
	restart.emit()


func emit_end_game(victory: bool) -> void:
	end_game.emit(victory)
