extends Node

export(Color) var LOSE_COLOR_TEXT
const SIZE = 400
const GRID_LEN = 4
const BLOCK_SIZE = 32

export(Color) var BACKGROUND_COLOR_GAME = "#92877d"
export(Color) var BACKGROUND_COLOR_CELL_EMPTY = "#9e948a"

export(Array, Color) var BACKGROUND_COLOR_ARRAY: Array  # go up to 65536
export(Array, Color) var CELL_COLOR_ARRAY: Array  # go up to 65536

const cells = {
	2: 1,
	4: 2,
	8: 3,
	16: 4,
	32: 5,
	64: 6,
	128: 7,
	256: 8,
	512: 9,
	1024: 10,
	2048: 11,
	4096: 12,
	8192: 13,
	16384: 14,
	32768: 15,
	65536: 16
}


func _ready():
	assert(
		BACKGROUND_COLOR_ARRAY.size() == CELL_COLOR_ARRAY.size(),
		"BACKGROUND_COLOR_ARRAY and CELL_COLOR_ARRAY must have the same length"
	)
	assert(
		BACKGROUND_COLOR_ARRAY.size() == cells.size(),
		(
			"there is not enough entrys in BACKGROUND_COLOR_ARRAY and CELL_COLOR_ARRAY to reach %s"
			% cells.size()
		)
	)
	print(cells.size())
	print(BACKGROUND_COLOR_ARRAY.size())
