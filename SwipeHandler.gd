extends Node2D

signal swiped(direction)

var first_touch_position := Vector2.ZERO
var touch_release_position := Vector2.ZERO
var swiping := false

export var swipe_limit : float
export var touch_y_limit : int

var swipe_start

var quick_trigger = 150

func _ready():
	set_process(not OS.has_touchscreen_ui_hint())
	set_process_input(OS.has_touchscreen_ui_hint())

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			swipe_start = event.position
		elif swipe_start != null:
			var distance = swipe_start.distance_to(event.position)
			if distance > swipe_limit:
				calculate_swipe(swipe_start.direction_to(event.position))
	if event is InputEventScreenDrag:
		if abs(event.speed.x) > quick_trigger || abs(event.speed.y) > quick_trigger:
			if swipe_start != null:
				calculate_swipe((swipe_start.direction_to(event.position)))
				print(swipe_start.direction_to(event.position))
				swipe_start = null

func _process(_delta):
	if Input.is_action_just_pressed("touch"):
		if ( get_global_mouse_position().y > touch_y_limit):
			first_touch_position = get_global_mouse_position()
			swiping = true
	if Input.is_action_just_released("touch") and swiping :
		touch_release_position = get_global_mouse_position()
		calculate_direction()
		swiping = false
		
func calculate_direction():
	var swipe_vector = touch_release_position - first_touch_position
	if swipe_vector.length() > swipe_limit:
		var temp = rad2deg(swipe_vector.angle()) + 180 # right = 0
		first_touch_position = Vector2.ZERO
		touch_release_position = Vector2.ZERO
	
		if temp > 45 and temp <= 135:
			emit_signal("swiped", Vector2.UP)
		elif temp > 135 and temp <= 225:
			emit_signal("swiped", Vector2.RIGHT)
		elif temp > 225 and temp <= 300:
			emit_signal("swiped", Vector2.DOWN)
		else:
			emit_signal("swiped", Vector2.LEFT)
	
	
func calculate_swipe(dist):
	if dist.x > .5:
		emit_signal("swiped", Vector2.RIGHT)
	elif dist.x < -.5:
		emit_signal("swiped", Vector2.LEFT)
	elif dist.y > .5:
		emit_signal("swiped", Vector2.DOWN)
	elif dist.y < -.5:
		emit_signal("swiped", Vector2.UP)