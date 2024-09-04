class_name Player
extends Node2D

@export var stats: CharacterStats : set = set_character_stats

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var stats_ui: StatsUI = $StatsUI as StatsUI
@onready var status_handler: StatusHandler = $StatusHandler
@onready var modifier_handler: ModifierHandler = $ModifierHandler

@onready var anim = $AnimatedSprite2D

func _ready() -> void:
	status_handler.status_owner = self
	
	anim.play("idle")
	Events.time_to_croak.connect(croaking_anim)
	Events.back_to_idle.connect(idle_anim)
	Events.attack_played.connect(attack_anim)
	Events.non_attack_played.connect(eat_the_card_anim)
	Events.burn_applied.connect(clear_ticks)
	Events.thirsty_applied.connect(clear_salt)
	Events.dairy_applied.connect(clear_calcium)
	
func clear_ticks() -> void:
	modifier_handler.get_modifier(Modifier.Type.TICK).clear_values()
	status_handler._get_status("spicy").stacks = 0
	
func clear_salt() -> void:
	modifier_handler.get_modifier(Modifier.Type.SALT).clear_values()
	status_handler._get_status("salty").stacks = 0
	
func clear_calcium() -> void:
	modifier_handler.get_modifier(Modifier.Type.LESS_BLOCK).clear_values()
	if status_handler._has_status("calcium"):
		status_handler._get_status("calcium").stacks = 0
	
func eat_the_card_anim() -> void:
	anim.play("eatin")
	await get_tree().create_timer(0.55).timeout
	anim.play("idle")
	
func croaking_anim()-> void:
	anim.play("croak")

func idle_anim() -> void:
	anim.play("idle")
	
func attack_anim() -> void:
	anim.play("attack")
	await get_tree().create_timer(0.4).timeout
	anim.play("idle")

func set_character_stats(value: CharacterStats) -> void:
	stats = value
	
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
	
	update_player()
		
func update_player() -> void:
	if not stats is CharacterStats:
		return
	
	if not is_inside_tree():
		await ready
	
	#sprite_2d.texture = stats.art
	update_stats()
	
func update_stats() -> void:
	stats_ui.update_stats(stats)

func take_damage(damage: int) -> void:
	if stats.health <= 0:
		return
	
	stats.take_damage(damage)
	
	if stats.health <= 0:
		Events.player_died.emit()
		queue_free()
