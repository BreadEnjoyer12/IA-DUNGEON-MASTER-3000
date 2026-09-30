extends Resource
class_name NodoDialogo 

@export_multiline var texto: String = ""
@export var hablante: String = ""
@export var opciones: Array[OpcionDialogo] = []
@export var siguiente: NodoDialogo = null
