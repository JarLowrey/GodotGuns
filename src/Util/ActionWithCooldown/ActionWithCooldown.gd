extends Node

class_name GDWeaponsActionWithCooldown

export var cooldown_delay = 1.0 setget _set_cooldown_delay

signal began()
signal ended()
signal cancelled()
signal cooldown_over()
signal premature_start_attempt()

var is_in_cooldown = false
var is_acting = false
export var timer_path = "Timer"
var cooldown_timer

func _ready():
	cooldown_timer = get_node(timer_path)
	cooldown_timer.connect("timeout",self, "exit_cooldown")

func can_act():
	return not is_in_cooldown and not is_acting

func start_action():
	if(!can_act()):
		emit_signal("premature_start_attempt")
		return
	
	is_acting = true
	emit_signal("began")

func end_action():
	if(!is_acting):
		return
	
	is_acting = false
	is_in_cooldown = true

	cooldown_timer.start()
	emit_signal("ended")

func cancel_action():
	if(!is_acting):
		return
	
	is_acting = false
	#cooldown_timer.start() #still get cooldown penalty when cancelled? 
	emit_signal("cancelled")

func exit_cooldown():
	is_in_cooldown = false
	cooldown_timer.stop() #just in case this is manually called
	emit_signal("cooldown_over")

func reset():
	is_in_cooldown = false
	is_acting = false;
	cooldown_timer.stop()

func _set_cooldown_delay(value):
	cooldown_delay = value

	if(is_inside_tree()):
		cooldown_timer.wait_time = cooldown_delay