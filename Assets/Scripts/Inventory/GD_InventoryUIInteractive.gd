extends InventoryUI

## Inherit from [InventoryUI] and make it interactable by the user.
class_name InventoryUIInteractive

signal on_show(other: InventoryUI)
signal on_hide(other: InventoryUI)

## Show the UI of the current inventory
func show_ui_standalone():
	on_show.emit(null)
	_update_ui()

## hide the UI of the current inventory
func hide_ui_standalone():
	on_hide.emit(null)
	_clear_ui()

## Show the UI
func show_ui_compare(other: InventoryUI):
	on_show.emit(other)
	_update_ui()

## Hide the UI
func hide_ui_compare(other: InventoryUI):
	on_hide.emit(other)
	other._clear_ui()
	_clear_ui()
