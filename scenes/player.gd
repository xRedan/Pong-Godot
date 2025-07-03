class_name Player
extends CharacterBody2D

#region ENUMS
enum PlayersType {
	PLAYER_ONE,
	PLAYER_TWO,
}
#endregion

#region CONSTANTS
# Precaricamento della UI del dash.
const DASH_LOADER_BAR = preload(GlobalVar.DASH_LOADER_PATH)
#endregion

#region EXPORT VARIABLES
@export_category("Player Variables")
# Selezione della tipologia del player.
@export var select_player = PlayersType.PLAYER_ONE

@export var disabled: bool = false

# Controls.
@export var controls: Dictionary = {
	"UP":		"move_up",
	"DOWN": 	"move_down",
	"DASH":		"move_dash",
}

@export_subgroup("Player Variables")
@export var mov_speed: float = 850.0 # Velocitá del player.

@export_subgroup("Dash Variables")
@export var dash_speed: float = 1200.0 # Velocitá del dash.
@export var dash_duration: float = 0.3 # Durata del dash.
@export var dash_cooldown: float = 1.0 # Cooldown del dash.

@export_subgroup("Dash ui Colors")
@export var dash_ui_tint_under: = Color.WHITE 	 # Background della dash ui.
@export var dash_ui_tint_over: = Color.WHITE  	 # Il borso della dash ui.
@export var dash_ui_tint_progress: = Color.WHITE # L'interno della dash ui che sará quello che effettivamente si animerá.
#endregion

#region LOCAL VARIABLES
# Shortcut per ottenere la grandezza del rettangolo della collisionshape.
var rect_size: Vector2:
	get:
		return $CollisionShape2D.shape.get_rect().size

# Posizione iniziale del player.
var player_starting_pos: = Vector2.ZERO

# Posizione iniziale della dash loader bar.
var dash_ui_starting_pos: Vector2 = Vector2.ZERO

# Direzione.
var direction: float = 0.0 

var dash_loader_ui_instance: DashLoaderBar = null
#endregion

#region ONREADY VARIABLES
@onready var input_module: InputModule = $InputModule as InputModule
@onready var dash_module: DashModule = $DashModule as DashModule
#endregion

#/
## READY.
func _ready() -> void:
	if(GlobalVar.select_mode == GlobalVar.Mode.VERSUS):
		disabled = false
	else:
		disabled = true
		
	modify_settings()
	set_player_starting_pos()
	set_dash_ui_starting_pos()
	set_dash_ui()
	input_module.set_controls(controls)

#/
## PHYSICS PROCESS.
func _physics_process(delta: float) -> void:
	if !disabled or select_player == PlayersType.PLAYER_ONE:
		if input_module.handle_dash_input() and not dash_module.get_is_dashing(): # Se il tasto per effetuare il dash é stato premuto:
			dash_module.handle_dash() # Effetua il dash.
	
		direction = input_module.handle_move_inputs() # Ritorna un valore float in base ai tasti premuti.
	
		if direction: # Se direction é diverssa da zero:
			# Lerp di direction * player_speed, moltiplico il peso per delta per renderlo indipendete.
			velocity.y = lerp(velocity.y, direction * mov_speed, delta * 6.5)
		else:
			velocity.y = 0
		
		move_and_slide()

#/
## Setto la posizione del player centrato nell'asse y.
func set_player_starting_pos() -> void:
	var x_offset: int = 75 # Margine orizzontale.
	var y_offset: int = 75 # Margine verticale.
	if !disabled or select_player == PlayersType.PLAYER_ONE:
		var viewport_size = get_viewport().get_visible_rect().size # Size della finestra.
	
		if select_player == PlayersType.PLAYER_ONE:
			player_starting_pos = Vector2(x_offset, viewport_size.y/2)
		elif select_player == PlayersType.PLAYER_TWO:
			player_starting_pos = Vector2(viewport_size.x - x_offset, viewport_size.y/2)
		
		position = player_starting_pos
	else:
		player_starting_pos = Vector2(-500, -500)
		position = player_starting_pos
#/
## Setto la posizione della dash ui.
func set_dash_ui_starting_pos() -> void:
	if !disabled or select_player == PlayersType.PLAYER_ONE:
		var viewport_size = get_viewport().get_visible_rect().size # Size della finestra.
		var x_offset: int = 75 # Margine orizzontale.
		var y_offset: int = 75 # Margine verticale.
	
		if select_player == PlayersType.PLAYER_ONE:
			dash_ui_starting_pos = Vector2(viewport_size.x/4, y_offset)
		elif select_player == PlayersType.PLAYER_TWO:
			dash_ui_starting_pos = Vector2(viewport_size.x - viewport_size.x/4, y_offset)

#/
## Istanza dell'ui della dash loader.
func set_dash_ui() -> void:
	if !disabled or select_player == PlayersType.PLAYER_ONE:
		# Istanzio la scena.
		dash_loader_ui_instance = DASH_LOADER_BAR.instantiate()
		# Set della posizione.
		dash_loader_ui_instance.position = dash_ui_starting_pos
		# Collego il dash_module per il corretto funzionamento.
		dash_loader_ui_instance.dash_module = dash_module
		# Lo aggiungo come scena figlio del background
		GlobalVar.get_background().add_child(dash_loader_ui_instance)
	
		# Set delle tinte
		dash_loader_ui_instance.tint_under = dash_ui_tint_under
		dash_loader_ui_instance.tint_over = dash_ui_tint_over
		dash_loader_ui_instance.tint_progress = dash_ui_tint_progress

#/
## Metodo placeholder per permettere di modificare determinati parametri durante la chiamata alla func _ready.
func modify_settings() -> void:
	pass

#/
## Reset della posizione.
func reset() -> void:
	position = player_starting_pos
