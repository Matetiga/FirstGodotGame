#extends Enemy
# this is made in order to use 'attack_cooldown' var
extends "res://scripts/enemy_class.gd"

@onready var main = get_tree().get_root().get_node("Level1")
@onready var fireball = load("res://scenes/characters/fireball.tscn")
@onready var attack_timer: Timer = $AttackTimer


func attack() -> void:
	attack_cooldown = false
	attack_timer.start()
	print("attack timer start")
	
	# This will create child nodes of the fireball inside Level1 node
	var instance = fireball.instantiate()
	instance.dir = rotation
	instance.spawnPos.x = global_position.x - 10
	instance.spawnPos.y = global_position.y + 4
	instance.spawnRot = global_rotation
	
	# this will add the fireball as a child of level1
	# and not as a child of GreenEnemy (because of 'call_deffered')
	main.add_child.call_deferred(instance)
	

func _on_attack_timer_timeout() -> void:
	attack_cooldown = true
	print("attack timer timeout")
