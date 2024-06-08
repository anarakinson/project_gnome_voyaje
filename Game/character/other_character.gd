extends CharacterBody2D


@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var target_location_preload = preload("res://Game/character/target_location.tscn")
var target_location : Node2D = null

var current_state = "idle"
var is_idle = true
var is_chosen = false

var where_to_go = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSettings.connect("_phase_changed", _on_phase_changed)
	GlobalSettings.connect("_move_character", _on_move_character)
	animated_sprite_2d.play("idle")
	where_to_go = global_position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if current_state == "idle":
		animated_sprite_2d.play("idle")
	elif current_state == "run":
		# flip sprite toward target location
		if global_position.x > where_to_go.x:
			animated_sprite_2d.flip_h = true
		elif global_position.x < where_to_go.x:
			animated_sprite_2d.flip_h = false
		
		# animate
		animated_sprite_2d.play("run")
		# move toward target location
		global_position = global_position.move_toward(where_to_go, 300 * delta)
		if global_position == where_to_go:
			current_state = "idle"
			
	#move_and_slide()



## if at distination - stop moving
#func _on_character_area_area_entered(area):
	#pass

func _on_phase_changed(which):
	if which == GlobalSettings.phases.ADVENTURE:
		is_chosen = true
		#GlobalSettings._lock_screen.emit("lock")
	elif which == GlobalSettings.phases.MAP:
		is_chosen = false


func _on_move_character(where):
	where_to_go = where
	current_state = "run"
