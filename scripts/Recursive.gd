extends Node

var grid = []
var width = 0
var height = 0

var NORTH = 1
var EAST = 2
var SOUTH = 4
var WEST = 8

func create_maze(w,h):
	var maze = []
	for y in range(h):
		maze.append([])
		for x in range(w):
			maze[y].append(0)
	return maze
		
		
func generate(w, h):
	width = w
	height = h
	grid = create_maze(width,height)
	mine_from(0,0)
	return grid

func shuffleList(list):
    var shuffledList = [] 
    var indexList = range(list.size())
    for i in range(list.size()):
        var x = randi()%indexList.size()
        shuffledList.append(list[indexList[x]])
        indexList.remove(x)
    return shuffledList

func opposite(dir):
	if(dir == NORTH): 
		return SOUTH
		
	elif(dir == SOUTH): 
		return NORTH
		
	elif(dir == EAST): 
		return WEST
		
	elif(dir == WEST): 
		return EAST

func mine_from(currentX, currentY):

	var directions = [NORTH, SOUTH, EAST, WEST]
	directions = shuffleList(directions)

	for dir in directions:
		var newX = currentX
		var newY = currentY
		
		if(dir == EAST):
			newX = currentX + 1
		elif(dir == WEST):
			newX = currentX - 1
		elif(dir == NORTH):
			newY = currentY - 1
		elif(dir == SOUTH):
			newY = currentY + 1
			
		if(newY >= 0 && newY < height && newX >=0 && newX < width && grid[newY][newX] == 0):
			grid[currentY][currentX] += dir
			grid[newY][newX] += opposite(dir)
			mine_from(newX, newY)
			
