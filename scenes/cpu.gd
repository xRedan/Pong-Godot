class_name Cpu extends CharacterBody2D

## CONSTANTS
const SPEED = 850.0

## EXPORT VARIABLES
@export var ball: Ball = null
@export var disabled: bool = false

#region LOCAL VARIABLES
var rect_size: Vector2:
	get:
		return $CollisionShape2D.shape.get_rect().size

var direction: Vector2 = Vector2.ZERO
#endregion

#/
## READY.
func _ready() -> void:
	if(GlobalVar.select_mode == GlobalVar.Mode.VERSUS):
		disabled = true
	else:
		disabled = false
	reset()

#/
## PHYSICS PROCESS.
func _physics_process(delta: float) -> void:
	if not disabled:
		direction = (ball.global_position - position).normalized()
		velocity.y = lerp(velocity.y, direction.y * SPEED, delta * 45.0)
	
		move_and_slide()

#/
## Reset the position of cpu.
func reset() -> void:
	if not disabled:
		var viewport_size = get_viewport().get_visible_rect().size # Size della finestra.
		var x_offset: int = 75 # Margine orizzontale.
		var y_offset: int = 75 # Margine verticale.
		position = Vector2(viewport_size.x - x_offset, viewport_size.y/2);
	else:
		position = Vector2(-500, -500)
