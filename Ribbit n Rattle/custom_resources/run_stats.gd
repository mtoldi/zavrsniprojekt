class_name RunStats
extends Resource

signal gold_changed

const STARTING_GOLD := 20
const BASE_CARD_REWARDS := 3

@export var gold := STARTING_GOLD : set = set_gold
@export var card_rewards := BASE_CARD_REWARDS

func set_gold(new_amount: int) -> void:
	gold = new_amount
	gold_changed.emit()
