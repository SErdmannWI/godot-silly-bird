extends Node

# Group interactions
const GROUP_NAME_MANAGERS: String = "Managers"

const GROUP_METHOD_START_DAY: String = "start_new_day"
const GROUP_METHOD_END_DAY: String = "end_day"

# Code Enums
# Layer Enums

# Used to communicate from Director to UI on what to do with info
enum ResponseCode {NO_NEST = -1, NEST_FULL = -2}

enum StatusCode{EGG_HATCHED = 1, EGG_BROKEN = 2}

enum XpCodes{NEST_BUILT = 1, DISCOVERY_MADE = 2, EGG_HATCHED = 3}

enum ActionType{ITEM = 1, FOOD = 2, OBSERVATION = 3}

# Day/ Night Cycle

enum DayNightCycle {NIGHT = 0, MORNING = 1, DAY = 2, EVENING = 3}
enum Weather {SUNNY = 0, CLOUDY = 1, RAINING = 2, STORM = 3}

const TIME_TEXT_MORNING: String = "Morning"
const TIME_TEXT_DAY: String = "Day"
const TIME_TEXT_EVENING: String = "Evening"
const TIME_TEXT_NIGHT: String = "Night"

const WEATHER_SUNNY: String = "Sunny"
const WEATHER_CLOUDY: String = "Cloudy"
const WEATHER_RAINING: String = "Raining"
const WEATHER_STORM: String = "Storm"

const TIME_CYCLE_INCREMENT: int = 1

# Leveling variables
# Level Thresholds
const XP_VALUES_LEVEL_0_XP_NEEDED: int = 0
const XP_VALUES_LEVEL_1_XP_NEEDED: int = 10
const XP_VALUES_LEVEL_2_XP_NEEDED: int = 20
const XP_VALUES_LEVEL_3_XP_NEEDED: int = 30
const XP_VALUES_LEVEL_4_XP_NEEDED: int = 40
const XP_VALUES_LEVEL_5_XP_NEEDED: int = 50
const XP_VALUES_LEVEL_6_XP_NEEDED: int = 60
const XP_VALUES_LEVEL_7_XP_NEEDED: int = 70
const XP_VALUES_LEVEL_8_XP_NEEDED: int = 80
const XP_VALUES_LEVEL_9_XP_NEEDED: int = 90
const XP_VALUES_LEVEL_10_XP_NEEDED: int = 100

# Key- desired level : Value- amount needed to attain desired level
const XP_LEVELING_THRESHOLDS: Dictionary = {
	0 : XP_VALUES_LEVEL_0_XP_NEEDED,
	1 : XP_VALUES_LEVEL_1_XP_NEEDED,
	2 : XP_VALUES_LEVEL_2_XP_NEEDED,
	3 : XP_VALUES_LEVEL_3_XP_NEEDED,
	4 : XP_VALUES_LEVEL_4_XP_NEEDED,
	5 : XP_VALUES_LEVEL_5_XP_NEEDED,
	6 : XP_VALUES_LEVEL_6_XP_NEEDED,
	7 : XP_VALUES_LEVEL_7_XP_NEEDED,
	8 : XP_VALUES_LEVEL_8_XP_NEEDED,
	9 : XP_VALUES_LEVEL_9_XP_NEEDED,
	10 : XP_VALUES_LEVEL_10_XP_NEEDED
}

# XP Amount gained
const XP_VALUES_NEST_BUILT: int = 10
const XP_VALUES_DISCOVERY_MADE: int = 5
const XP_VALUES_EGG_HATCHED: int = 8

const XP_AMOUNT_GAINED: Dictionary = {
	XpCodes.NEST_BUILT : XP_VALUES_NEST_BUILT,
	XpCodes.EGG_HATCHED : XP_VALUES_EGG_HATCHED,
	XpCodes.DISCOVERY_MADE : XP_VALUES_DISCOVERY_MADE
}

# Key is cycle time (1 - 300): Value is temperature
const SUNNY_TEMPERATURE_DICTIONARY: Dictionary = {
	# Morning
	1: 50,
	# Day
	75: 60,
	# Noon
	150: 80,
	# Peak Temp
	175: 85,
	# Evening
	225: 60,
	# Night
	300: 50,
	# Late Night
	375: 40
}

# Key is type of weather: Value is given dictionary
# TODO, incorporate seasons
const TEMPERATURE_DICTIONARY: Dictionary = {
	WEATHER_SUNNY: SUNNY_TEMPERATURE_DICTIONARY,

}

# UI Elements
# Colors
const COLOR_TEXT_GREEN: Color = Color(0, 0.859, 0)
const COLOR_TEXT_BLUE: Color = Color(0.384, 0.471, 1)
const COLOR_TEXT_YELLOW: Color = Color(1, 0.859, 0)
const COLOR_TEXT_RED: Color = Color(0.945, 0, 0)


# Physics Globals
const PHYSICS_GRAVITY: int = 1000
const PHYSICS_BASE_SPEED: int = 300
const PHYSICS_BASE_ACCELERATION: int = 600
const PHYSICS_BASE_FRICTION: int = 2

static func generate_uuid() -> String:
	var uuid = PackedByteArray()
	for i in range(16):
		uuid.append(randi() % 256)
		
	# Set the verions to 4 (randomly generated UUID)
	uuid[6] = (uuid[6] & 0x0f) | 0x40
	# Set the variant to DCE1.1, ITU-T X.667
	uuid[8] = (uuid[8] & 0x3F) | 0x80
	# Conver to String format
	var str_uuid = ""
	for i in range(16):
		str_uuid += "%02x" % uuid[i]
		if i == 3 or i == 5 or i == 7 or i == 9:
			str_uuid += "-"
	
	return str_uuid

