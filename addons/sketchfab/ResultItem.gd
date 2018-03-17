tool
extends MarginContainer

const SafeData = preload("res://addons/sketchfab/SafeData.gd")

onready var user_name = find_node("UserName")
onready var model_name = find_node("ModelName")
onready var image = find_node("Image")

var data

func set_data(data):
	self.data = data

func _ready():
	if !data:
		return
	
	model_name.text = SafeData.string(data, "name")
	
	var user = SafeData.dictionary(data, "user")
	user_name.text = "by %s" % SafeData.string(user, "displayName")
	
	var thumbnails = SafeData.dictionary(data, "thumbnails")
	var images = SafeData.array(thumbnails, "images")
	
	var target = self.image.max_size * self.image.max_size
	var closest_diff = 10e20
	var closes_url
	for img in images:
		var size = SafeData.integer(img, "width") * SafeData.integer(img, "height")
		var diff = abs(target - size)
		if diff < closest_diff:
			closest_diff = diff
			closes_url = SafeData.string(img, "url")
	self.image.url = closes_url
