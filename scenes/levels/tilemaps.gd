extends TileMap

@export var speed: float = 50  # Pixels per second
var start_x: float  # Store the initial X position
var move_map: bool = false  # Flag to control movement
var timer: float = 0.0  # Timer for delay

func _ready():
	start_x = position.x  # Store the original X position

func _process(delta):
	if move_map:
		position = Vector2(start_x, position.y - speed * delta)  # Move only up

func start_movement():
	await get_tree().create_timer(0.5).timeout  # Wait 0.5 seconds
	move_map = true
