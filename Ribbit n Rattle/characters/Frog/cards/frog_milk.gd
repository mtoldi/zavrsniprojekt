extends Card

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler):
	Events.non_attack_played.emit()
	Events.draw_card_played.emit(2)
	Events.dairy_applied.emit()
	
