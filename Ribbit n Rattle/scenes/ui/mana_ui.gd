class_name ManaUI
extends TextureRect

@export var char_stats: CharacterStats : set = _set_char_stats

@onready var mana_label: Label = $ManaLabel

var three_energy = preload("res://art/mana bottle.png")
var two_energy = preload("res://art/mana bottle2.png")
var one_energy = preload("res://art/mana bottle3.png")
var no_energy = preload("res://art/mana bottle4.png")

func _ready() -> void:
	# await get_tree().create_timer(1).timeout
	char_stats.mana = 3

func _set_char_stats(value: CharacterStats) -> void:
	char_stats = value
	
	if not char_stats.stats_changed.is_connected(_on_stats_changed):
		char_stats.stats_changed.connect(_on_stats_changed)

	if not is_node_ready():
		await ready
		
	_on_stats_changed()
	
func _on_stats_changed() -> void:
	if char_stats.mana == 3:
		texture = three_energy
	if char_stats.mana == 2:
		texture = two_energy
	if char_stats.mana == 1:
		texture = one_energy
	if char_stats.mana == 0:
		texture = no_energy
	mana_label.text = "%s/%s" % [char_stats.mana, char_stats.max_mana]
	
