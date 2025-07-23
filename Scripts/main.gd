extends Node

@export var mob_scene: PackedScene
var score: int = 0


# Estados del juego
enum {COUNTDOWN, PLAYING, GAME_OVER}
var state = COUNTDOWN

func _on_player_hit() -> void:
	game_over()

func game_over():
	state = GAME_OVER
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	
func new_game():
	# Limpiar enemigos anteriores
	get_tree().call_group("mobs", "queue_free")
	
	# Reiniciar estado y puntuación
	state = COUNTDOWN
	score = 0 
	$HUD.update_score(score)
	$HUD.show_message("Prepararse")
	$GameOver.hide()
	
	# Iniciar jugador y temporizadores
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	$Music.play()
	
	
func _on_score_timer_timeout() -> void:
	# Solo sumar puntos durante el juego activo
	if state == PLAYING:
		score += 1
		$HUD.update_score(score)

func _on_start_timer_timeout() -> void:
	# Cambiar a estado PLAYING cuando termina la cuenta regresiva
	state = PLAYING
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout() -> void:
	# Solo generar enemigos durante el juego activo
	if state != PLAYING:
		return
		
	# Crea una nueva instancia de la escena de la mafia.	
	var mob = mob_scene.instantiate()
	
	# Elija una ubicación aleatoria en Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	#Establezca la posición de la mafia en la ubicación aleatoria.
	mob.position = mob_spawn_location.position

	# Establezca la dirección de la mafia perpendicular a la dirección del camino.
	var direction = mob_spawn_location.rotation + PI / 2
	
	# Agregue un poco de aleatoriedad a la dirección.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Elija la velocidad para la mafia.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# Aprendiendo la mafia agregándola a la escena principal.
	add_child(mob)
	
	
	
