extends PanelContainer

@onready var item_texture_rect: TextureRect = %ItemIcon


func display_item(item: Item):
	item_texture_rect.texture = item.item_icon
