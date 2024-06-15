extends Node2D


@onready var deck = $Deck
@onready var hexes_list = $Hexes
@onready var start_button = $Deck/StartButton
@onready var zone_type_counter_label = $Deck/Label

@onready var hex_zone_1 = $Hexes/HexZone1
@onready var hex_zone_2 = $Hexes/HexZone2
@onready var hex_zone_4 = $Hexes/HexZone4
@onready var hex_zone_3 = $Hexes/HexZone3

var zone_type_counter = 0
var hex_spawning_node = preload("res://Game/hex/hex_zone.tscn")

var spawning_zone1 = Vector2()
var spawning_zone2 = Vector2()
var spawning_zone3 = Vector2()
var spawning_zone4 = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSettings.connect("_phase_changed", _on_phase_changed)	
	zone_type_counter = GlobalSettings.current_socket_field_size
	zone_type_counter_label.text = "Hexes left:\n" + str(zone_type_counter)
	
	spawning_zone1 = hex_zone_1.global_position
	spawning_zone2 = hex_zone_2.global_position
	spawning_zone3 = hex_zone_3.global_position
	spawning_zone4 = hex_zone_4.global_position
	start_button.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if zone_type_counter <= 0:
		start_button.visible = true
	autoinsertion()
	
	if hex_zone_1 != null:
		if hex_zone_1.hex_is_inserted():
			hex_zone_1.disable_chosing()
			hex_zone_1 = get_hex_zone(spawning_zone1)
	if hex_zone_2 != null:
		if hex_zone_2.hex_is_inserted():
			hex_zone_2.disable_chosing()
			hex_zone_2 = get_hex_zone(spawning_zone2)
	if hex_zone_3 != null:
		if hex_zone_3.hex_is_inserted():
			hex_zone_3.disable_chosing()
			hex_zone_3 = get_hex_zone(spawning_zone3)
	if hex_zone_4 != null:
		if hex_zone_4.hex_is_inserted():
			hex_zone_4.disable_chosing()
			hex_zone_4 = get_hex_zone(spawning_zone4)


func _on_phase_changed(which):
	if which == GlobalSettings.phases.ADVENTURE:
		deck.visible = false
		#GlobalSettings._lock_screen.emit("lock")
	elif which == GlobalSettings.phases.MAP:
		deck.visible = true


func get_hex_zone(spawn_position):
	var new_hex_zone = null
	if zone_type_counter > 4:
		new_hex_zone = hex_spawning_node.instantiate()
		chose_zone_type(new_hex_zone)
		hexes_list.add_child(new_hex_zone)
		new_hex_zone.global_position = spawn_position
		new_hex_zone.hex.start_position = spawn_position
		new_hex_zone.scale = Vector2(1.8, 1.8)
		new_hex_zone.z_index = 1
		new_hex_zone.y_sort_enabled = true

	zone_type_counter -= 1
	GlobalSettings._hex_zone_created.emit()
	zone_type_counter_label.text = "Hexes left:\n" + str(zone_type_counter)

	return new_hex_zone


func chose_zone_type(hex_zone_n):
	if zone_type_counter % 3 == 0:
		hex_zone_n.zone_type = hex_zone_n.zones.MOUNTAIN
	if zone_type_counter % 4 == 0:
		hex_zone_n.zone_type = hex_zone_n.zones.FOREST
	if zone_type_counter % 6 == 0:
		hex_zone_n.zone_type = hex_zone_n.zones.WATER


func _on_start_button_pressed():
	GlobalSettings._phase_changed.emit(GlobalSettings.phases.ADVENTURE)


func autoinsertion():
	if GlobalSettings.time_for_occupation:
		for hexzone in hexes_list.get_children():
			if hexzone != null and not hexzone.hex_is_inserted():
				hexzone.hex.nearest_socket = GlobalSettings.socket_for_occupation
				GlobalSettings.time_for_occupation = false
				break


#func _on_auto_insert_pressed():
	


func _on_button_pressed():
	GlobalSettings._autoinsertion_activated.emit()
