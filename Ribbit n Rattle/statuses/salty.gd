class_name SaltyStatus
extends Status

func get_tooltip() -> String:
	return tooltip % stacks

func initialize_status(target):
	status_changed.connect(_on_status_changed.bind(target))
	_on_status_changed(target)

func _on_status_changed(target: Node) -> void:
	assert(target.get("modifier_handler"), "No modifiers on %s" % target)
	
	var salt_modifier : Modifier = target.modifier_handler.get_modifier(Modifier.Type.SALT)
	assert(salt_modifier, "No dmg dealt modifier on %s" % target)
	
	var salty_modifier_value := salt_modifier.get_value("salty")
	
	if salty_modifier_value:
		salty_modifier_value.flat_value = self.stacks

	if not salty_modifier_value:
		salty_modifier_value = ModifierValue.create_new_modifier("salty", ModifierValue.Type.FLAT)
		salty_modifier_value.flat_value = self.stacks
		salt_modifier.add_new_value(salty_modifier_value)
