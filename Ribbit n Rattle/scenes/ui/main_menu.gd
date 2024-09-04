extends Control

var RUN_SCENE := preload("res://scenes/run/run.tscn").instantiate()

@onready var continue_button: Button = %Continue

func _ready() -> void:
	get_tree().paused = false
	continue_button.disabled = true

func _on_continue_pressed():
	print("continue run")

func _on_new_run_pressed():
	get_tree().root.add_child(RUN_SCENE)
	self.hide()

func _on_exit_pressed():
	get_tree().quit()
