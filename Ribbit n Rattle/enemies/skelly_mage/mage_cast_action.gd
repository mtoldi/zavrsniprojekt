extends EnemyAction

const CALCIUM_STATUS = preload("res://statuses/calcium.tres")
const CALCIUM_STATUS2 = preload("res://statuses/calcium2.tres")

func perform_action() -> void:
	if not enemy or not target:
		return
		
	Events.spell_casted.emit()
	
	var tween := create_tween().set_trans(Tween.TRANS_QUINT)
	
	var status_effect := StatusEffect.new()
	var calcium := CALCIUM_STATUS.duplicate()
	var target_array: Array[Node] = [target]
	calcium.stacks = 2
	status_effect.status = calcium
	
	var status_effect2 := StatusEffect.new()
	var calcium2 := CALCIUM_STATUS2.duplicate()
	var target_array2: Array[Node] = [enemy]
	calcium2.stacks = 2
	status_effect2.status = calcium2
	
	tween.tween_callback(status_effect.execute.bind(target_array))
	tween.tween_callback(status_effect2.execute.bind(target_array2))
	
	tween.finished.connect(
		func():
			Events.enemy_action_completed.emit(enemy)
	)
	Events.card_tooltip_requested.emit()


func update_intent_text() -> void:
	pass
	
