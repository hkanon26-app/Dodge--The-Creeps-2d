extends CanvasLayer

# Notifica el nodo 'main` que se ha presionado el botón
signal start_game


func show_massage(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
	
func show_game_over():
	show_massage("Game Over")
	# Esperar hasta que el Messagetimer haya contado.
	await $MessageTimer.timeout
	
	$Message.text = "¡Dodga los Creeps!"
	$Message.show()
	# Haga un temporizador de un solo disparo y espere a que termine.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	
	
func update_score():
	$ScoreLabel.text = str(score)
	
	
func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()


func _on_message_timer_timeout() -> void:
	$Message.hide()
