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

var logoData = [
	[ constants.FOUR_WAY, constants.ELBOW, constants.ELBOW, constants.END, constants.END, constants.END, constants.ELBOW, constants.ELBOW],
	[ constants.STRAIGHT, constants.STRAIGHT, constants.TEE, constants.STRAIGHT, constants.STRAIGHT, constants.STRAIGHT, constants.ELBOW, constants.ELBOW],
	[ constants.END, constants.END, constants.ELBOW, constants.ELBOW, constants.ELBOW, constants.END, constants.ELBOW, constants.ELBOW],
]

var levels = [
	{	
		name = "1",
		width = 3,
		height = 1,
		startx = -1,
		starty = -1,
		randomSeed = 123,
		type = "seeded",
		algorithm = "Recursive"
	},	
	{	
		name = "2",
		width = 2,
		height = 2,
		startx = -1,
		starty = -1,
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
		starty = -1,
		data = [
			[ constants.END + constants.POSITION_1, constants.STRAIGHT + constants.POSITION_2, constants.STRAIGHT + constants.POSITION_3, constants.ELBOW + constants.POSITION_4],
			[ constants.END + constants.POSITION_1, constants.STRAIGHT + constants.POSITION_2, constants.STRAIGHT + constants.POSITION_3, constants.TEE + constants.POSITION_4],
			[ constants.END + constants.POSITION_1, constants.STRAIGHT + constants.POSITION_2, constants.STRAIGHT + constants.POSITION_3, constants.TEE + constants.POSITION_4],
			[ constants.END + constants.POSITION_1, constants.STRAIGHT + constants.POSITION_2, constants.STRAIGHT + constants.POSITION_3, constants.ELBOW + constants.POSITION_4]
		]
	},	
	{	
		name = "4",
		width = 3,
		height = 2,
		startx = -1,
		starty = -1,
		randomSeed = 1223,
		type = "seeded",
		algorithm = "Recursive"
	},	
	{	
		name = "5",
		width = 3,
		height = 2,
		startx = -1,
		starty = -1,
		randomSeed = 123,
		type = "seeded",
		algorithm = "Recursive"
	},	
	{	
		name = "6",
		width = 3,
		height = 3,
		startx = 1,
		starty = 1,
		randomSeed = 223,
		type = "seeded",
		algorithm = "Recursive"
	},	
	{	
		name = "7",
		width = 3,
		height = 3,
		startx = 1,
		starty = 1,
		randomSeed = 124,
		type = "seeded",
		algorithm = "Recursive"
	},	
	{	
		name = "8",
		width = 3,
		height = 3,
		startx = -1,
		starty = -1,
		randomSeed = 123,
		type = "seeded",
		algorithm = "Recursive"
	},	
	{	
		name = "9",
		width = 3,
		height = 4,
		startx = -1,
		starty = -1,
		randomSeed = 133,
		type = "seeded",
		algorithm = "Recursive"
	},	
	{	
		name = "10",
		width = 3,
		height = 4,
		startx = -1,
		starty = -1,
		randomSeed = 1333,
		type = "seeded",
		algorithm = "Recursive"
	},	
	{	
		name = "11",
		width = 4,
		height = 4,
		startx = -1,
		starty = -1,
		randomSeed = 1323,
		type = "seeded",
		algorithm = "Recursive"
	},	
	{	
		name = "12",
		width = 4,
		height = 4,
		startx = -1,
		starty = -1,
		randomSeed = 1253,
		type = "seeded",
		algorithm = "Recursive"
	},	
	{	
		name = "13",
		width = 5,
		height = 5,
		startx = -1,
		starty = -1,
		randomSeed = 1333,
		type = "seeded",
		algorithm = "Recursive"
	},	
	{	
		name = "14",
		width = 5,
		height = 5,
		startx = -1,
		starty = -1,
		randomSeed = 1243,
		type = "seeded",
		algorithm = "Recursive"
	},	
	{	
		name = "15",
		width = 6,
		height = 6,
		startx = -1,
		starty = -1,
		randomSeed = 24,
		type = "seeded",
		algorithm = "Recursive"
	},	
	{	
		name = "16",
		width = 6,
		height = 6,
		startx = -1,
		starty = -1,
		randomSeed = 45,
		type = "seeded",
		algorithm = "Recursive"
	},	
	{	
		name = "17",
		width = 6,
		height = 6,
		startx = -1,
		starty = -1,
		randomSeed = 45,
		type = "seeded",
		algorithm = "Recursive"
	},	
	{	
		name = "18",
		width = 6,
		height = 8,
		startx = -1,
		starty = -1,
		randomSeed = 1223,
		type = "seeded",
		algorithm = "Recursive"
	},	
	{	
		name = "19",
		width = 6,
		height = 8,
		startx = -1,
		starty = -1,
		randomSeed = 1235,
		type = "seeded",
		algorithm = "Recursive"
	},	
	{	
		name = "20",
		width = 6,
		height = 8,
		startx = -1,
		starty = -1,
		randomSeed = 1233,
		type = "seeded",
		algorithm = "Recursive"
	},	
	{	
		name = "21",
		width = 7,
		height = 9,
		startx = -1,
		starty = -1,
		randomSeed = 1213,
		type = "seeded",
		algorithm = "Recursive"
	},	
	{	
		name = "22",
		width = 7,
		height = 9,
		startx = -1,
		starty = -1,
		randomSeed = 133,
		type = "seeded",
		algorithm = "Recursive"
	},
	{
		name = "23",
		width = 8,
		height = 12,
		startx = -1,
		starty = -1,
		randomSeed = 1243,
		type = "seeded",
		algorithm = "Recursive"
	},
	{
		name = "24",
		width = 8,
		height = 12,
		startx = -1,
		starty = -1,
		randomSeed = 12433,
		type = "seeded",
		algorithm = "Recursive"
	},
	{
		name = "25",
		width = 8,
		height = 3,
		type = "prefab",
		startx = -1,
		starty = -1,
		data = [
			[ constants.FOUR_WAY, constants.ELBOW, constants.ELBOW, constants.END, constants.END, constants.END, constants.ELBOW, constants.ELBOW],
			[ constants.STRAIGHT, constants.STRAIGHT, constants.TEE, constants.STRAIGHT, constants.STRAIGHT, constants.STRAIGHT, constants.ELBOW, constants.ELBOW],
			[ constants.END, constants.END, constants.ELBOW, constants.ELBOW, constants.ELBOW, constants.END, constants.ELBOW, constants.ELBOW],
		]
	}
]
