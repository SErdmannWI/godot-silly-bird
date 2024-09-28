extends Label


func update_text(new_text: String, text_color: Color) -> void:
	text = new_text
	add_theme_color_override("font_color", text_color)
