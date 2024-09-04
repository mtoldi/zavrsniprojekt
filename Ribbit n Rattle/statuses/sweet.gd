class_name SweetStatus
extends Status

func get_tooltip() -> String:
	return tooltip % stacks

func initialize_status(target):
	status_changed.connect(_on_status_changed.bind(target))
	_on_status_changed(target)

func _on_status_changed(target: Node) -> void:
	assert(target.get("modifier_handler"), "No modifiers on %s" % target)
	
	var dmg_dealt_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.DMG_DEALT)
	assert(dmg_dealt_modifier, "No dmg dealt modifier on %s" % target)
	
	var sweet_modifier_value := dmg_dealt_modifier.get_value("sweet")
	
	if sweet_modifier_value:
		sweet_modifier_value.flat_value = self.stacks

	if not sweet_modifier_value:
		sweet_modifier_value = ModifierValue.create_new_modifier("sweet", ModifierValue.Type.FLAT)
		sweet_modifier_value.flat_value = stacks
		dmg_dealt_modifier.add_new_value(sweet_modifier_value)
