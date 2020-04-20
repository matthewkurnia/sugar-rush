extends Node

const ERROR_SOUND = preload("res://SFX/Misc/Error.tscn")
const criticalhealth = 0.3
const GUNMAP = {
	"ref_name" : {
		1 : "ButterscotchBizon",
		2 : "CandyCaneShotgun",
		3 : "ConeLauncher",
		4 : "DoubleCandyCaneShotgun",
		5 : "GelatinGauss",
		6 : "LMG",
		7 : "MintyMagnum",
		8 : "Oshea",
		9 : "PeppermintPistol",
		10 : "Popsickle",
		11 : "SkittleScatter",
		12 : "SMG"
	},
	"display_name" : {
		1 : "Butterscotch Bizon",
		2 : "Candy Cane Shotgun",
		3 : "Cone Launcher",
		4 : "Double Cane Shotgun",
		5 : "Gelatin Gauss",
		6 : "Light Machine Gum",
		7 : "Minty Magnum",
		8 : "O'Shea Jackson Sr.",
		9 : "Peppermint Pistol",
		10 : "Popsickle",
		11 : "Skittle Scatter",
		12 : "Sub Machine Gum"
	},
	"info" : {
		1 : "Fast, but inaccurate.",
		2 : "Classic.",
		3 : "Shoots ice cream shells which explode on impact.",
		4 : "Double the fun.",
		5 : "Can be charged to inflict more damage.",
		6 : "Bad pun",
		7 : "Like the pistol, but less useless",
		8 : "Shoots ice cubes, slows enemies on impact",
		9 : "Standard issue.",
		10 : "Bad pun #2",
		11 : "Fires a large spread of skittles.",
		12 : "Bad pun #3"
	},
	"damage" : {
		1 : 5,
		2 : 8,
		3 : 80,
		4 : 8,
		5 : 40,
		6 : 6,
		7 : 28,
		8 : 5,
		9 : 14,
		10 : 25,
		11 : 6,
		12 : 6
	},
	"nbullets" : {
		1 : 1,
		2 : 4,
		3 : 1,
		4 : 8,
		5 : 1,
		6 : 1,
		7 : 1,
		8 : 1,
		9 : 1,
		10 : 1,
		11 : 10,
		12 : 1
	},
	"firerate" : {
		1 : 800,
		2 : 100,
		3 : 50,
		4 : 60,
		5 : 75,
		6 : 500,
		7 : 120,
		8 : 510,
		9 : 160,
		10 : 170,
		11 : 66,
		12 : 670
	},
	"spread" : {
		1 : 15,
		2 : 15,
		3 : 1,
		4 : 22,
		5 : 0,
		6 : 4,
		7 : 0,
		8 : 10,
		9 : 3,
		10 : 3,
		11 : 30,
		12 : 4
	},
	"packed_scene" : {
		1 : preload("res://Guns/GunScenes/ButterscotchBizon.tscn"),
		2 : preload("res://Guns/GunScenes/CandyCaneShotgun.tscn"),
		3 : preload("res://Guns/GunScenes/ConeLauncher.tscn"),
		4 : preload("res://Guns/GunScenes/DoubleCandyCaneShotgun.tscn"),
		5 : preload("res://Guns/GunScenes/GelatinGauss.tscn"),
		6 : preload("res://Guns/GunScenes/LMG.tscn"),
		7 : preload("res://Guns/GunScenes/MintyMagnum.tscn"),
		8 : preload("res://Guns/GunScenes/Oshea.tscn"),
		9 : preload("res://Guns/GunScenes/PeppermintPistol.tscn"),
		10 : preload("res://Guns/GunScenes/Popsickle.tscn"),
		11 : preload("res://Guns/GunScenes/SkittleScatter.tscn"),
		12 : preload("res://Guns/GunScenes/SMG.tscn")
	},
	"sound" : {
		1 : preload("res://SFX/GunShot/ButterscotchBizon.tscn"),
		2 : preload("res://SFX/GunShot/CandyCaneShotgun.tscn"),
		3 : preload("res://SFX/GunShot/ConeLauncher.tscn"),
		4 : preload("res://SFX/GunShot/DoubleCandyCaneShotgun.tscn"),
		5 : preload("res://SFX/GunShot/GelatinGauss.tscn"),
		6 : preload("res://SFX/GunShot/LMG.tscn"),
		7 : preload("res://SFX/GunShot/MintyMagnum.tscn"),
		8 : preload("res://SFX/GunShot/Oshea.tscn"),
		9 : preload("res://SFX/GunShot/PeppermintPistol.tscn"),
		10 : preload("res://SFX/GunShot/Popsickle.tscn"),
		11 : preload("res://SFX/GunShot/SkittleScatter.tscn"),
		12 : preload("res://SFX/GunShot/SMG.tscn")
	},
	"textures" : {
		1 : preload("res://Guns/Assets/Sprites/Guns/ButterscotchBizon.png"),
		2 : preload("res://Guns/Assets/Sprites/Guns/CandyCaneShotgun.png"),
		3 : preload("res://Guns/Assets/Sprites/Guns/ConeLauncher.png"),
		4 : preload("res://Guns/Assets/Sprites/Guns/DoubleCandyCaneShotgun.png"),
		5 : preload("res://Guns/Assets/Sprites/Guns/GelatinGauss.png"),
		6 : preload("res://Guns/Assets/Sprites/Guns/LMG.png"),
		7 : preload("res://Guns/Assets/Sprites/Guns/MintyMagnum.png"),
		8 : preload("res://Guns/Assets/Sprites/Guns/OShea.png"),
		9 : preload("res://Guns/Assets/Sprites/Guns/PeppermintPistol.png"),
		10 : preload("res://Guns/Assets/Sprites/Guns/Popsickle.png"),
		11 : preload("res://Guns/Assets/Sprites/Guns/SkittleScatter.png"),
		12 : preload("res://Guns/Assets/Sprites/Guns/SMG.png")
	},
	"bullet_type" : {
		"Caramel" : preload("res://Guns/BulletScenes/Caramel.tscn"),
		"Gelatin" : preload("res://Guns/BulletScenes/Gelatin.tscn"),
		"Gum" : preload("res://Guns/BulletScenes/Gum.tscn"),
		"IceCream" : preload("res://Guns/BulletScenes/IceCream.tscn"),
		"IceCube" : preload("res://Guns/BulletScenes/IceCube.tscn"),
		"Minty" : preload("res://Guns/BulletScenes/Minty.tscn"),
		"Sickle" : preload("res://Guns/BulletScenes/Sickle.tscn"),
		"Skittle" : preload("res://Guns/BulletScenes/Skittle.tscn"),
		"Strawberry" : preload("res://Guns/BulletScenes/Strawberry.tscn")
	}
}

const SHOPMAP = {
	"texture" : {
		1 : preload("res://Misc/HeartFilled.png"),
		2 : preload("res://Misc/HeartEmpty.png"),
		3 : preload("res://Misc/Power.png"),
		4 : preload("res://Misc/Speed.png")
	},
	"price" : {
		1 : 150,
		2 : 225,
		3 : 450,
		4 : 40
	},
	"info" : {
		1 : "Health +1",
		2 : "Max Health +1",
		3 : "Damage x2",
		4 : "Speed + 20%"
	},
	"name" : {
		1 : "Heart of Cherry",
		2 : "Essence Vessel",
		3 : "Hot Power",
		4 : "Sweet Swiftness"
	},
	"method" : {
		1 : "shop_health",
		2 : "shop_container",
		3 : "shop_power",
		4 : "shop_speed"
	}
}

onready var music_arr = [
	MusicBoss,
	Music1,
	Music2,
	Music3
]

var shop_health = funcref(self, "shop_health")
var shop_container = funcref(self, "shop_container")
var shop_power = funcref(self, "shop_power")
var shop_speed = funcref(self, "shop_speed")

var maxhealth = 5
var currhealth = 5
var damagemulti = 1
var coin_collected = 0
var dash_health = 1
var maxvelo = 600
var power_collected = 0
var speed_collected = 0
var curr_gun = 9
var c_gun_dmg = 12
var bs = false

var buffer_music = false
var curr_music
var ui

func reset_player_vars():
	maxhealth = 5
	currhealth = 5
	damagemulti = 1
	coin_collected = 0
	dash_health = 1
	maxvelo = 600
	power_collected = 0
	speed_collected = 0
	curr_gun = 9
	c_gun_dmg = 12
	bs = false

func _ready():
	print(music_arr)

func shop_health():
	if currhealth >= maxhealth:
		return false
	currhealth += 1
	return true

func shop_container():
	if !ui:
		return false
	var health_ref = ui.get_node("Elements/Player/VBoxContainer/Health")
	var heart_instance = health_ref.HEART.instance()
	health_ref.add_child(heart_instance)
	health_ref.heart_empty.push_back(heart_instance)
	maxhealth += 1
	return true

func shop_power():
	if ui:
		var p_ref = ui.get_node("Elements/Player/VBoxContainer/Power")
		var inst = p_ref.ICON.instance()
		p_ref.add_child(inst)
	damagemulti *= 2
	power_collected += 1
	return true

func shop_speed():
	if ui:
		var p_ref = ui.get_node("Elements/Player/VBoxContainer/Speed")
		var inst = p_ref.ICON.instance()
		p_ref.add_child(inst)
	maxvelo *= 1.2
	speed_collected += 1
	return true

func busy_sound():
	if bs:
		return false
	bs = true
	yield(get_tree().create_timer(0.1), "timeout")
	bs = false
	return true
