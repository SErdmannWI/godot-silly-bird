extends Label

const STATUS_SLEEP:String = "Sleeping"
const STATUS_AWAKE:String = "Awake"


func _ready():
	text = STATUS_AWAKE


func on_sleep_toggle():
	if text == STATUS_AWAKE:
		text = STATUS_SLEEP
	else:
		text = STATUS_AWAKE
