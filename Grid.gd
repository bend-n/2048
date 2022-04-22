extends Node2D

var matrix
var grid_cells
var history_matrixs
var won = false
var lost = false


func _ready():
	randomize()
	grid_cells = []
	init_grid()
	matrix = Logic.new_game(Constants.GRID_LEN)
	history_matrixs = []
	update_grid_cells()


const Block = preload("res://Block.tscn")


func init_grid():
	for i in range(Constants.GRID_LEN):
		var grid_row = []
		for j in range(Constants.GRID_LEN):
			var block = Block.instance()
			add_child(block)
			block.global_position += Vector2(
				i * Constants.BLOCK_SIZE + 10, j * Constants.BLOCK_SIZE + 10
			)
			grid_row.append(block)
		grid_cells.append(grid_row)


func update_grid_cells():
	for i in range(Constants.GRID_LEN):
		for j in range(Constants.GRID_LEN):
			var new_number = matrix[i][j]
			if new_number == 0:
				grid_cells[i][j].configure("", Constants.BACKGROUND_COLOR_CELL_EMPTY)
			else:
				grid_cells[i][j].configure(
					str(new_number),
					Constants.BACKGROUND_COLOR_ARRAY[Constants.cells[new_number]],
					Constants.CELL_COLOR_ARRAY[Constants.cells[new_number]]
				)


func _input(event):
	var input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if event.is_action("quit"):
		get_tree().quit()
	# elif event.is_action("undo") and history_matrixs.size() > 1: # dont want the undo feature anymore
	# 	self.matrix = history_matrixs.pop_back()
	# 	update_grid_cells()
	# 	print('back on step total step:' + str(history_matrixs.size()))
	elif input != Vector2.ZERO:
		handle_input(input)


func handle_input(input):
	if lost:
		return
	var tmp
	match input:
		Vector2.UP:
			tmp = Logic.up(matrix)
		Vector2.DOWN:
			tmp = Logic.down(matrix)
		Vector2.LEFT:
			tmp = Logic.left(matrix)
		Vector2.RIGHT:
			tmp = Logic.right(matrix)
		_:
			return
	matrix = tmp[0]
	if tmp[1]:
		matrix = Logic.add_two(matrix)
		# history_matrixs.append(matrix)
		update_grid_cells()

		var state = Logic.game_state(matrix)
		if state == "win" and not won:
			won = true
			grid_cells[0][0].configure(
				"You", Constants.BACKGROUND_COLOR_CELL_EMPTY, Constants.LOSE_COLOR_TEXT
			)
			grid_cells[1][0].configure(
				"won", Constants.BACKGROUND_COLOR_CELL_EMPTY, Constants.LOSE_COLOR_TEXT
			)
		elif state == "lose":
			lost = true
			grid_cells[0][0].configure(
				"You", Constants.BACKGROUND_COLOR_CELL_EMPTY, Constants.LOSE_COLOR_TEXT
			)
			grid_cells[1][0].configure(
				"lost", Constants.BACKGROUND_COLOR_CELL_EMPTY, Constants.LOSE_COLOR_TEXT
			)  # lmao L


func _on_SwipeHandler_swiped(swipe):
	handle_input(swipe)
