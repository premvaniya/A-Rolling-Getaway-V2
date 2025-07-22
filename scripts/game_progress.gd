extends Node

var level_status = {
	1: {"unlocked": true, "completed": false},  # First level starts unlocke
	2: {"unlocked": false, "completed": false},
	3: {"unlocked": false, "completed": false},
}

# Called when the node enters the scene tree
func _ready():
	load_progress()  # Load saved progress when game starts

func complete_level(level_number: int):
	if level_number in level_status:
		# Mark current level as completed
		level_status[level_number]["completed"] = true
		
		# Unlock next level if it exists
		if level_number + 1 in level_status:
			level_status[level_number + 1]["unlocked"] = true
			
		# Save progress immediately after completion
		save_progress()
		
		# Return true to confirm level was completed successfully
		return true
	return false

func is_level_unlocked(level_number: int) -> bool:
	if level_number in level_status:
		return level_status[level_number]["unlocked"]
	return false

func is_level_completed(level_number: int) -> bool:
	if level_number in level_status:
		return level_status[level_number]["completed"]
	return false

func get_highest_unlocked_level() -> int:
	var highest = 1
	for level in level_status.keys():
		if level_status[level]["unlocked"]:
			highest = max(highest, level)
	return highest

func reset_progress():
	# Reset all levels except first one
	for level in level_status.keys():
		level_status[level]["completed"] = false
		level_status[level]["unlocked"] = (level == 1)
	save_progress()

func save_progress():
	var save_file = FileAccess.open("user://game_progress.save", FileAccess.WRITE)
	if save_file:
		save_file.store_var(level_status)
		return true
	return false

func load_progress():
	if FileAccess.file_exists("user://game_progress.save"):
		var save_file = FileAccess.open("user://game_progress.save", FileAccess.READ)
		if save_file:
			var loaded_data = save_file.get_var()
			# Validate loaded data
			if typeof(loaded_data) == TYPE_DICTIONARY:
				level_status = loaded_data
				return true
	return false
