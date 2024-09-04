class_name CardMenuUI
extends CenterContainer

signal tooltip_requested(card: Card)

const BASE_STYLEBOX := preload("res://scenes/card_ui/classic_style_box.tres")
const HOVER_STYLEBOX := preload("res://scenes/card_ui/card_drag_style_box.tres")

@export var card: Card: set = set_card

@onready var panel: Panel = $Visuals/Panel
@onready var cost: Label = $Visuals/Cost
@onready var icon: TextureRect = $Visuals/Icon

@onready var card_text_label : RichTextLabel = %CardText
@onready var card_name_label : Label = %CardName

func _on_visuals_gui_input(event: InputEvent):
	if event.is_action_pressed("left_mouse"):
		Events.card_tooltip_requested.emit()
		Events.selecting_rewards.emit(card)

func _on_visuals_mouse_entered():
	panel.set("theme_override_styles/panel", HOVER_STYLEBOX)

func _on_visuals_mouse_exited():
	panel.set("theme_override_styles/panel", BASE_STYLEBOX)

func set_card(value: Card) -> void:
	if not is_node_ready():
		await ready
	
	card = value
	cost.text = str(card.cost)
	icon.texture = card.icon
	card_text_label.text = card.get_default_tooltip()
	card_name_label.text = card.name
