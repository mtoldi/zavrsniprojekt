# meta-name: EnemyAction
# meta-description: create an effect

class_name MyAwesomeEffect
extends Effect

var member_var := 0

func execute(targets: Array[Node]) -> void:
	print('lmao effect')
