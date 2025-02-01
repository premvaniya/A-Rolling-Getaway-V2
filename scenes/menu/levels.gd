extends Control

@onready var back_button = $MainContainer/MarginContainer/VBoxContainer/TopBar/BackButton
@onready var level_grid = $MainContainer/MarginContainer/VBoxContainer/LevelGrid

func _ready():
	# Load saved progress
	GameProgress.load_progress()
	
	# Setup responsive layout
	setup_responsive_layout()
	
	# Connect back button signal
	#back_button.pressed.connect(_on_back_button_pressed)
	
	# Setup level buttons
	setup_level_buttons()
	
	# Apply theme settings
	apply_theme_settings()

func setup_responsive_layout():
	# Adjust grid columns based on screen width
	var screen_width = get_viewport_rect().size.x
	if screen_width < 800:
		level_grid.columns = 2
	else:
		level_grid.columns = 3

	# Connect to window resize
	get_tree().root.size_changed.connect(_on_window_resize)

func _on_window_resize():
	setup_responsive_layout()
	apply_theme_settings()

func apply_theme_settings():
	# Scale font sizes based on screen
	var base_size = min(get_viewport_rect().size.x, get_viewport_rect().size.y) * 0.05
	
	# Update title font size
	var title_label = $MainContainer/MarginContainer/VBoxContainer/TopBar/TitleLabel
	title_label.add_theme_font_size_override("font_size", base_size * 1.5)
	
	# Update button font sizes
	for i in range(1, 4):  # Adjust number based on your level count
		var button = level_grid.get_node("Level" + str(i) + "Button")
		button.add_theme_font_size_override("font_size", base_size)

func setup_level_buttons():
	for i in range(1, 4):  # Change based on your level count
		var button = level_grid.get_node("Level" + str(i) + "Button")
		button.pressed.connect(_on_level_button_pressed.bind(i))
		update_button_state(button, i)

func update_button_state(button: Button, level_number: int):
	if GameProgress.is_level_unlocked(level_number):
		button.disabled = false
		if GameProgress.is_level_completed(level_number):
			button.text = "Level " + str(level_number) + "\n✓"
		else:
			button.text = "Level " + str(level_number)
	else:
		button.disabled = true
		button.text = "Level " + str(level_number) + "\n🔒"

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")

func _on_level_button_pressed(level_number: int):
	get_tree().change_scene_to_file("res://scenes/levels/lvl_" + str(level_number) + ".tscn")
