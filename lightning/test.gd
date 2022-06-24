extends Spatial

var add = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		var l = load("res://lightning.tscn").instance()
		add += 1
		l.transform.origin.x += add
		l.transform.origin.y = 4
		add_child(l)
	$lightning3.target_position = Vector3(rand_range(10,0),-6,0)
	$lightning4.target_position = Vector3(10,rand_range(8,0),0)
