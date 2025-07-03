extends Control

@onready var player_one_points: Label = %PlayerOnePoints
@onready var player_two_points: Label = %PlayerTwoPoints

#/
## READY.
func _ready() -> void:
	# Connetto il segnale "score_update" alla funzione per aggiornare il punteggio.
	SignalBus.score_update.connect(_on_score_update) 

#/
## Aggiorno la label con il valore attualmente dei punteggi.
func _on_score_update(player: GlobalVar.Players) -> void:
	match player:
		GlobalVar.Players.PLAYER_ONE:
			player_one_points.text = str(GlobalVar.player_one_score)
		GlobalVar.Players.PLAYER_TWO:
			player_two_points.text = str(GlobalVar.player_two_score)
