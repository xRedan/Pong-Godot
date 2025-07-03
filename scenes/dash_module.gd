class_name DashModule extends Node2D

signal dashing(dash_duration: float, dash_cooldown: float)

#region EXPORT VARIABLES
@export var player: Player = null
#endregion

#region LOCAL VARIABLES
var dash_speed: float 	 # Velocitá del dash.
var dash_duration: float # Durata del dash.
var dash_cooldown: float # Cooldown tra un dash e quello successivo.
var is_dashing: bool = false
#endregion

## ONREADY VARIABLES
@onready var dash_cooldown_timer: Timer = $DashCooldown

#/
## READY.
func _ready() -> void:
	dash_cooldown_timer.timeout.connect(_on_dash_cooldown_timeout)
	if player:
		set_dash()

#/
## Allo scadere del timer imposta la variabile is_dashing su false.
func _on_dash_cooldown_timeout() -> void:
	is_dashing = false

#/
## Set della velocitá, durante e cooldown.
func set_dash() -> void:
	dash_speed = player.dash_speed
	dash_duration = player.dash_duration
	dash_cooldown = player.dash_cooldown

#/
## Ritorna is_dashing.
func get_is_dashing() -> bool:
	return is_dashing

#/
## Controllo se non é stato giá effettuato un dash, se é cosí
## sommo alla player_speed la velocitá del dash, avvio un timer
## per aspettare che venga effetuato il dash, dopo di che resetto
## la velocitá a quella iniziale e starto il timer per il cooldown.
func handle_dash() -> void:
	if(!is_dashing):
		$Dash.play()
		is_dashing = true
		var og_speed = player.mov_speed
		player.mov_speed += dash_speed
		dashing.emit(dash_duration, dash_cooldown)
		await  get_tree().create_timer(dash_duration).timeout
		
		player.mov_speed = og_speed
		dash_cooldown_timer.start(dash_cooldown)
