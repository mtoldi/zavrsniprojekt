extends Card

const SPICY_STATUS = preload("res://statuses/spicy.tres")

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var status_effect := StatusEffect.new()
	var spicy := SPICY_STATUS.duplicate()
	spicy.stacks = 5
	status_effect.status = spicy
	status_effect.execute(targets)
