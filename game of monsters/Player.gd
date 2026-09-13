extends CharacterBody2D

#velocidad del movimiento como constante
var SPEED = 300.0
#funcion para leer las acciones de movimiento del jugador
func _physics_process(delta):
	if Dialoge.dialogo_activo: #si dialogo esta activo
		velocity = Vector2.ZERO #jugador quedarse quieto
	else: 
		var direction = Input.get_vector("move_izquierda","move_derecha","move_arriba","move_abajo") #si no jugador moverse
		velocity = direction * SPEED
		move_and_slide()
	if Input.is_action_just_pressed("interactuar"): #input para la accion de interactuar 
		if Dialoge.dialogo_activo:  #si dialogo esta activo 
			Dialoge.siguiente_linea() #seguir con la siguiente linea de dialogo
		elif interactuable_cerca.size() > 0: #de lo contrario interactuar con el interactuable
			interactuable_cerca[0].interactuar()




var interactuable_cerca = []

func registrar_interactuable(objeto):
	if not interactuable_cerca.has(objeto):
		interactuable_cerca.append(objeto)
		print(interactuable_cerca)

func eliminar_interactuable(objeto):
	interactuable_cerca.erase(objeto)
	print(interactuable_cerca)



