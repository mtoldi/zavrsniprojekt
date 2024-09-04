extends Card

const SOUR_STATUS = preload("res://statuses/sour.tres")

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var status_effect := StatusEffect.new()
	var sour := SOUR_STATUS.duplicate()
	sour.stacks = 2
	status_effect.status = sour
	status_effect.execute(targets)
	
	Events.card_tooltip_requested.emit()
