extends Panel

signal change_scene(b: bool)

@onready var cpu: Button = $MarginContainer2/VBoxContainer/Cpu
@onready var versus: Button = $MarginContainer2/VBoxContainer/Versus
@onready var close: TextureButton = $MarginContainer3/Close

#/
##
func _ready() -> void:
	cpu.pressed.connect(_on_cpu_pressed)
	versus.pressed.connect(_on_versus_pressed)
	close.pressed.connect(_on_close_pressed)
	
	cpu.mouse_entered.connect($Select.play)
	versus.mouse_entered.connect($Select.play)
	close.mouse_entered.connect($Select.play)

func _on_cpu_pressed() -> void:
	$Click.play()
	await get_tree().create_timer(0.18).timeout
	GlobalVar.select_mode = GlobalVar.Mode.CPU
	change_scene.emit(true)


func _on_versus_pressed() -> void:
	$Click.play()
	await get_tree().create_timer(0.18).timeout
	GlobalVar.select_mode = GlobalVar.Mode.VERSUS
	change_scene.emit(true)


func _on_close_pressed() -> void:
	$Click.play()
	await get_tree().create_timer(0.18).timeout
	change_scene.emit(false)
