## Classe PopUp che crea un popup di conferma con due bottoni Y/N.
## Ritorno una boolean tramite un segnale poiché mi serve nello script start_screen
## per agire in base al tasto premuto, cosí da mantenere le dipedenze separate.
## Idealmente potrei collegare questo popup a tutto, e sfruttare il segnale che emette.
class_name PopUp extends Panel

#Signals
signal confirmation_result(result: bool) ## Segnale che ritorna una boolean.

# Local Variables.
var result = false

# OnReady Variables.
@onready var yes_button: Button = $VBoxContainer/MarginContainer/GridContainer/YesButton
@onready var no_button: Button = $VBoxContainer/MarginContainer/GridContainer/NoButton

#/
## READY.
func _ready() -> void:
	# Connetto i pulsanti.
	yes_button.pressed.connect(_on_yes_pressed)
	no_button.pressed.connect(_on_no_pressed)
	
	# Riproduco un suono quando passo col cursore sopra.
	yes_button.mouse_entered.connect($Selection.play)
	no_button.mouse_entered.connect($Selection.play)

#/
## Alla pressione del tasto "YES" riproduco un suono e aspetto che finisca,
## imposto il risultato su true e emetto il segnale passando come argomento result.
func _on_yes_pressed() ->  void:
	$Click.play()
	await get_tree().create_timer(0.18).timeout
	result = true
	confirmation_result.emit(result)

#/
## Alla pressione del tasto "NO" riproduco un suono e aspetto che finisca,
## imposto il risultato su false e emetto il segnale passando come argomento result.
func _on_no_pressed() -> void:
	$Click.play()
	await get_tree().create_timer(0.18).timeout
	result = false
	confirmation_result.emit(result)
