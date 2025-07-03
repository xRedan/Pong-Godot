# TODO: Fixare il fatto che la palla si blocchi tra il bordo e il player
# TODO: Impostare una direzione randomica iniziale in base al chi ha fatto l'ultimo punto
class_name Ball extends CharacterBody2D

#region CONSTANTS
const INIT_SPEED: float = 600.0 # Velocitá iniziale.
const MAX_SPEED: float = 1600.0 # Velocitá massima.
#endregion

#region CONTROLS
var DEBUG_CONTROLS: Dictionary = {
	ENTER =  		"ui_accept",
	LEFT = 			"debug_left",
	RIGHT = 		"debug_right",
	UP = 			"debug_up",
	DOWN = 			"debug_down",}
#endregion

#region EXPORT VARIABLES
@export var allow_debug = false
@export var audio_streams: Array[AudioStream] 
#endregion

#region VARIABLES
var speed: float # Velocitá locale.
var direction: Vector2 # Direzione.
var debug_mode = false 
#endregion

#/
## READY
func _ready() -> void:
	reset()

#/
## DEBUG
func _input(event: InputEvent) -> void:
	## DEBUG ##
	if event.is_action_pressed(DEBUG_CONTROLS.ENTER):
		if allow_debug:
			debug_mode = !debug_mode
			if !debug_mode:
				direction = Input.get_vector("debug_left", "debug_right", "debug_up", "debug_down")
				if !direction:
					direction = Vector2.LEFT

#/
## Movimento della palla.
func _physics_process(delta: float) -> void:
	#/ DEBUG /#
	if(debug_mode):
		handle_debug_movement()
	#/ END_DEBUG /#
	
	# Effettuo il movimento con la funzione integrata move_and_collide(),
	# inoltre se colliderá con un oggetto ritornerá un KinematicCollision2D.
	var collision = move_and_collide(velocity)
	
	# Se collide con un oggetto:
	if collision: 
		# Calcolo delle collisioni quando collide con il Player.
		if collision.get_collider() is Player :
			# Riproduci un suondo random tra gli indici 0 e 1.
			play_sound(randi_range(0, 1))
			# Applico un attrito minimo.
			speed = speed * 0.8
			
			# Assegno l'oggetto colliso alla variabile.
			var collider = collision.get_collider() as Player 
			
			# Sommo la velocitá del collider a quella della palla.
			speed += abs(collider.get_real_velocity().y/2)
			
			# Check se la velocitá é nel limiti impostati.
			speed = clamp(speed, INIT_SPEED, MAX_SPEED)
			
			# Calcola la nuova direzione Y.
			var distance: float = global_position.y - collider.global_position.y
			var new_dir_y: float = distance / (collider.rect_size.y / 2)
			new_dir_y = clamp(new_dir_y, -1, 1) # Mi assicuro che il valore sia nel range.
			
			# Calcolo la nuova direzione X.
			var new_dir_x = direction.x * -1 
			
			# Assegno le due nuove direzione al vettore direzione.
			direction = Vector2(new_dir_x, new_dir_y).normalized()
		
		# Calcolo delle collisioni quando collide con la CPU.
		elif collision.get_collider() is Cpu:
			play_sound(randi_range(0, 1))
			
			speed = speed * 0.8
			
			var collider = collision.get_collider() as Cpu
			# Calcola la nuova direzione Y.
			var distance: float = global_position.y - collider.global_position.y
			var new_dir_y: float = distance / (collider.rect_size.y / 2)
			new_dir_y = clamp(new_dir_y, -1, 1) # Mi assicuro che il valore sia nel range.
			
			# Calcolo la nuova direzione X.
			var new_dir_x = direction.x * -1 
			
			# Assegno le due nuove direzione al vettore direzione.
			direction = Vector2(new_dir_x, new_dir_y).normalized()
			
			speed += abs(collider.get_real_velocity().y/2)
			
			speed = clamp(speed, INIT_SPEED, MAX_SPEED)
			
		else: # Se collide con tutto il resto (attualmente solo con wall).
			play_sound(2) # Riproduce il suono di rimbalzo sul muro.
			direction = velocity.bounce(collision.get_normal()).normalized() # Rimbalzo.
			global_position += collision.get_normal() * 15 # Margine per il clipping tra 2 oggetti.
		
		#/ DEBUG /#
		print("Velocitá + adding_speed: " + str(speed))
		#/ END_DEBUG /#
	
	# Set della velocitá.
	velocity = direction * speed * delta

#/
#/ DEBUG /#
func handle_debug_movement() -> void:
	direction = Input.get_vector(DEBUG_CONTROLS.LEFT, DEBUG_CONTROLS.RIGHT, DEBUG_CONTROLS.UP, DEBUG_CONTROLS.DOWN)
#/ END_DEBUG /#

#/
## Reset della posizione, della velocitá e random pick della direzione.
func reset() -> void:
	position = Vector2(get_window().get_visible_rect().size.x / 2, get_window().get_visible_rect().size.y / 2)
	var rand_direction: Array[Vector2] = [Vector2.LEFT, Vector2.RIGHT] 
	direction = rand_direction.pick_random()
	speed = INIT_SPEED

#/
## Riproduce i suoni del rimbalzo della palla sul player e sul muro.
func play_sound(index: int) -> void:
	if index >= 0 and index < audio_streams.size():
		$AudioStreamPlayer.stream = audio_streams[index]
		$AudioStreamPlayer.play()
