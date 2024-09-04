extends Card

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var heal_effect := HealEffect.new()
	
	Events.non_attack_played.emit()
	Events.draw_card_played.emit(1)
	heal_effect.amount = 3
	heal_effect.execute(targets)
	
	#trenutno ima bug ak je zadnja koja je odigrana da bude playable
	# bug popravljen
