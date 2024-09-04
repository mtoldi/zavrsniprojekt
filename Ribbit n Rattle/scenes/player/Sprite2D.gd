extends Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# Čeka 3 sekunde prije reprodukcije animacije
	await get_tree().create_timer(1).timeout
	$AnimationPlayer.play("idle")
