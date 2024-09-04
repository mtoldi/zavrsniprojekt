extends Card

var base_damage := 5

var burn_damage := 0

const BURN_STATUS = preload("res://statuses/burn.tres")

func apply_effects(targets: Array[Node], modifiers: ModifierHandler):
	var damage_effect := DamageEffect.new()
	Events.attack_played.emit()
	damage_effect.amount = modifiers.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)
	damage_effect.execute(targets)

	var status_effect := StatusEffect.new()
	var burn := BURN_STATUS.duplicate()
	burn.duration = modifiers.get_modified_value(burn_damage, Modifier.Type.TICK)
	#print(burn.duration)
	status_effect.status = burn
	status_effect.execute(targets)
