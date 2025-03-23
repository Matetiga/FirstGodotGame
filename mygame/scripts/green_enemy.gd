#extends Enemy
# this is made in order to use 'attack_cooldown' var
extends "res://scripts/enemy_class.gd"
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_attacking = false
@onready var attack_timer: Timer = $AttackTimer

func attack() -> void:
	attack_cooldown = false
	attack_timer.start()
	print("attack timer start")

func _on_attack_timer_timeout() -> void:
	print("attack timer timeout")
	animation_player.play("fireball_attack")
	await animation_player.animation_finished
	attack_cooldown = true
