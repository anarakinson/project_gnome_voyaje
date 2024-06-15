extends Node2D


@onready var deck = $Deck
@onready var hexes_list = $Hexes
@onready var start_button = $Deck/StartButton
@onready var zone_type_counter_label = $Deck/Label

@onready var hex_zone_1 = $Hexes/HexZone1
@onready var hex_zone_2 = $Hexes/HexZone2
@onready var hex_zone_3 = $Hexes/HexZone3

@onready var spawning_area_1 = $Deck/SpawningZones/SpawningZone1/CollisionShape2D
@onready var spawning_area_2 = $Deck/SpawningZones/SpawningZone2/CollisionShape2D
@onready var spawning_area_3 = $Deck/SpawningZones/SpawningZone3/CollisionShape2D


var zone_type_counter = 0
var hex_spawning_node = preload("res://Game/hex/hex_zone.tscn")

var spawning_zone1 = Vector2()
var spawning_zone2 = Vector2()
var spawning_zone3 = Vector2()



# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSettings.connect("_new_insertion", _on_new_insertion)
	GlobalSettings.connect("_phase_changed", _on_phase_changed)
	GlobalSettings.connect("_new_picked_down", _on_new_picked_down)
	
	zone_type_counter = GlobalSettings.current_socket_field_size
	zone_type_counter_label.text = "Hexes left:\n" + str(zone_type_counter)
	
	set_spawning_zones()
	calculate_start_position()
	start_button.visible = false
	hexes_list.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if zone_type_counter <= 0:
		start_button.visible = true
	autoinsertion()
	#set_spawning_zones()


func _on_phase_changed(which):
	if which == GlobalSettings.phases.ADVENTURE:
		deck.visible = false
	elif which == GlobalSettings.phases.MAP:
		deck.visible = true


func get_hex_zone(spawn_position):
	var new_hex_zone = null
	if zone_type_counter > 3:
		new_hex_zone = hex_spawning_node.instantiate()
		chose_zone_type(new_hex_zone)
		hexes_list.add_child(new_hex_zone)
		new_hex_zone.global_position = spawn_position
		new_hex_zone.hex.start_position = spawn_position
		new_hex_zone.scale = Vector2(1.8, 1.8)
		new_hex_zone.z_index = 3
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


func _on_auto_insert_pressed():
	GlobalSettings._autoinsertion_activated.emit()

func _on_new_insertion():
	#zone_type_counter -= 1
	zone_type_counter_label.text = "Hexes left:\n" + str(zone_type_counter)
	calculate_zone_condition()

func _on_new_picked_down():
	set_spawning_zones()
	calculate_start_position()

func set_spawning_zones():
	spawning_zone1 = spawning_area_1.global_position
	spawning_zone2 = spawning_area_2.global_position
	spawning_zone3 = spawning_area_3.global_position


func calculate_zone_condition():
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

func calculate_start_position():
	if hex_zone_1 != null:
		if not hex_zone_1.hex_is_inserted():
			hex_zone_1.hex.start_position = spawning_zone1
	if hex_zone_2 != null:
		if not hex_zone_2.hex_is_inserted():
			hex_zone_2.hex.start_position = spawning_zone2
	if hex_zone_3 != null:
		if not hex_zone_3.hex_is_inserted():
			hex_zone_3.hex.start_position = spawning_zone3
