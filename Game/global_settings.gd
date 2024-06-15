extends Node

signal _phase_changed(which)
signal _move_character(where)
signal _victory
signal _hex_zone_created
signal _autoinsertion_activated
signal _new_insertion
signal _new_picked_up
signal _new_picked_down

#var current_OS = OS.get_name()
var current_OS : String = "Android"

var save_path = "user://saves/variable.save"

var players_money = 0

var current_phase = phases.MAP

enum phases {
	MAP,
	ADVENTURE
}

var current_socket_field_size = 0
var socket_for_occupation = null
var start_zone = null
var finish_zone = null
var time_for_occupation = false

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("_phase_changed", _on_phase_changed)
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

## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass




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


func _on_phase_changed(which):
	current_phase = which
