extends CharacterBody2D

#velocidad del movimiento como constante
var SPEED = 300.0

const ALCANCE_INTERACCION = 40.0 #define que tan largo es el raycast para interactar

var ultima_direccion = Vector2.DOWN #variable para la direccion a donde mira el jugador por defecto hacia abajo


@onready var rayo = $RayCast2D 




#funcion para leer las acciones de movimiento del jugador
func _physics_process(delta):
	if Dialoge.dialogo_activo: #si dialogo esta activo
		velocity = Vector2.ZERO #jugador quedarse quieto
	else: 
		var direction = Input.get_vector("move_izquierda","move_derecha","move_arriba","move_abajo") #si no jugador moverse
		velocity = direction * SPEED
		if direction != Vector2.ZERO: #guarda la ultima dirrecion del personaje 
			ultima_direccion = direction
		move_and_slide()
		rayo.target_position = ultima_direccion.normalized() * ALCANCE_INTERACCION
	if Input.is_action_just_pressed("interactuar"): #input para la accion de interactuar 
		if Dialoge.dialogo_activo:  #si dialogo esta activo 
			Dialoge.siguiente_linea() #seguir con la siguiente linea de dialogo
		else:
			intentar_interactuar()

func intentar_interactuar():
	rayo.force_raycast_update()
	if rayo.is_colliding():
		var objetivo = rayo.get_collider()
		if objetivo.has_method("interactuar"):
			objetivo.interactuar()




