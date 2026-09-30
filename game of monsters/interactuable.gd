extends Area2D

@onready var awawawa = $AudioStreamPlayer2D

@export var nombre = ""
									   #variables exportables
@export_multiline var dialogo = ""

@export var dialogo_inicial: NodoDialogo = null


func interactuar():
	print("1 - interactuar llamado, dialogo_inicial = ", dialogo_inicial)
	if dialogo_inicial != null:
		print("2 - entrando al sistema nuevo")
		awawawa.play()
		Dialoge.mostrar_dialogo_avanzado(nombre, dialogo_inicial)
	elif dialogo.strip_edges() != "":
		print("2 - entrando al sistema viejo")
		awawawa.play()
		Dialoge.mostrar_dialogo(nombre, dialogo.split("\n"))
