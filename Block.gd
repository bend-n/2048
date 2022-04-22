extends Node2D
var bg
var label: Label


func configure(text: String, background: Color, text_color: Color = Color.white):
	if !bg:
		bg = $ColorRect
	if !label:
		label = $Label
	bg.color = background
	label.text = text
	if text_color != Color.white:
		label.add_color_override("font_color", text_color)

func update_colors(new_number):
	if new_number == 0:
		configure("", Constants.BACKGROUND_COLOR_CELL_EMPTY)
	else:
		configure(
			str(new_number),
			Constants.BACKGROUND_COLOR_ARRAY[Constants.cells[new_number]],
			Constants.CELL_COLOR_ARRAY[Constants.cells[new_number]]
		)