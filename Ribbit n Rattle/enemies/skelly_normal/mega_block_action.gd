extends EnemyAction

@export var block := 15
@export var hp_threshold := 10

var already_used := false

func is_performable() -> bool:
	if not enemy or already_used:
		return false
		
	var is_low := enemy.stats.health <= hp_threshold
	already_used = is_low
	
	return is_low

func perform_action() -> void:
	if not enemy or not target:
		return
	
	var block_effect := BlockEffect.new()
	block_effect.amount = block
	block_effect.execute([enemy])
	
	get_tree().create_timer(0.6, false).timeout.connect(
		func():
			Events.enemy_action_completed.emit(enemy)
	)
	
func update_intent_text() -> void:
	if not enemy:
		return
	
	var modified_block := enemy.modifier_handler.get_modified_value(block, Modifier.Type.BLOCK)
	intent.current_text = intent.base_text % modified_block
	
