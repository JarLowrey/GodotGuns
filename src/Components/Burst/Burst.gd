extends Node

class_name GDWeaponsBurst

var current_attack_in_burst = 0
export var attacks_in_burst = 1
export var burst_delay = 1.0
export var post_burst_delay = 1.0

onready var weapon = get_node(GDWeaponsWeapon.WEAPON_PATH_FROM_COMPONENT)

func _ready():
	weapon.connect("ended",self,"_set_weapon_delay")
	if weapon.magazine != null:
		weapon.magazine.connect("ended",self,"reset_current_attack_in_burst")

func _set_weapon_delay():
	current_attack_in_burst += 1
	
	var delay = post_burst_delay
	if current_attack_in_burst < attacks_in_burst:
		delay = burst_delay
	
	weapon.cooldown_delay = delay
	
	if current_attack_in_burst == attacks_in_burst:
		current_attack_in_burst = 0

func reset_current_attack_in_burst():
	current_attack_in_burst = 0