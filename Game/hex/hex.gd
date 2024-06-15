extends Node2D


@onready var animated_sprite = $AnimatedSprite2D
@onready var hex_chosing = $HexChosing

var disable_floating : bool = false

var start_position = Vector2()

var is_picked_up = false 
var is_inserted = false
var is_idle = true

# sockets inside hex radius
var nearest_sockets : Array = []
# nearest socket to hex
var nearest_socket = null
# socket where hex is inserted
var occupied_socket = null

# point to make hexes floating when idle
var idle_start_position = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	start_position = global_position
	_on_timer_timeout()
	if (GlobalSettings.current_OS == "Android" or GlobalSettings.current_OS == "iOS"):
		pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_picked_up:
		is_idle = false
		#global_position = get_global_mouse_position()
		global_position = global_position.move_toward(get_global_mouse_position(), 10_000 * delta)
		if len(nearest_sockets) > 0:
			calculate_nearest()
	elif (nearest_socket != null):
		insertion(delta)
	elif (not is_inserted and nearest_socket == null and not is_idle):
		global_position = global_position.move_toward(start_position, 3500 * delta)
		if global_position == start_position:
			is_idle = true
	elif (is_idle and not disable_floating):
		global_position = global_position.move_toward(idle_start_position, 2 * delta)
	
		
	if (nearest_socket not in nearest_sockets):
		nearest_socket = null


func _on_hex_chosing_button_down():
	if is_inserted:
		is_inserted = false
		if occupied_socket != null:
			occupied_socket.is_occupied = false
			occupied_socket.change_color()
			occupied_socket = null
	is_picked_up = true
	z_index += 5
	#GlobalSettings._new_picked_up.emit()

func _on_hex_chosing_button_up():
	is_picked_up = false
	z_index -= 5
	GlobalSettings._new_picked_down.emit()


func insertion(delta):
	if nearest_socket == null:
		return
	global_position = nearest_socket.global_position
	#global_position = global_position.move_toward(nearest_socket.global_position, 3500*delta)
	#if global_position == nearest_socket.global_position:
	is_idle = false
	is_inserted = true
	occupied_socket = nearest_socket
	occupied_socket.is_occupied = true
	occupied_socket.change_color()
	self.reparent(occupied_socket)


func calculate_nearest():
	if len(nearest_sockets) <= 0:
		nearest_socket = null
	var nearest = nearest_sockets[0]
	for socket in nearest_sockets:
		if nearest.is_occupied:
			nearest = socket
			continue
		var distance = global_position.distance_to(nearest.global_position)
		var new_distance = global_position.distance_to(socket.global_position)
		if (new_distance < distance and not socket.is_occupied):
			nearest = socket
	if not nearest.is_occupied:
		nearest_socket = nearest
		#nearest_socket.modulate.a8 = 100
	


func _on_socket_detection_area_entered(area):
	if area.name == "SocketArea":
		nearest_sockets.append(area.get_parent())


func _on_socket_detection_area_exited(area):
	if area.name == "SocketArea":
		nearest_sockets.erase(area.get_parent())


# make figures floating when idle 
func _on_timer_timeout():
	idle_start_position.x = start_position.x + randi_range(-25, 25)
	idle_start_position.y = start_position.y + randi_range(-25, 25)


#
#func _on_hex_chosing_pressed():
	#GlobalSettings._new_picked_up.emit()
