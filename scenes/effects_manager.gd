## Classe per gestire gli effetti tramite shaders.
## TODO:
## É molto elementale come effectsmanager,
## potrebbe essere utile migliorarlo e implementarlo
## come classe globale in tutti i progetti futuri.
class_name EffectsManager extends Control

#/
## Lista degli indici degli effetti.
enum effects {
	blur = 0,
}

#/
## READY.
func _ready() -> void:
	visible = false
	
	for child in get_children():
		child.visible = false

#/
## Attivo l'effetto tramite un indice.
func active_effect(index: int) -> void:
	visible = true
	get_child(index).visible = true

#/
## Disabilito l'effetto tramite un indice.
func disable_effect(index: int) -> void:
	get_child(index).visible = false
	visible = false
