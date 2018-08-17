extends Node

var grid = []
var gridSets = []
var edges = []
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
		
func create_sets(w,h):
	var counter = 0
	var maze = []
	for y in range(h):
		maze.append([])
		for x in range(w):
			maze[y].append(counter)
			counter += 1
	return maze
		
func generate(w, h):
	width = w
	height = h
	edges = []
	grid = create_maze(width,height)
	gridSets = create_sets(width, height)
	get_edges()
	merge()
	return grid

func shuffleList(list):
    var shuffledList = [] 
    var indexList = range(list.size())
    for i in range(list.size()):
        var x = randi()%indexList.size()
        shuffledList.append(list[indexList[x]])
        indexList.remove(x)
    return shuffledList

func get_edges():
	for y in range(height):
		for x in range(width):
			if(y > 0):
				edges.append([x,y,NORTH])
			if(x > 0):
				edges.append([x,y,WEST])
		
func opposite(dir):
	if(dir == NORTH): 
		return SOUTH
		
	elif(dir == SOUTH): 
		return NORTH
		
	elif(dir == EAST): 
		return WEST
		
	elif(dir == WEST): 
		return EAST

func merge():
	edges = shuffleList(edges)
	for edge in edges:
		var x = edge[0]
		var y = edge[1]
		var dir = edge[2]
		var edgeSet = gridSets[y][x]
		
		var otherEdgeSet
		
		if(dir == WEST):
			otherEdgeSet = gridSets[y][x-1]
			
		elif(dir == NORTH):
			otherEdgeSet = gridSets[y-1][x]
		
		if(otherEdgeSet != edgeSet):
			if(dir == WEST):
				grid[y][x] += dir
				grid[y][x-1] += opposite(dir)
				
			if(dir == NORTH):
				grid[y][x] += dir
				grid[y-1][x] += opposite(dir)
				
			convertAtoB(edgeSet, otherEdgeSet)
		
	
func convertAtoB(a,b):
	for y in range(height):
		for x in range(width):
			if(gridSets[y][x] == a):
				gridSets[y][x] = b