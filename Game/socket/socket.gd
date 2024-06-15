extends Node2D


@export var zone_type = zone_types.DEFAULT
@export var is_occupied = false
@export var num = 0

@onready var animated_sprite_2d = $AnimatedSprite2D

var default_color : Color

enum zone_types {
	DEFAULT,
	START,
	FINISH,
}

$Label.text = str(num)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.visible = false

	default_color = animated_sprite_2d.modulate

	pass # Replace with function body.


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	##print(num, " " , is_occupied)
	##modulate.a8 = 255
	#pass




	

func change_color():
	if is_occupied:
		animated_sprite_2d.modulate = Color(0, 100, 255)
	else:
		animated_sprite_2d.modulate = default_color
