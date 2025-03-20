extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -230.0
@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var is_attacking = false
@onready var animation_player: AnimationPlayer = $SwipeAttack/attack/AnimationPlayer

@onready var collision_attack: CollisionShape2D = $SwipeAttack/attack/CollisionShape2D
@onready var sprite_attack: Sprite2D = $SwipeAttack/Sprite2D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("attack") and not is_attacking:
		attack()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction < 0:
		player_sprite.flip_h = true
		#sprite_attack.flip_h = true
		#sprite_attack.position.x = -17
		#collision_attack.position.x = -29
	elif direction > 0:
		player_sprite.flip_h = false
		#sprite_attack.flip_h = false
		#sprite_attack.position.x = 17
		#collision_attack.position.x = 29
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if direction == 0:
		player_sprite.play("idle")
	else:
		player_sprite.play("run")
	move_and_slide()


func attack():
	animation_player.play("attack")
	is_attacking = true
	await animation_player.animation_finished  # Wait for animation to finish
	is_attacking = false


func _on_attack_body_entered(body: Node2D) -> void:
	if body is Enemy:
		print("enemy hit")
		body.queue_free()
