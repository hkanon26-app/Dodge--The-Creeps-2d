extends Area2D
	
signal hit
	
	
@export var speed = 400
var screen_size
var joystick : Joystick
var direccion = Vector2()
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()
	z_index = 1


func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	
	
	
	# Sistema para móvil: usa el joystick
	if OS.get_name() in ["Android", "iOS"]:
		if joystick != null and is_instance_valid(joystick):
			# Usamos la dirección del joystick directamente
			velocity = joystick.direccion * speed
			
	# Sistema para escritorio: usa teclado
	else:
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1 
			
		# Normalizar para movimiento diagonal
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
		
	# Aplicar movimiento
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
		
	# Manejar animaciones
	if velocity.length() > 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0 
	
	
func _on_body_entered(_body: Node2D) -> void:
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
	# Configura animación inicial
	$AnimatedSprite2D.animation = "walk"
	$AnimatedSprite2D.flip_h = false
	$AnimatedSprite2D.flip_v = false
	$AnimatedSprite2D.play()
	
func recibir_joystick(j : Joystick):
	joystick  = j
