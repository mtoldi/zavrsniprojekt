extends Card

const SWEET_STATUS = preload("res://statuses/sweet.tres")

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var status_effect := StatusEffect.new()
	var sweet := SWEET_STATUS.duplicate()
	sweet.stacks = 2
	status_effect.status = sweet
	status_effect.execute(targets)
	
	Events.card_tooltip_requested.emit()
