extends Node

# Card-related events
signal card_drag_started(card_ui: CardUI)
signal card_drag_ended(card_ui: CardUI)
signal card_aim_started(card_ui: CardUI)
signal card_aim_ended(card_ui: CardUI)
signal card_played(card: Card)

signal card_tooltip_requested

signal selecting_rewards(card: Card)

signal draw_card_played(amount)

# player related events
signal player_hand_drawn
signal player_hand_discarded
signal player_turn_ended
signal player_died

signal burn_applied
signal thirsty_applied
signal thirsty_expired
signal dairy_applied


# enemy related events
signal enemy_action_completed(enemy: Enemy)
signal enemy_turn_ended
signal enemy_died(enemy: Enemy)

# animation related events
# player
signal time_to_croak
signal back_to_idle
signal attack_played
signal non_attack_played

signal card_playedd

#enemy
signal target_damaged
signal target_dead
signal spell_casted
signal enemy_dead
signal get_acting_enemies(enemies: Array[Enemy])

#card pile events
signal card_pile_opened
signal card_pile_closed


# battle related events
signal battle_over_screen_requested(text: String, type: BattleOverPanel.Type)
signal battle_won
signal status_tooltip_requested(statuses: Array[Status])

#Map-related events
signal map_exited(room)

#shop-related events
signal shop_exited

#pond related events
signal campfire_exited

#trasure related events
signal treasure_exited

#battle reward related events
signal battle_reward_exited

# treasure room related events
signal treasure_room_exited
