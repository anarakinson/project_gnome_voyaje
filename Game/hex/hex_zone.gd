extends Node2D


@onready var players_beacon = $Hex/PlayersBeacon
@onready var hex = $Hex

#@export var finish_zone : bool = false
@export var zone_type = zones.DEFAULT
@export var is_inserted : bool = false
@export var disabled_floating : bool = false
@export var disabled_chosing : bool = false

var near_player = false
var player_inside_hex = false
# variable to make something just after start processing
var first_turn = true

enum zones {
	DEFAULT,
	FINISH_ZONE,
	START_ZONE,
	MOUNTAIN,
	FOREST,
	WATER
}

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSettings.connect("_phase_changed", _on_phase_changed)
	players_beacon.visible = false
	hex.is_inserted = is_inserted
	hex.disable_floating = disabled_floating
	
	match zone_type:
		zones.FINISH_ZONE:
			hex.animated_sprite.play("castle")
		zones.START_ZONE:
			hex.animated_sprite.play("city")
		zones.MOUNTAIN:
			hex.animated_sprite.play("mountain")
		zones.WATER:
			hex.animated_sprite.play("water")
		zones.FOREST:
			hex.animated_sprite.play("forest")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if first_turn:
		first_turn = false
		if disabled_chosing:
			disable_chosing()

	if (near_player and not player_inside_hex and hex.is_inserted and
	GlobalSettings.current_phase == GlobalSettings.phases.ADVENTURE):
		players_beacon.visible = true
	else:
		players_beacon.visible = false



func _on_player_detection_area_entered(area):
	if area.name == "CharacterArea":
		match zone_type:
			zones.DEFAULT, zones.START_ZONE, zones.FOREST, zones.FINISH_ZONE:
				near_player = true 


func _on_player_detection_area_exited(area):
	if area.name == "CharacterArea":
		near_player = false


func _on_phase_changed(which):
	if which == GlobalSettings.phases.ADVENTURE:
		hex.hex_chosing.disabled = true
	elif which == GlobalSettings.phases.MAP:
		hex.hex_chosing.disabled = false


func _on_players_beacon_pressed():
	GlobalSettings._move_character.emit(hex.global_position)


func _on_inside_hex_area_area_entered(area):
	if area.name == "CharacterArea":
		player_inside_hex = true
		match zone_type:
			zones.FINISH_ZONE:
				GlobalSettings._victory.emit()


func _on_inside_hex_area_area_exited(area):
	if area.name == "CharacterArea":
		player_inside_hex = false

func hex_is_inserted() -> bool:
	return hex.is_inserted

func disable_chosing():
	hex.hex_chosing.disabled = true


func change_type(new_type : zones):
	match new_type:
		zones.MOUNTAIN:
			hex.animated_sprite.play("mountain")
		zones.FOREST:
			hex.animated_sprite.play("forest")
		zones.WATER:
			hex.animated_sprite.play("water")
	zone_type = new_type
