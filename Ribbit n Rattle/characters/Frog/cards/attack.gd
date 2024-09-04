extends Card

var base_damage := 6

var burn_damage := 0

var salty := 0

const BURN_STATUS = preload("res://statuses/burn.tres")
const THIRSTY_STATUS = preload("res://statuses/thirsty.tres")

func get_default_tooltip() -> String:
	return tooltip_text % base_damage
	
func get_updated_tooltip(player_modifiers: ModifierHandler, enemy_modifiers: ModifierHandler) -> String:
	var modified_dmg := player_modifiers.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)

	if enemy_modifiers:
		modified_dmg = enemy_modifiers.get_modified_value(modified_dmg, Modifier.Type.DMG_TAKEN)
		
	return tooltip_text % modified_dmg

func apply_effects(targets: Array[Node], modifiers: ModifierHandler) -> void:
	
	#flat out dmg
	var damage_effect := DamageEffect.new()
	Events.attack_played.emit()
	damage_effect.amount = modifiers.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)
	damage_effect.execute(targets)
	
	#burn effect
	var status_effect := StatusEffect.new()
	var burn := BURN_STATUS.duplicate()
	burn.duration = modifiers.get_modified_value(burn_damage, Modifier.Type.TICK)
	
	#print(burn.duration)
	status_effect.status = burn
	if burn.duration > 0:
		Events.burn_applied.emit()
		status_effect.execute(targets)

	#salt effect
	var salt_effect := StatusEffect.new()
	var thirsty := THIRSTY_STATUS.duplicate()
	thirsty.duration = modifiers.get_modified_value(salty, Modifier.Type.SALT)
	
	salt_effect.status = thirsty
	if thirsty.duration > 0:
		Events.thirsty_applied.emit()
		salt_effect.execute(targets)
