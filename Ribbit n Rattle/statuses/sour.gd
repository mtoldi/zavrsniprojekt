class_name SourStatus
extends Status

func get_tooltip() -> String:
	return tooltip % stacks

func initialize_status(target):
	status_changed.connect(_on_status_changed.bind(target))
	_on_status_changed(target)

func _on_status_changed(target: Node) -> void:
	assert(target.get("modifier_handler"), "No modifiers on %s" % target)
	
	var block_gain_modifier: Modifier = target.modifier_handler.get_modifier(Modifier.Type.BLOCK)
	assert(block_gain_modifier, "No dmg dealt modifier on %s" % target)
	
	var sour_modifier_value := block_gain_modifier.get_value("sour")
	
	if sour_modifier_value:
		sour_modifier_value.flat_value = self.stacks

	if not sour_modifier_value:
		sour_modifier_value = ModifierValue.create_new_modifier("sour", ModifierValue.Type.FLAT)
		sour_modifier_value.flat_value = stacks
		block_gain_modifier.add_new_value(sour_modifier_value)
