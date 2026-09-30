extends CanvasLayer

@onready var panel = $Panel
@onready var hablante = $Panel/hablante
@onready var texto_dialogo = $Panel/texto_dialogo
@onready var opciones_container = $Panel/opciones_container

var lineas_de_dialogo = []
var linea_actual = 0
var dialogo_activo = false

var modo_avanzado = false
var nodo_actual: NodoDialogo = null
var lineas_del_nodo = []
var indice_linea_nodo = 0

var escribiendo = false
var texto_completo = ""
var indice_texto = 0

var velocidad_escritura = 0.05

func _ready():
	panel.hide()
	opciones_container.hide()

# ---------- Sistema viejo: lineal, para letreros y diálogos simples ----------

func mostrar_dialogo(nombre, nuevas_lineas):
	modo_avanzado = false
	dialogo_activo = true
	panel.show()
	hablante.text = nombre
	lineas_de_dialogo = nuevas_lineas
	linea_actual = 0
	mostrar_linea()

func mostrar_linea():
	texto_completo = lineas_de_dialogo[linea_actual]
	indice_texto = 0
	escribiendo = true
	texto_dialogo.text = ""
	mostrar_texto()

# ---------- Sistema nuevo: con ramas, para NPCs con conversación real ----------

func mostrar_dialogo_avanzado(nombre, nodo_inicial: NodoDialogo):
	print("3 - mostrar_dialogo_avanzado, nodo_inicial = ", nodo_inicial)
	modo_avanzado = true
	dialogo_activo = true
	panel.show()
	hablante.text = nombre
	nodo_actual = nodo_inicial
	mostrar_nodo()

func mostrar_nodo():
	if nodo_actual.hablante != "":
		hablante.text = nodo_actual.hablante
	lineas_del_nodo = nodo_actual.texto.split("\n")
	indice_linea_nodo = 0
	opciones_container.hide()
	mostrar_pagina_nodo()

func mostrar_pagina_nodo():
	texto_completo = lineas_del_nodo[indice_linea_nodo]
	indice_texto = 0
	escribiendo = true
	texto_dialogo.text = ""
	mostrar_texto()

# ---------- Máquina de escribir, compartida por ambos sistemas ----------

func mostrar_texto():
	while indice_texto < texto_completo.length():
		texto_dialogo.text = texto_completo.substr(0, indice_texto + 1)
		indice_texto += 1
		await get_tree().create_timer(velocidad_escritura).timeout
	escribiendo = false

	if modo_avanzado and indice_linea_nodo >= lineas_del_nodo.size() - 1 and nodo_actual.opciones.size() > 0:
		mostrar_opciones()
		

# ---------- Opciones (solo modo avanzado) ----------

func mostrar_opciones():
	for hijo in opciones_container.get_children():
		hijo.queue_free()

	for opcion in nodo_actual.opciones:
		var boton = Button.new()
		boton.text = opcion.texto_opcion
		boton.pressed.connect(func(): elegir_opcion(opcion))
		opciones_container.add_child(boton)

	opciones_container.show()

func elegir_opcion(opcion: OpcionDialogo):
	opciones_container.hide()
	for hijo in opciones_container.get_children():
		hijo.queue_free()

	if opcion.destino == null:
		cerrar_dialogo()
	else:
		nodo_actual = opcion.destino
		mostrar_nodo()

# ---------- Avanzar con el botón de interactuar ----------

func siguiente_linea():
	if escribiendo:
		texto_dialogo.text = texto_completo
		indice_texto = texto_completo.length()
		escribiendo = false
		return

	if modo_avanzado:
		if indice_linea_nodo < lineas_del_nodo.size() - 1:
			indice_linea_nodo += 1
			mostrar_pagina_nodo()
			return
		if nodo_actual.opciones.size() > 0:
			return
		if nodo_actual.siguiente == null:
			cerrar_dialogo()
		else:
			nodo_actual = nodo_actual.siguiente
			mostrar_nodo()

func cerrar_dialogo():
	panel.hide()
	opciones_container.hide()
	dialogo_activo = false
	modo_avanzado = false
	nodo_actual = null
	lineas_de_dialogo.clear()
	linea_actual = 0
	hablante.text = ""
	texto_dialogo.text = ""
