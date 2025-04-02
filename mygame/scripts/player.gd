extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -330.0
@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var is_attacking = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer

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
	var direction := Input.get_axis("move_left", "move_right")
	if not is_attacking:
		if direction < 0:
			player_sprite.flip_h = true
			sprite_attack.flip_h = true
			sprite_attack.position.x = -17
			collision_attack.position.x = -29
		elif direction > 0:
			player_sprite.flip_h = false
			sprite_attack.flip_h = false
			sprite_attack.position.x = 17
			collision_attack.position.x = 29
	
	# Player Movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Animations
	if direction == 0:
		player_sprite.play("idle")
	else:
		player_sprite.play("run")

	move_and_slide()


func attack():
	is_attacking = true
	animation_player.play("attack")
	# Overlapping_areas works better than "body_entered" (area's signal)
	var overlapping_object = $SwipeAttack/attack.get_overlapping_areas()
	for object in overlapping_object:
		var parent = object.get_parent()
		if parent is Enemy:
			print(parent.name)
			parent.queue_free()
	
	# if is_attacking's value changed inside the Animation tab, bug more likely to happen
	await animation_player.animation_finished
	is_attacking = false
	print("attack done")
