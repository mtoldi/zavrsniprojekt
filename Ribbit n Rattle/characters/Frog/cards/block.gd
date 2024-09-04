extends Card

const CALCIUM_STATUS = preload("res://statuses/calcium.tres")

var base_block := 5

var base_calcium := 0

func get_default_tooltip() -> String:
	return tooltip_text % base_block
	
func get_updated_tooltip(player_modifiers: ModifierHandler, enemy_modifiers: ModifierHandler) -> String:
	var modified_block := player_modifiers.get_modified_value(base_block, Modifier.Type.BLOCK)
	var calcium_block := player_modifiers.get_modified_value(base_calcium, Modifier.Type.LESS_BLOCK)
	
	var block_sum = modified_block + calcium_block

	if enemy_modifiers:
		modified_block = enemy_modifiers.get_modified_value(modified_block, Modifier.Type.LESS_BLOCK)
		
	if block_sum <0:
		block_sum = 0
		
	return tooltip_text % block_sum

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	
	var block_effect := BlockEffect.new()
	
	Events.non_attack_played.emit()
	
	var calcium := 0
	
	if _modifiers.get_modifier(Modifier.Type.LESS_BLOCK):
		calcium = _modifiers.get_modified_value(calcium, Modifier.Type.LESS_BLOCK)
	
	block_effect.amount = _modifiers.get_modified_value(base_block, Modifier.Type.BLOCK)
	block_effect.amount += calcium
	if block_effect.amount < 0:
		block_effect.amount = 0
	block_effect.execute(targets)
	
