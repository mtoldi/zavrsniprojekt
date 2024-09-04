class_name MyAwesomeStatus
extends Status

var member_var = 0

func initialize_status(target):
	print("lala")


func apply_status(target):
	print("bruh")
	status_applied.emit(self)
