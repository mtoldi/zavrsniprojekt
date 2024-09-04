class_name Battle
extends Node2D

@export var char_stats: CharacterStats

#battles
@export var battle_stats: BattleStats

@onready var battle_ui: BattleUI = $BattleUI as BattleUI 
@onready var player_handler: PlayerHandler = $PlayerHandler as PlayerHandler
@onready var enemy_handler: EnemyHandler = $EnemyHandler as EnemyHandler
@onready var player: Player = $Player as Player

func _ready() -> void:
	
	enemy_handler.child_order_changed.connect(_on_enemies_child_order_changed)
	Events.enemy_turn_ended.connect(_on_enemy_turn_ended)
	Events.player_turn_ended.connect(player_handler.end_turn)
	Events.player_hand_discarded.connect(enemy_handler.start_turn)
	Events.player_died.connect(_on_player_died)
	
	#start_battle()
	
func start_battle() -> void:
	
	battle_ui.char_stats = char_stats
	player.stats = char_stats
	enemy_handler.setup_enemies(battle_stats)
	enemy_handler.reset_enemy_actions()
	player_handler.start_battle(char_stats)
	battle_ui.initialize_card_pile_ui()

func _on_enemy_turn_ended() -> void:
	enemy_handler.reset_enemy_actions()
	await get_tree().create_timer(1).timeout
	player_handler.start_turn()
	
func _on_enemies_child_order_changed() -> void:
	if enemy_handler.get_child_count() == 0:
		player_handler.hand.hide()
		Events.battle_over_screen_requested.emit("Battle won!", BattleOverPanel.Type.WIN)

func _on_player_died() -> void:
	Events.battle_over_screen_requested.emit("Game Over!", BattleOverPanel.Type.LOSE)
