extends Node
var constants = {
	FOUR_WAY = 1,
	TEE = 2,
	STRAIGHT = 4,
	ELBOW = 8,
	END = 16,
	BLOCK = 32,
	POSITION_1 = 64,
	POSITION_2 = 128,
	POSITION_3 = 256,
	POSITION_4 = 512
}

var levels = [
	{	
		name = "1",
		width = 3,
		height = 1,
		startx = 0,
		starty = 0,
		randomSeed = 123,
		type = "seeded",
		algorithm = "Recursive"
	},
	{
		name = "2",
		width = 2,
		height = 2,
		startx = 0,
		starty = 0,
		randomSeed = 123,
		type = "seeded",
		algorithm = "Recursive"
	},
	{
		name = "3",
		width = 4,
		height = 4,
		type = "prefab",
		startx = 2,
		starty = 0,
		data = [
			[ constants.END + constants.POSITION_1, constants.STRAIGHT + constants.POSITION_2, constants.STRAIGHT + constants.POSITION_3, constants.ELBOW + constants.POSITION_4],
			[ constants.END + constants.POSITION_1, constants.STRAIGHT + constants.POSITION_2, constants.STRAIGHT + constants.POSITION_3, constants.TEE + constants.POSITION_4],
			[ constants.END + constants.POSITION_1, constants.STRAIGHT + constants.POSITION_2, constants.STRAIGHT + constants.POSITION_3, constants.TEE + constants.POSITION_4],
			[ constants.END + constants.POSITION_1, constants.STRAIGHT + constants.POSITION_2, constants.STRAIGHT + constants.POSITION_3, constants.ELBOW + constants.POSITION_4]
		]
	}
]
