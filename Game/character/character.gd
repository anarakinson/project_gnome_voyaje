extends Node2D


@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var target_location_preload = preload("res://Game/character/target_location.tscn")
var target_location : Node2D = null

var current_state = "idle"
var is_idle = true
var is_chosen = false

var where_to_go = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite_2d.play("idle")
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
			
	if Input.is_action_just_pressed("tap") and is_chosen == true:
		is_chosen = false
		where_to_go = get_global_mouse_position()
		current_state = "run"
		target_location = target_location_preload.instantiate()
		get_parent().add_child(target_location)
		target_location.global_position = get_global_mouse_position()


	#if Input.is_action_just_pressed("tap") and is_chosen == true:
		#pass

func _on_player_choosing_pressed():
	is_chosen = true


func _on_character_area_area_entered(area):
	if area.name == "TargetLocationArea":
		print("aaaaaa")
		await get_tree().create_timer(0.2).timeout
		current_state = "idle"
		target_location = null
		area.get_parent().free()
		
