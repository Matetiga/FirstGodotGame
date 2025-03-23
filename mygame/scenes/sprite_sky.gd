extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

@onready var player: CharacterBody2D = %Player
@onready var camera_2d: Camera2D = $"../../../Player/Camera2D"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.x = player.position.x
	global_position.y = player.position.y + camera_2d.position.y
