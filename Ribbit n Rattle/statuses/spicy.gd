class_name SpicyStatus
extends Status

func get_tooltip() -> String:
	return tooltip % stacks

func initialize_status(target):
	status_changed.connect(_on_status_changed.bind(target))
	_on_status_changed(target)

func _on_status_changed(target: Node) -> void:
	assert(target.get("modifier_handler"), "No modifiers on %s" % target)
	
	var tick_modifier : Modifier = target.modifier_handler.get_modifier(Modifier.Type.TICK)
	assert(tick_modifier, "No dmg dealt modifier on %s" % target)
	
	var spicy_modifier_value := tick_modifier.get_value("spicy")
	
	if spicy_modifier_value:
		spicy_modifier_value.flat_value = self.stacks

	if not spicy_modifier_value:
		spicy_modifier_value = ModifierValue.create_new_modifier("spicy", ModifierValue.Type.FLAT)
		spicy_modifier_value.flat_value = self.stacks
		#print(spicy_modifier_value.flat_value)
		tick_modifier.add_new_value(spicy_modifier_value)
