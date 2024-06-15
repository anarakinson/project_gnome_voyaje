extends Node2D

@onready var sockets = $Sockets
var field_size = 0

var AI_counter = 1
var not_occupied : Array = []
var autoinsertion_mode = false

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSettings.connect("_hex_zone_created", _on_new_hex_zone_created)
	GlobalSettings.connect("_autoinsertion_activated", _on_autoinsertion_activated)
	for sock in sockets.get_children():
		if not sock.is_occupied:
			field_size += 1
	GlobalSettings.current_socket_field_size = field_size
	pass 
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#print(AI_counter)

func _on_new_hex_zone_created():
	AI_counter += 1
	if AI_counter > 1:
		calculate_occupied()
		if not autoinsertion_mode:
			AI_counter = 0


func calculate_occupied():
	not_occupied = []
	for sock in sockets.get_children():
		if not sock.is_occupied:
			not_occupied.append(sock)
	
	if len(not_occupied) > 0:
		var idx = randi_range(0, len(not_occupied) - 1)
		GlobalSettings.socket_for_occupation = not_occupied[idx]
		GlobalSettings.time_for_occupation = true

func _on_autoinsertion_activated():
	autoinsertion_mode = true
	calculate_occupied()
