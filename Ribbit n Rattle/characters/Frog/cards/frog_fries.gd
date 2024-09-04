extends Card

const SALTY_STATUS = preload("res://statuses/salty.tres")

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var status_effect := StatusEffect.new()
	var salty := SALTY_STATUS.duplicate()
	salty.stacks = 1
	status_effect.status = salty
	status_effect.execute(targets)
	
	Events.non_attack_played.emit()
	Events.draw_card_played.emit(1)

	
	Events.card_tooltip_requested.emit()
