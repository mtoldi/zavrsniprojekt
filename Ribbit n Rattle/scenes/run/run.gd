class_name Run
extends Node

const BATTLE_SCENE := preload("res://scenes/battle/battle.tscn")
const SHOP_SCENE := preload("res://scenes/shop/shop.tscn")
const BATTLE_REWARD_SCENE := preload("res://scenes/rewards/rewards.tscn")
const CAMPFIRE_SCENE := preload("res://scenes/campfire/campfire.tscn")
const TREASURE_SCENE := preload("res://scenes/treasure/treasure.tscn")

@export var run_startup: RunStartup

@onready var current_view: Node = $CurrentView
@onready var battle_button: Button = %BattleButton
@onready var map_button: Button = %MapButton
@onready var shop_button: Button = %ShopButton

#card pile
@onready var deck_button: CardPileOpenerrrrr = %DeckButton
@onready var deck_view: CardPileView = %DeckView

#gold
@onready var gold_ui: GoldUI = %GoldUI
#health
@onready var health_ui : HealthUI = %HealthUI
#map
@onready var map: Map = $Map

var character: CharacterStats
var stats: RunStats


func _ready()-> void:
	if not run_startup:
		return		
	
	match run_startup.type:
		RunStartup.Type.NEW_RUN:
			character = run_startup.character.create_instance()
			_start_run()
		
		RunStartup.Type.CONTINUED_RUN:
			print("za napraviti")
		
func _start_run() -> void:
	
	stats = RunStats.new()
	
	_setup_event_connections()
	_setup_top_bar()
	
	map.generate_new_map()
	map.unlock_floor(0)
	
func _setup_top_bar():
	character.stats_changed.connect(health_ui.update_stats.bind(character))
	health_ui.update_stats(character)
	gold_ui.run_stats = stats
	deck_button.card_pile = character.deck
	deck_view.card_pile = character.deck
	deck_button.pressed.connect(deck_view.show_current_view.bind("Deck"))
	
func _on_battle_room_entered(room: Room) -> void:
	var battle_scene: Battle = _change_view(BATTLE_SCENE) as Battle
	battle_scene.char_stats = character
	
	battle_scene.battle_stats = room.battle_stats
	battle_scene.start_battle()
	
	
func _on_campfire_entered() -> void:
	var campfire := _change_view(CAMPFIRE_SCENE) as Campfire
	campfire.char_stats = character

func _on_battle_won() -> void:
	var reward_scene := _change_view(BATTLE_REWARD_SCENE) as BattleReward
	reward_scene.run_stats = stats
	reward_scene.character_stats = character
	
	#temporary added dynamic gold reward
	reward_scene.add_gold_reward(map.last_room.battle_stats.roll_gold_reward())
	reward_scene.add_card_reward()
	
	
func _change_view(scene: PackedScene) -> Node:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
	
	get_tree().paused = false
	var new_view := scene.instantiate()
	current_view.add_child(new_view)
	
	map.hide_map()
	return new_view
	
func _show_map() -> void:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
		
	map.show_map()
	map.unlock_next_rooms()
	
func _setup_event_connections() -> void:
	Events.battle_won.connect(_on_battle_won)
	Events.battle_reward_exited.connect(_show_map)
	Events.map_exited.connect(_on_map_exited)
	Events.shop_exited.connect(_show_map)
	Events.campfire_exited.connect(_show_map)
	Events.treasure_exited.connect(_show_map)
	
	battle_button.pressed.connect(_change_view.bind(BATTLE_SCENE))
	map_button.pressed.connect(_show_map)
	shop_button.pressed.connect(_change_view.bind(SHOP_SCENE))
		
func _on_map_exited(room: Room) -> void:
	match room.type:
		Room.Type.MONSTER:
			_on_battle_room_entered(room)
		Room.Type.SHOP:
			_change_view(SHOP_SCENE)
		Room.Type.POND:
			_on_campfire_entered()
		Room.Type.TREASURE:
			_change_view(TREASURE_SCENE)
		#Room.Type.BOSS:
		#	_change_view(BOSS_SCENE)
