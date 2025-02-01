# Level1.gd
extends Node2D

@onready var ground = $Tilemaps/Ground  # Your TileMap
@onready var victory_area = $Tilemaps/Ground/VictoryArea  # Area2D for detection
@onready var victory_screen = $VictoryScreen
var ground_speed = 10  # Your current vertical speed
var game_won = false
var movement_started = false
var start_timer = 0.5
var can_move = false
var current_level = 1  # Current level number

func _ready():
	# Debug print to confirm signals are connected
	print("Connecting signals...")
	
	# Connect victory area signal
	if victory_area:
		victory_area.body_entered.connect(_on_victory_area_body_entered)
	
	# Connect victory screen buttons using the correct signal names
	if victory_screen:
		victory_screen.connect("exit_pressed", _on_exit)
		victory_screen.connect("next_level_pressed", _on_next_level)
	
	# Ensure victory screen is hidden at start
	victory_screen.hide()

func _process(delta):
	if game_won:
		return  # Stop all movement if game is won
		
	if !movement_started:
		if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			movement_started = true
			print("Movement started!")  # Debug print
			get_tree().create_timer(start_timer).timeout.connect(_on_start_timer_timeout)
	
	# Move ground only if timer has finished and game isn't won
	if can_move and !game_won:
		ground.position.y -= ground_speed * delta

func _on_start_timer_timeout():
	can_move = true
	print("Ground can now move!")  # Debug print

func _on_victory_area_body_entered(body):
	print("Body entered: ", body.name)  # Debug print
	print("Body groups: ", body.get_groups())  # Debug print
	if "player" in body.get_groups():
		print("Victory triggered!")
		win_game()

func win_game():
	print("Game won!")
	game_won = true
	can_move = false
	
	# Mark level as completed and unlock next level
	if GameProgress.complete_level(current_level):
		print("Level progress saved successfully")
	else:
		print("Failed to save level progress")
	
	victory_screen.show_victory()

func _on_exit():
	get_tree().change_scene_to_file("res://scenes/menu/levels.tscn")

func _on_next_level():
	# Only allow proceeding to next level if it's unlocked
	var next_level = current_level + 1
	if GameProgress.is_level_unlocked(next_level):
		get_tree().change_scene_to_file("res://scenes/levels/lvl_" + str(next_level) + ".tscn")
	else:
		print("Next level is not unlocked!")
		_on_exit()  # Return to level selection if next level isn't unlocked
