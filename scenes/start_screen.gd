extends Control

const POP_UP = preload("res://scenes/pop_up.tscn")
const COMMANDS = preload("res://scenes/controls.tscn")

@export var mode_scene: PackedScene = null

var effects_mixer = AudioServer.get_bus_index("Effects")
var music_mixer   = AudioServer.get_bus_index("Music")

var music_active = true;
var effects_active = true;

@onready var start: Button = %Start ## Start button.
@onready var exit: Button = %Exit 	## Exit button.
@onready var music: TextureButton = $VBoxContainer/MarginContainer2/GridContainer/Music ## Music button.
@onready var sound: TextureButton = $VBoxContainer/MarginContainer2/GridContainer/Sound ## Sound button.
@onready var help: TextureButton = $VBoxContainer/MarginContainer2/GridContainer/Help

@onready var effects_manager: EffectsManager = $EffectsManager as EffectsManager

#/
## READY.
func _ready() -> void:
	## Buttons.
	start.pressed.connect(_on_start_pressed)
	exit.pressed.connect(_on_exit_pressed)
	music.pressed.connect(_on_music_pressed)
	sound.pressed.connect(_on_sound_pressed)
	help.pressed.connect(_on_help_pressed)
	
	music.mouse_entered.connect($Select.play)
	sound.mouse_entered.connect($Select.play)
	help.mouse_entered.connect($Select.play)
	start.mouse_entered.connect($Select.play)
	exit.mouse_entered.connect($Select.play)

#/
## Cambio scena.
func _on_start_pressed() -> void:
	$Click.play()
	if(mode_scene):
		var select_mode = mode_scene.instantiate()
		add_child(select_mode)
		
		## Effect manager.
		effects_manager.visible = true
		effects_manager.active_effect(effects_manager.effects.blur)
		
		## Result aspettare un risultato boolean inviato dal segnale confirmation_result del nodo pop_up.
		var result = await select_mode.change_scene
		if result:
			select_mode.queue_free()
			effects_manager.disable_effect(effects_manager.effects.blur)
			get_tree().change_scene_to_file("res://scenes/level_1.tscn")
		else:
			select_mode.queue_free()
			effects_manager.disable_effect(effects_manager.effects.blur)

#/
## Chiudo il gioco.
func _on_exit_pressed() -> void:
	# Riproduco un suono.
	$Click.play()
	## Pop-Up per confermare l'uscita.
	var pop_up_istance = POP_UP.instantiate()
	add_child(pop_up_istance)
	
	## Effect manager.
	effects_manager.visible = true
	effects_manager.active_effect(effects_manager.effects.blur)
	
	## Result aspettare un risultato boolean inviato dal segnale confirmation_result del nodo pop_up.
	var result = await pop_up_istance.confirmation_result
	if result:
		## True -> chiudo il gioco.
		get_tree().quit()
	else:
		## False -> elimino il pop-up e disabilito gli effetti.
		pop_up_istance.queue_free()
		effects_manager.disable_effect(effects_manager.effects.blur)

#/
## Quando viene premuto il tasto music.
func _on_music_pressed() -> void:
	music_active = !music_active
	AudioServer.set_bus_mute(music_mixer, !music_active)

#/
## Quando viene premuto il tasto sound.
func _on_sound_pressed() -> void:
	effects_active = !effects_active
	AudioServer.set_bus_mute(effects_mixer, !effects_active)

#/
##
func _on_help_pressed() -> void:
	$Click.play()
	var controls_instance = COMMANDS.instantiate()
	add_child(controls_instance)
	
	## Effect manager.
	effects_manager.visible = true
	effects_manager.active_effect(effects_manager.effects.blur)
	
	controls_instance.tree_exited.connect(effects_manager.disable_effect.bind(effects_manager.effects.blur))
	

func music_off() -> void:
	$AnimationPlayer.play("EndMusic")
	await get_tree().create_timer(0.5).timeout
