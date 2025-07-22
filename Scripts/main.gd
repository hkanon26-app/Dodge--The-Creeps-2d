extends Node

@export var mob_scene: PackedScene
var score


func _on_player_hit() -> void:
	pass # Replace with function body.

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	
func new_game():
	score = 0 
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Prepararse")
	get_tree().call_group("mobs", "queue_free")
	$Music.play()
	
	
	
func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout() -> void:
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
	
	
	
