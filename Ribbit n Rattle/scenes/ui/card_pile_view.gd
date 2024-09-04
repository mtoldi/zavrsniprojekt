class_name CardPileView
extends Control

const CARD_MENU_UI_SCENE := preload("res://scenes/ui/card_menu_ui.tscn")

@export var card_pile: CardPile

@onready var title: Label = %Title 
@onready var cards: GridContainer = %Cards
@onready var back_button: Button = %BackButton

func _ready() -> void:
	back_button.pressed.connect(hide)
	Events.card_pile_closed.emit()
	
	for card: Node in cards.get_children():
		card.queue_free()
	
func show_current_view(new_title: String, randomized: bool = false) -> void:
	for card: Node in cards.get_children():
		card.queue_free()
		
	title.text = new_title
	_update_view.call_deferred(randomized)
	
func _update_view(randomized: bool) -> void:
	if not card_pile:
		return
	
	var all_cards := card_pile.cards.duplicate()
	if randomized:
		all_cards.shuffle()
	
	for card: Card in all_cards:
		var new_card := CARD_MENU_UI_SCENE.instantiate() as CardMenuUI
		cards.add_child(new_card)
		new_card.card = card
		
	show()
	Events.card_pile_opened.emit()
