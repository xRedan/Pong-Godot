extends Panel

## Buttons
@onready var menu: Button = $VBoxContainer/MarginContainer/GridContainer/Menu
@onready var exit: Button = $VBoxContainer/MarginContainer/GridContainer/Exit
@onready var game_over: Label = $MarginContainer/GameOver

## Effects Manager
var efct_manager: EffectsManager = null 

#/
## READY.
func _ready() -> void:
	SignalBus.end_game.connect(_on_end_game)
	
	menu.pressed.connect(_on_menu_pressed)
	exit.pressed.connect(_on_exit_pressed)
	
	menu.mouse_entered.connect($Select.play)
	exit.mouse_entered.connect($Select.play)
	
	efct_manager = GlobalVar.get_effects_manager() as EffectsManager
	efct_manager.active_effect(efct_manager.effects.blur)

#/
## Cambio il testo della label in base al vincitore.
func _on_end_game(victory: bool) -> void:
	if victory:
		game_over.text = "Player 1 Won!"
	else:
		game_over.text = "Player 2 Won!"

#/
## Se viene premuto il tasto menu, tolgo la pausa
## disabilito l'effetto e cambio scena.
func _on_menu_pressed() -> void:
	$Click.play()
	await get_tree().create_timer(0.18).timeout
	get_tree().paused = false
	efct_manager.disable_effect(efct_manager.effects.blur)
	get_tree().change_scene_to_file(GlobalVar.MAIN_MENU_PATH)

#/
## Se viene premuto il tasto exit, chiudo il gioco.
func _on_exit_pressed() -> void:
	$Click.play()
	await get_tree().create_timer(0.18).timeout
	get_tree().quit()
