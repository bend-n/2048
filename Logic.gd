# logic
extends Node

var done


func new_game(n):
	var matrix = []
	for i in range(n):
		matrix.append([])
		for _j in range(n):
			matrix[i].append(0)
	matrix = add_two(matrix)
	matrix = add_two(matrix)
	return matrix


func add_two(mat):
	var a = round(rand_range(0, mat.size() - 1))
	var b = round(rand_range(0, mat.size() - 1))
	while mat[a][b] != 0:
		a = round(rand_range(0, mat.size() - 1))
		b = round(rand_range(0, mat.size() - 1))
	mat[a][b] = 4 if rand_range(0, 1) > .9 else 2
	return mat


func game_state(mat):
	# check for win cell
	var zero = false
	for i in range(mat.size()):
		for j in range(mat[0].size()):
			if mat[i][j] == 2048:
				return "win"
			elif zero == false and mat[i][j] == 0:
				zero = true
	if zero:
		return "not over"

	# check for same cells that touch each other
	for i in range(len(mat) - 1):
		# intentionally reduced to check the row on the right and below
		# more elegant to use exceptions but most likely this will be their solution
		for j in range(len(mat[0]) - 1):
			if mat[i][j] == mat[i + 1][j] or mat[i][j + 1] == mat[i][j]:
				return "not over"
	for k in range(len(mat) - 1):  # to check the left/right entries on the last row
		if mat[len(mat) - 1][k] == mat[len(mat) - 1][k + 1]:
			return "not over"
	for j in range(len(mat) - 1):  # check up/down entries on last column
		if mat[j][len(mat) - 1] == mat[j + 1][len(mat) - 1]:
			return "not over"
	return "lose"


func reverse(mat):
	var new = []
	for i in range(mat.size()):
		new.append([])
		for j in range(mat[0].size()):
			new[i].append(mat[i][mat[0].size() - j - 1])
	return new


func transpose(mat):
	var new = []
	for i in range(mat[0].size()):
		new.append([])
		for j in range(mat.size()):
			new[i].append(mat[j][i])
	return new


func cover_up(mat, no_done = false):
	var new = []
	for _j in range(Constants.GRID_LEN):
		var partial_new = []
		for _i in range(Constants.GRID_LEN):
			partial_new.append(0)
		new.append(partial_new)
	if !no_done:
		done = false
	for i in range(Constants.GRID_LEN):
		var count = 0
		for j in range(Constants.GRID_LEN):
			if mat[i][j] != 0:
				new[i][count] = mat[i][j]
				if !no_done and j != count:
					done = true
				count += 1
	return new


func merge(mat):
	for i in range(Constants.GRID_LEN):
		for j in range(Constants.GRID_LEN - 1):
			if mat[i][j] == mat[i][j + 1] and mat[i][j] != 0:
				mat[i][j] *= 2
				mat[i][j + 1] = 0
				done = true
	return mat


func left(game):
	print("<")
	# return matrix after shifting left
	game = transpose(game)
	game = cover_up(game)
	game = merge(game)
	game = cover_up(game, true)
	game = transpose(game)
	return [game, done]


func right(game):
	print(">")
	# return matrix after shifting right
	game = reverse(transpose(game))
	game = cover_up(game)
	game = merge(game)
	game = cover_up(game, true)
	game = transpose(reverse(game))
	return [game, done]


func up(game):
	print("^")
	# return matrix after shifting up
	game = cover_up(game)
	game = merge(game)
	game = cover_up(game, true)
	return [game, done]


func down(game):
	print("v")
	# return matrix after shifting down
	game = reverse(game)
	game = cover_up(game)
	game = merge(game)
	game = cover_up(game, true)
	game = reverse(game)
	return [game, done]
