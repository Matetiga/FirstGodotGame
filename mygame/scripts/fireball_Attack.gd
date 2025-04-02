extends CharacterBody2D
# keep in mind this is an AnimatedSprite and in the video it was only a Character

@export var Speed = 100

var dir : float
var spawnPos : Vector2
var spawnRot : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = spawnPos
	global_rotation = spawnRot


func _physics_process(delta: float) -> void:
	velocity = Vector2(-Speed, 0).rotated(dir)
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.get_node("CollisionShape2D").queue_free()
		# The timeout function of this timer is found inside enemy_class.gd
		$"../GreenEnemy/Area2D/Timer".start()

		# this will delete the projectile itself
		queue_free()
		Engine.time_scale = 0.5


# To delete the fireball after some time 
func _on_life_timeout() -> void:
	queue_free()
