## ATTENTION: 
## Non sono sicuro che tutto il sistema di restart e pausa siano realmente 
## fatti bene. Funziona tutto, ma qualcosa mi dice che si potrebbe fare meglio.
extends Node2D

@export var pause_scene: PackedScene = null
@export var restart_countdown: CountDownLabel = null 
@export var restart_time: float = 3.0 # Quante volte dovrá essere ripetuto il Timer.

#/
## READY.
func _ready() -> void:	
	SignalBus.restart.connect(_on_restart)
	restart_countdown.timer_end.connect(_on_count_down_timer_end)
	restart_countdown.visible = false # Imposto il countodown invisibile.
	_on_restart() # Resetto tutte le entitá e starto il timer.
	GlobalVar.reset_score() # Resetto il punteggio.

#/
## Controllo se l'azione pausa é stata premuta e che il gioco non sia in restart.
## Dopo di che se il gioco non é in pausa proseguo a metterlo e ad aggiungere
## come classe figlio il nodo "pause_menu", se é in pausa la tolgo chiamando
## una funzione interna al nodo pause_menu.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and !GlobalVar.is_restart:
		if !get_tree().paused:
			$"../PauseOn".play()
			$"../AnimationPlayer".play("Decrease")
			var pause = pause_scene.instantiate()
			GlobalVar.get_foreground().add_child(pause)
			pause.tree_exited.connect($"../AnimationPlayer".play.bind("Increase"))
		elif get_tree().paused and GlobalVar.get_foreground().get_node("PauseMenu"):
			GlobalVar.get_foreground().get_node("PauseMenu")._on_resume_pressed()

#/
## Quando viene emetto il segnale "restart" verrá eseguita questa funzione.
## Procede con resettare tutte le entitá, mettere il gioco in pausa
## e startare il timer con il valore scelto.
func _on_restart() -> void:
	GlobalVar.is_restart = true
	set_pause(true)
	entity_reset()
	restart_countdown.start_timer(restart_time)

#/
## Una volta scaduto il timer tolgo la pausa.
func _on_count_down_timer_end() -> void:
	set_pause(false)
	GlobalVar.is_restart = false

#/
## Imposto la visibilitá del countdown e la pausa.
func set_pause(b: bool) -> void:
	restart_countdown.visible = b
	get_tree().paused = b

#/
## Cerco in tutte le entity all'interno dell'entity container
## se hanno un metodo "reset" lo chiamo.
func entity_reset() -> void:
	for entity in GlobalVar.get_entity_container().get_children():
		if entity.has_method("reset"):
			entity.reset()
