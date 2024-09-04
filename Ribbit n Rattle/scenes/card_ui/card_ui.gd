class_name CardUI
extends Control

signal reparent_requested(which_card_ui: CardUI)

const BASE_STYLEBOX := preload("res://scenes/card_ui/classic_style_box.tres")
const DRAG_STYLEBOX := preload("res://scenes/card_ui/card_drag_style_box.tres")
const HOVER_STYLEBOX := preload("res://scenes/card_ui/card_hover_style_box.tres")

@export var player_modifiers: ModifierHandler
@export var card: Card : set = _set_card
@export var char_stats: CharacterStats : set = _set_char_stats

@onready var panel: Panel = $Panel
@onready var cost: Label = $Cost
@onready var icon: TextureRect = $Icon
@onready var drop_point_detector = $DropPointDetector
@onready var card_state_machine: CardStateMachine = $CardStateMachine
@onready var targets: Array[Node] = []
@onready var original_index := self.get_index()

#dio za card desc

@onready var card_text_label : RichTextLabel = %CardText
@onready var card_name_label : Label = %CardName


var parent: Control
var tween: Tween
var playable := false : set = _set_playable
var disabled := false

func _ready() -> void:
	
	Events.card_aim_started.connect(_on_card_drag_or_aiming_started)
	Events.card_drag_started.connect(_on_card_drag_or_aiming_started)
	Events.card_drag_ended.connect(_on_card_drag_or_aim_ended)
	Events.card_aim_ended.connect(_on_card_drag_or_aim_ended)
	Events.player_hand_drawn.connect(_on_char_stats_changed)
	Events.card_tooltip_requested.connect(_on_tooltip_requested)
	card_state_machine.init(self)
	
func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)
	
func _on_tooltip_requested() -> void:
	request_tooltip()

func animate_to_position(new_position: Vector2, duration: float) -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", new_position, duration)
	
func play() -> void:
	if not card:
		return
	card.play(targets, char_stats, player_modifiers)
	Events.card_playedd.emit()
	queue_free()
	
func get_active_enemy_modifiers() -> ModifierHandler:
	if targets.is_empty() or targets.size() > 1 or not targets[0] is Enemy:
		return null
	
	return targets[0].modifier_handler

func request_tooltip() -> void:
	var enemy_modifiers := get_active_enemy_modifiers()
	var updated_tooltip := card.get_updated_tooltip(player_modifiers, enemy_modifiers)
	card_text_label.text = updated_tooltip
	
	
func _on_gui_input(event: InputEvent) -> void:
	card_state_machine.on_gui_input(event)
	
func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()
	
func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()
	
func _set_card(value: Card) -> void:
	if not is_node_ready():
		await ready
	
	card = value
	cost.text = str(card.cost)
	icon.texture = card.icon
	card_text_label.text = card.tooltip_text
	card_name_label.text = card.name

func _set_playable(value: bool) -> void:
	playable = value
	if not playable:
		cost.add_theme_color_override("font_color", Color.RED)
		icon.modulate = Color(1, 1, 1, 0.5)
		card_text_label.modulate = Color(1, 1, 1, 0.5)
	else:
		cost.remove_theme_color_override("font_color")
		icon.modulate = Color(1, 1, 1, 1)

func _set_char_stats(value: CharacterStats) -> void:
	char_stats = value
	char_stats.stats_changed.connect(_on_char_stats_changed)

	
func _on_drop_point_detector_area_entered(area):
	if not targets.has(area):
		targets.append(area)

func _on_drop_point_detector_area_exited(area):
	targets.erase(area)

func _on_card_drag_or_aiming_started(used_card: CardUI) -> void:
	if used_card == self:
		return
	
	disabled = true

func _on_card_drag_or_aim_ended(_card: CardUI) -> void:
	disabled = false
	self.playable = char_stats.can_play_card(card)	

func _on_char_stats_changed() -> void:
	self.playable = char_stats.can_play_card(card)
	
