extends EnemyAction

var already_used := false

func is_performable() -> bool:
	if not enemy:
		return false
	
	if enemy.status_handler._has_status("thirsty"):
		return true
	
	return false
	
func perform_action() -> void:
	if not enemy or not target:
		return
	
	get_tree().create_timer(0.6, false).timeout.connect(
		func():
			Events.enemy_action_completed.emit(enemy)
	)
	
func update_intent_text() -> void:
	if not enemy:
		return
	
	intent.current_text = intent.base_text
	
