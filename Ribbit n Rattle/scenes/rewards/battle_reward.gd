class_name BattleReward
extends Control


const CARD_REWARDS = preload("res://scenes/ui/card_rewards.tscn")
const REWARD_BUTTON = preload("res://scenes/ui/reward_button.tscn")
const GOLD_ICON := preload("res://art/coin.png")
const GOLD_TEXT := "%s gold"
const CARD_ICON := preload("res://art/card_icon.png")
const CARD_TEXT := "Add New Card"



@export var run_stats: RunStats
@export var character_stats: CharacterStats

@onready var rewards: VBoxContainer = %Rewards


func _ready() -> void:
	for node: Node in rewards.get_children():
		node.queue_free()
	

func add_card_reward() -> void:
	var card_reward := REWARD_BUTTON.instantiate() as RewardButton
	card_reward.reward_icon = CARD_ICON
	card_reward.reward_text = CARD_TEXT
	card_reward.pressed.connect(_show_card_rewards)
	rewards.add_child.call_deferred(card_reward)

func _show_card_rewards() -> void:
	if not run_stats or not character_stats:
		return
		
	var card_rewards := CARD_REWARDS.instantiate() as CardRewards
	add_child(card_rewards)
	card_rewards.card_reward_selected.connect(_on_card_reward_taken)
	
	var card_reward_array: Array[Card] = []
	var available_cards: Array[Card] = character_stats.draftable_cards.cards.duplicate(true)
	
	for i in run_stats.card_rewards:
		var picked_card = available_cards.pick_random()
		card_reward_array.append(picked_card)
		available_cards.erase(picked_card)		
	
	card_rewards.rewards = card_reward_array
	card_rewards.show()
	
func _get_random_available_card(available_cards: Array[Card]) -> Card:
	var all_possible_cards := available_cards
	return all_possible_cards.pick_random()

func _on_card_reward_taken(card: Card) -> void:
	if not character_stats or not card:
		return
	
	#print(character_stats.deck.cards.size())
	character_stats.deck.add_card(card)
	#print(character_stats.deck.cards.size())

func add_gold_reward(amount: int) -> void:
	var gold_reward := REWARD_BUTTON.instantiate() as RewardButton
	gold_reward.reward_icon = GOLD_ICON
	gold_reward.reward_text = GOLD_TEXT % amount
	gold_reward.pressed.connect(_on_gold_reward_taken.bind(amount))
	rewards.add_child.call_deferred(gold_reward)

func _on_gold_reward_taken(amount: int) -> void:
	if not run_stats:
		return
	
	run_stats.gold += amount



func _on_back_button_pressed():
	Events.battle_reward_exited.emit()
