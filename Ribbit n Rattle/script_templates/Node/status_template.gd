# meta-name: Status
# meta-description: Create a Status which can be applied
class_name MyAwesomeStatus
extends Status

var member_var := 0

func initialize_status(target: Node) -> void:
	print("lala")


func apply_status(target: Node) -> void:
	print("bruh")
	status_applied.emit(self)
