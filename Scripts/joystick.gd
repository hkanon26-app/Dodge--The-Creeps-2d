extends Area2D


class_name Joystick


var distancia : float
var direccion : Vector2
var index : int = -1
@onready var rango = $Rango
@onready var palanca = $Palanca
@onready var radio = $CollisionShape2D.shape.radius


func _ready() -> void:
	pass 


func _process(_delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.is_pressed() and index == -1:
			# si se acaba de presionar	
			distancia = global_position.distance_to(event.position)
			if distancia <= radio:
				index = event.index
				palanca.global_position = event.position
				distancia = (event.position - global_position).normalized() * (distancia / radio)
				#distancia = global_position.direction_to(palanca.global_position) * distancia / radio
		elif event.index == index:
			# si se acaba de soltar
			index = -1
			palanca.position = Vector2.ZERO
			direccion = Vector2.ZERO
	
	
	if event is InputEventScreenDrag:
		# si se arrastró el dedo
		if event.index == index:
			distancia = global_position.distance_to(event.position)
			if distancia <= radio:
				palanca.global_position = event.position
				direccion = (event.position - global_position).normalized() * (distancia / radio)
				#distancia = (global_position.direction_to(palanca.global_position) * distancia) / radio
			else:
				direccion = (event.position - global_position).normalized()
				#direccion = global_position.direction_to(event.position)
				palanca.global_position = global_position + (direccion * radio)
			
		
	
