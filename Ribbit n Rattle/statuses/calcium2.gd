class_name Calcium2Status
extends Status

func get_tooltip() -> String:
	return tooltip % stacks

func initialize_status(target):
	status_changed.connect(_on_status_changed.bind(target))
	_on_status_changed(target)

func _on_status_changed(target: Node) -> void:
	assert(target.get("modifier_handler"), "No modifiers on %s" % target)
	
	var block_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.LESS_BLOCK)
	assert(block_modifier, "No dmg dealt modifier on %s" % target)
	
	var calcium_modifier_value := block_modifier.get_value("calcium")
	
	if calcium_modifier_value:
		calcium_modifier_value.flat_value = self.stacks

	if not calcium_modifier_value:
		calcium_modifier_value = ModifierValue.create_new_modifier("calcium", ModifierValue.Type.FLAT)
		calcium_modifier_value.flat_value = stacks
		block_modifier.add_new_value(calcium_modifier_value)
