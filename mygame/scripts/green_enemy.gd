extends Enemy
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_attacking = false

func attack() -> void:
	if not is_attacking:
		is_attacking = true
		animation_player.play("FireAttackGreenEnemy")
		await animation_player.animation_finished
		is_attacking = false
