extends CanvasLayer

@onready var panel = $Panel

@onready var hablante = $Panel/hablante

@onready var texto_dialogo = $Panel/texto_dialogo

var lineas_de_dialogo = []
var linea_actual = 0
var dialogo_activo = false

var escribiendo = false
var texto_completo = ""
var indice_texto = 0

var velocidad_escritura = 0.05

func _ready():
	panel.hide()

func mostrar_dialogo(nombre, nuevas_lineas): #lo que hace es buscar la informacion de nombre y nueva_linea en el interactuable
	if nuevas_lineas.is_empty():
		return
	
	dialogo_activo = true 
	 
	panel.show()
	
	hablante.text = nombre #convierte el hablante en el nombre dado por el interactuable
	
	lineas_de_dialogo = nuevas_lineas #mete dentro del grupo de lineas a la informacion dada por el interactuable llmada nuevas_lineas
	
	linea_actual = 0
	
	mostrar_linea()
	
func mostrar_linea():
	texto_completo = lineas_de_dialogo[linea_actual]
	indice_texto = 0
	escribiendo = true
	texto_dialogo.text = ""
	mostrar_texto()
	
	
func mostrar_texto():
	
	while indice_texto < texto_completo.length():

		texto_dialogo.text = texto_completo.substr(0, indice_texto + 1)

		indice_texto += 1

		await get_tree().create_timer(velocidad_escritura).timeout

	escribiendo = false

func siguiente_linea():
	if escribiendo:

		texto_dialogo.text = texto_completo
		indice_texto = texto_completo.length()
		escribiendo = false

	else:

		linea_actual += 1

		if linea_actual >= lineas_de_dialogo.size():

			cerrar_dialogo()

		else:

			mostrar_linea()


func cerrar_dialogo():
	panel.hide()
	dialogo_activo = false
	lineas_de_dialogo.clear()
	linea_actual = 0
	
	hablante.text = ""
	texto_dialogo.text = ""
	







