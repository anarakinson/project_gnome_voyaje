extends Node

signal _lock_screen(state)

#var current_OS = OS.get_name()
var current_OS : String = "Android"

var save_path = "user://saves/variable.save"

var players_money = 0

var screen_locked = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#ask permissions for mobile
	OS.request_permissions()
	# make save directorie
	var dir = DirAccess.open("user://")
	dir.make_dir("saves")
	DirAccess.make_dir_absolute("user://saves")
	
	print(current_OS)
	match current_OS:
		"Windows", "macOS", "Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD":
			get_window().move_to_center()
		"Android", "iOS":
			DisplayServer.window_set_size(Vector2(648 / 4 * 3, 1152 / 4 * 3))
			get_window().move_to_center()
			#MobileAds.initialize()
		"Web":
			print("Web")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func save_game():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	
	file.store_var(players_money)
	
	file.close()


func load_game():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
	
		players_money = file.get_var()
	
		file.close()
	else:
		pass
