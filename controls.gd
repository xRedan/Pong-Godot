extends Panel

signal window_close

@onready var close: TextureButton = $MarginContainer3/Close

func _ready() -> void:
	close.pressed.connect(_on_close_pressed)
	close.mouse_entered.connect($Selection.play)

func _on_close_pressed() -> void:
	window_close.emit()
	$Click.play()
	await get_tree().create_timer(0.18).timeout
	queue_free()
