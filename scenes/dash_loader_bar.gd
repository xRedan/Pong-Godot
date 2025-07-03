class_name DashLoaderBar extends Control

# Variabiale che dovrá essere assegnata quando si istanzia la classe.
var dash_module: DashModule = null

#region DASH VARIABLES
var dash_duration: float:
	set(value):
		dash_duration = value
		dash_duration_timer.wait_time = value

var dash_cooldown: float:
	set(value):
		dash_cooldown = value
		progress_bar.max_value = value
		progress_bar.value = value
		dash_cooldown_timer.wait_time = value
#endregion

#region TINT
var tint_under: Color:
	set(value):
		tint_under = value
		progress_bar.tint_under = tint_under

var tint_over: Color:
	set(value):
		tint_over = value
		progress_bar.tint_over = tint_over

var tint_progress: Color:
	set(value):
		tint_progress = value
		progress_bar.tint_progress = tint_progress
#endregion

#region ONREADY VARIABLES
@onready var progress_bar: TextureProgressBar = $ProgressBar
@onready var dash_duration_timer: Timer = $DashDuration
@onready var dash_cooldown_timer: Timer = $Cooldown
#endregion

#/
## READY.
func _ready() -> void:
	set_physics_process(false)
	
	if dash_module:
		dash_module.dashing.connect(_on_dashing)
	
	# Imposto la progress bar al massimo del suo valore.
	progress_bar.value = progress_bar.max_value
	
	dash_duration_timer.timeout.connect(_on_dash_duration_timeout)
	dash_cooldown_timer.timeout.connect(_on_dash_cooldown_timeout)

#/
## PHYSICS PROCESS.
func _physics_process(_delta: float) -> void:
	if dash_duration_timer.time_left > 0:
		var t = 1 - (dash_duration_timer.time_left / dash_duration_timer.wait_time)
		progress_bar.value = lerp(progress_bar.max_value, 0.0, t)
	
	elif dash_cooldown_timer.time_left > 0:
		progress_bar.value = dash_cooldown_timer.wait_time - dash_cooldown_timer.time_left
	
	else:
		progress_bar.value = progress_bar.max_value
		set_physics_process(false)

#/
## Funzione che viene chiamata quando si compie un dash.
## Viene passato come parametro la durata del dash e la durata del cooldown.
## Li imposto alle correspettive variabili locali, e starto il timer del dash.
func _on_dashing(_duration: float, _cooldown: float) -> void:
	print("dash")
	set_physics_process(true)
	dash_duration = _duration
	dash_cooldown = _cooldown
	dash_duration_timer.start()

#/
## Al timeout del dash duration timer, setto la progress_bar.value al valore minimo
## per assiurarmi che sia davvero al minimo, poiché potrebbe succedere che non vada precisamente al minimo.
## In fine starto il timer del cooldown.
func _on_dash_duration_timeout() -> void:
	progress_bar.value = progress_bar.min_value
	dash_cooldown_timer.start()

#/
## Setto la progress_bar.value al massimo alla scadenza del timer.
## É un set aggiuntivo perché potrebbe essere che non arrivi precisamente al massimo,
## ma che si fermi poco prima per via del funzionamento di lerp().
func _on_dash_cooldown_timeout() -> void:
	progress_bar.value = progress_bar.max_value
