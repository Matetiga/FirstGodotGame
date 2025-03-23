class_name Enemy
extends CharacterBody2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
@export var speed := 50.0
@export var reach := 125
@onready var player: CharacterBody2D = %Player


# Define a backing variable
var attack_cooldown: bool = true:
	get:
		return attack_cooldown
	set(value):
		attack_cooldown = value


func _ready() -> void:
	# Connect signals programmatically if not done in the editor
	if not $Area2D.is_connected("body_entered", _on_area_2d_body_entered):
		$Area2D.connect("body_entered", _on_area_2d_body_entered)
	if not $Area2D/Timer.is_connected("timeout", _on_timer_timeout):
		$Area2D/Timer.connect("timeout", _on_timer_timeout)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	follow_player(delta)


func follow_player(delta : float) -> void:
	# to Follow the player
	if is_instance_valid(player):
		#var distance = player.position.x - position.x
		var distance = position.x - player.position.x
		if abs(distance) < reach:
			var direction = (player.global_position - global_position).normalized()
			if attack_cooldown:
				attack()
			
			# if the snake is moving, then play it's animation
			$AnimatedSprite2D.play("moving")
			if direction.x < 0:
				$AnimatedSprite2D.flip_h = true
			elif direction.x > 0:
				$AnimatedSprite2D.flip_h = false
			position.x += direction.x * speed * delta
		else :
			# if the snake is not moving, then stop animation
			$AnimatedSprite2D.play("idle")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if body.position.y < position.y - 1:
			queue_free()
		else:
			body.get_node("CollisionShape2D").queue_free()
			$Area2D/Timer.start()
			Engine.time_scale = 0.5

func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene() # Replace with function body.

func attack() -> void:
	pass
