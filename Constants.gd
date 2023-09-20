extends Node

@export var LOSE_COLOR_TEXT: Color
const SIZE = 400
const GRID_LEN = 4
const BLOCK_SIZE = 32

@export var BACKGROUND_COLOR_GAME: Color = "#92877d"
@export var BACKGROUND_COLOR_CELL_EMPTY: Color = "#9e948a"

@export var BACKGROUND_COLOR_ARRAY: Array  # go up to 65536 # (Array, Color)
@export var CELL_COLOR_ARRAY: Array  # go up to 65536 # (Array, Color)

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
