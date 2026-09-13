extends Area2D

@onready var awawawa = $AudioStreamPlayer2D

@export var nombre = ""
									   #variables exportables
@export_multiline var dialogo = ""

var jugador_cerca = false

func _on_body_entered(body):
	if body.is_in_group("jugador"):
		jugador_cerca = true
		body.registrar_interactuable(self)




func _on_body_exited(body):
	if body.is_in_group("jugador"):
		jugador_cerca = false
		body.eliminar_interactuable(self)



func interactuar():

	awawawa.play()

	var lineas = dialogo.split("\n")

	Dialoge.mostrar_dialogo(nombre, lineas)
