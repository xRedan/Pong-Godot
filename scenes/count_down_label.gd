class_name CountDownLabel
extends Label

signal timer_end
signal update_text

# Constants.
const T: float = 0.5 # Durata del timer in secondi.

# Non é la "vera" durata del timer, é quante volte verrá ripetuto.
# Quindi se T é 0.5 e wait_timer_value 3, in totale saranno 1,5 secondi.
# Dove ad ogni 0.5 secondi compierai una determinata azione.
var wait_timer_value: float:
	set(value):
		wait_timer_value = value
		update_text.emit()

# Onready variables.
@onready var timer: Timer = $Timer

#/
## READY.
func _ready() -> void:
	timer.wait_time = T # Setto il wait time.
	timer.timeout.connect(_on_wait_timer_timeout)
	update_text.connect(_on_update_text)

#/
## Ogni qualvolta viene aggiornato wait_timer_value viene chiamata questa funzione.
func _on_update_text() -> void:
	if wait_timer_value < 1: # Get ready invece di 0.
		$EndBeep.play()
		text = "Get ready!"
	else: # Stampo 3, 2, 1.
		$Beep.play(0.12)
		text = str(wait_timer_value).pad_decimals(0)

#/
## Restarto il time finché wait_timer_value arriva a 0.
func _on_wait_timer_timeout() -> void:
	if wait_timer_value == 0:
		timer_end.emit()
	else:
		wait_timer_value -= 1
		timer.start()

#/
## Metodo per startare il timer, value sará quante volte verrá ripetuto il timer.
func start_timer(value: float) -> void:
	wait_timer_value = value
	timer.start()
