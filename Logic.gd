# logic
extends Node

var done
var moves: Array
var materialized_a: Vector2
var materialized_b: Vector2

class Merge:
	var at: Vector2
	var with: Vector2

class Move:
	var from: Vector2
	var to: Vector2

	func _init(a: Vector2, b: Vector2):
		self.from = a
		self.to = b

func new_game(n: int) -> Array[PackedInt32Array]:
	var matrix: Array[PackedInt32Array] = []
	for i in range(n):
		matrix.append(PackedInt32Array())
		for _j in range(n):
			matrix[i].append(0)
	matrix = add_two(matrix)
	matrix = add_two(matrix)
	return matrix


func add_two(mat: Array[PackedInt32Array]):
	var a = roundi(randf_range(0, mat.size() - 1))
	var b = roundi(randf_range(0, mat.size() - 1))
	while mat[a][b] != 0:
		a = roundi(randf_range(0, mat.size() - 1))
		b = roundi(randf_range(0, mat.size() - 1))
	mat[a][b] = 4 if randf_range(0, 1) > .9 else 2
	materialized_a = Vector2(a / mat.size(), a % mat.size())
	materialized_b = Vector2(b / mat.size(), b % mat.size())
	return mat


func game_state(mat: Array[PackedInt32Array]):
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


func reverse(mat: Array[PackedInt32Array]):
	for i in range(Constants.GRID_LEN):
		for j in range(Constants.GRID_LEN/2):
			var tmp = mat[i][j]
			mat[i][j] = mat[i][Constants.GRID_LEN - j - 1]
			mat[i][Constants.GRID_LEN - j - 1] = tmp
			moves.append(Move.new(Vector2(i,j), Vector2(j, Constants.GRID_LEN - j - i)))
	return mat

func transpose(mat: Array[PackedInt32Array]):
	for i in range(Constants.GRID_LEN):
		for j in range(i + 1, Constants.GRID_LEN):
			var tmp = mat[i][j]
			mat[i][j] = mat[j][i]
			mat[j][i] = tmp
			moves.append(Move.new(Vector2(j,i), Vector2(i, j)))
	return mat

func cover_up(mat, no_done = false):
	var new: Array[PackedInt32Array] = []
	for _j in range(Constants.GRID_LEN):
		var partial_new = PackedInt32Array()
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
				moves.append(Move.new(Vector2(i, j), Vector2(i, count)))
				if !no_done and j != count:
					done = true
				count += 1
	return new


func merge(mat: Array[PackedInt32Array]):
	for i in range(Constants.GRID_LEN):
		for j in range(Constants.GRID_LEN - 1):
			if mat[i][j] == mat[i][j + 1] and mat[i][j] != 0:
				mat[i][j] *= 2
				mat[i][j + 1] = 0
				var merge = Merge.new()
				merge.at = Vector2(i, j)
				merge.with = Vector2(i, j + 1)
				moves.append(merge)
				done = true


func left(game: Array[PackedInt32Array]):
	print("<")
	moves.clear()
	# return matrix after shifting left
	transpose(game)
	game = cover_up(game)
	merge(game)
	game = cover_up(game, true)
	transpose(game)
	return [game, done]


func right(game: Array[PackedInt32Array]):
	print(">")
	moves.clear()
	# return matrix after shifting right
	game = reverse(transpose(game.duplicate()))
	game = cover_up(game)
	merge(game)
	game = cover_up(game, true)
	game = transpose(reverse(game.duplicate()))
	return [game, done]


func up(game: Array[PackedInt32Array]):
	print("^")
	moves.clear()
	# return matrix after shifting up
	game = cover_up(game)
	merge(game)
	game = cover_up(game, true)
	return [game, done]


func down(game: Array[PackedInt32Array]):
	print("v")
	moves.clear()
	# return matrix after shifting down
	reverse(game)
	game = cover_up(game)
	merge(game)
	game = cover_up(game, true)
	reverse(game)
	return [game, done]
