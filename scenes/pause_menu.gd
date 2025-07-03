class_name PauseMenu extends Panel

# Pulsanti.
@onready var resume: Button = $MarginContainer/VBoxContainer/Resume
@onready var menu: Button = $MarginContainer/VBoxContainer/Menu
@onready var exit: Button = $MarginContainer/VBoxContainer/Exit

# EffectManager.
var efct_manager: EffectsManager = null 

#/
## READY.
func _ready() -> void:
	# Connetto i pulsanti.
	resume.pressed.connect(_on_resume_pressed)
	menu.pressed.connect(_on_menu_pressed)
	exit.pressed.connect(_on_exit_pressed)
	
	# Riproduco un suono se ci passo il mouse sopra.
	resume.mouse_entered.connect($Select.play)
	menu.mouse_entered.connect($Select.play)
	exit.mouse_entered.connect($Select.play)
	
	# Setto la pausa.
	get_tree().paused = true
	
	# Attivo l'effetto blur.
	efct_manager = GlobalVar.get_effects_manager() as EffectsManager
	efct_manager.active_effect(efct_manager.effects.blur)

#/
## Alla pressione del tasto "RESUME" aspetto che venga riprodotto il suono
## e proseguo togliendo la pausa, disabilitando l'effetto e facendo il queue_free del nodo.
func _on_resume_pressed() -> void:
	$PauseOff.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().paused = false
	efct_manager.disable_effect(efct_manager.effects.blur)
	queue_free()

#/
## Alla pressione del tasto "MENU" aspetto che venga riprodotto il suono,
## tolgo la pausa, rimuovo l'effetto e cambio scena con quella del menú iniziale.
func _on_menu_pressed() -> void:
	$Click.play()
	await get_tree().create_timer(0.18).timeout
	get_tree().paused = false
	efct_manager.disable_effect(efct_manager.effects.blur)
	get_tree().change_scene_to_file(GlobalVar.MAIN_MENU_PATH)

#/
## Alla pressione del pulsante "EXIT" aspetto che venga riprodotto il suono e chiudo il gioco.
func _on_exit_pressed() -> void:
	$Click.play()
	await get_tree().create_timer(0.18).timeout
	get_tree().quit()
