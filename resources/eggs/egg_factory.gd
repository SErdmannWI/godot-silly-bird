extends Node

var mourning_dove_type: EggType = preload(FilePaths.RESOURCE_EGG_MOURNING_DOVE)
var cardinal_type: EggType = preload(FilePaths.RESOURCE_EGG_CARDINAL)

func create_egg(type_name: String, egg_location: String, egg_number: int) -> Egg:
	var egg_type: EggType
	
	match type_name:
		
		BirdGlobals.BIRD_TYPE_MOURNING_DOVE:
			egg_type = mourning_dove_type
		
		BirdGlobals.BIRD_TYPE_CARDINAL:
			egg_type = cardinal_type
		
		_:
			egg_type = mourning_dove_type
	
	var egg: Egg = Egg.new(egg_type, egg_location, egg_number)
	
	return egg
