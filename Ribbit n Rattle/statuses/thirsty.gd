class_name ThirstyStatus
extends Status

func get_tooltip() -> String:
	return tooltip % duration

func initialize_status(target: Node) -> void:
	pass

func apply_status(target):
	status_applied.emit(self)
