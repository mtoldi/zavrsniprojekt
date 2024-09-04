class_name BurnStatus
extends Status

func get_tooltip() -> String:
	return tooltip % duration

func initialize_status(target: Node) -> void:
	pass

func apply_status(target):
	var damage_effect := DamageEffect.new()
	damage_effect.amount = self.duration
	damage_effect.execute([target])
	status_applied.emit(self)
