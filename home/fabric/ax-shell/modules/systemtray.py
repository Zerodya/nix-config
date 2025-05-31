import gi

gi.require_version("Gray", "0.1")
import logging

from fabric.widgets.box import Box
from gi.repository import Gdk, GdkPixbuf, GLib, Gray, Gtk

import config.data as data

logger = logging.getLogger(__name__)

class SystemTray(Box):
    def __init__(self, pixel_size: int = 20, refresh_interval: int = 1, **kwargs) -> None:
        orientation = Gtk.Orientation.HORIZONTAL if not data.VERTICAL else Gtk.Orientation.VERTICAL
        super().__init__(
            name="systray",
            orientation=orientation,
            spacing=8,
            **kwargs
        )
        self.enabled = True
        super().set_visible(False)
        self.pixel_size = pixel_size
        self.refresh_interval = refresh_interval

        self.buttons_by_id = {}
        self.items_by_id = {}

        self.watcher = Gray.Watcher()
        self.watcher.connect("item-added", self.on_watcher_item_added)

        GLib.timeout_add_seconds(self.refresh_interval, self._refresh_all_items)

    def set_visible(self, visible: bool):
        self.enabled = visible
        self._update_visibility()

    def _update_visibility(self):
        has = len(self.get_children()) > 0
        super().set_visible(self.enabled and has)

    def _get_item_pixbuf(self, item: Gray.Item) -> GdkPixbuf.Pixbuf:
        try:
            pm = Gray.get_pixmap_for_pixmaps(item.get_icon_pixmaps(), self.pixel_size)
            if pm:
                return pm.as_pixbuf(self.pixel_size, GdkPixbuf.InterpType.HYPER)

            name = item.get_icon_name()
            theme = Gtk.IconTheme.new()
            path = item.get_icon_theme_path()
            if path:
                theme.prepend_search_path(path)
            return theme.load_icon(name, self.pixel_size, Gtk.IconLookupFlags.FORCE_SIZE)
        except GLib.Error as e:
            logger.debug(f"Icon load error {e}")
            return Gtk.IconTheme.get_default().load_icon(
                "image-missing", self.pixel_size, Gtk.IconLookupFlags.FORCE_SIZE
            )

    def _refresh_item_ui(self, identifier: str, item: Gray.Item, button: Gtk.Button):
        pixbuf = self._get_item_pixbuf(item)
        img = button.get_image()
        if isinstance(img, Gtk.Image):
            img.set_from_pixbuf(pixbuf)
        else:
            new = Gtk.Image.new_from_pixbuf(pixbuf)
            button.set_image(new)
            new.show()
        tip = None
        if hasattr(item, 'get_tooltip_text'):
            tip = item.get_tooltip_text()
        elif hasattr(item, 'get_title'):
            tip = item.get_title()
        if tip:
            button.set_tooltip_text(tip)
        else:
            button.set_has_tooltip(False)

    def _refresh_all_items(self) -> bool:

        for ident, item in self.items_by_id.items():
            btn = self.buttons_by_id.get(ident)
            if btn:
                self._refresh_item_ui(ident, item, btn)
        return True

    def on_watcher_item_added(self, _, identifier: str):
        item = self.watcher.get_item_for_identifier(identifier)
        if not item:
            return

        if identifier in self.buttons_by_id:
            self.buttons_by_id[identifier].destroy()
            del self.buttons_by_id[identifier]
            del self.items_by_id[identifier]

        btn = self.do_bake_item_button(item)
        self.buttons_by_id[identifier] = btn
        self.items_by_id[identifier] = item

        item.connect("notify::icon-pixmaps",
                     lambda itm, pspec: self._refresh_item_ui(identifier, itm, btn))
        item.connect("notify::icon-name",
                     lambda itm, pspec: self._refresh_item_ui(identifier, itm, btn))

        try:
            item.connect("updated", lambda itm: self._refresh_item_ui(identifier, itm, btn))
        except TypeError:
            pass

        item.connect("removed", lambda itm: self.on_item_instance_removed(identifier, itm))

        self.add(btn)
        btn.show_all()
        self._update_visibility()

    def do_bake_item_button(self, item: Gray.Item) -> Gtk.Button:
        btn = Gtk.Button()
        btn.connect("button-press-event", lambda b, e: self.on_button_click(b, item, e))
        img = Gtk.Image.new_from_pixbuf(self._get_item_pixbuf(item))
        btn.set_image(img)
        tip = item.get_tooltip_text() if hasattr(item, 'get_tooltip_text') else getattr(item, 'get_title', lambda: None)()
        if tip:
            btn.set_tooltip_text(tip)
        return btn

    def on_item_instance_removed(self, identifier: str, removed_item: Gray.Item):
        if self.items_by_id.get(identifier) is removed_item:
            btn = self.buttons_by_id.pop(identifier, None)
            self.items_by_id.pop(identifier, None)
            if btn:
                btn.destroy()
            self._update_visibility()

    def on_button_click(self, button: Gtk.Button, item: Gray.Item, event: Gdk.EventButton):
        if event.button == Gdk.BUTTON_PRIMARY:
            try:
                item.activate(int(event.x_root), int(event.y_root))
            except Exception as e:
                logger.error(f"Activate error: {e}")
        elif event.button == Gdk.BUTTON_SECONDARY:
            menu = getattr(item, 'get_menu', lambda: None)()
            if isinstance(menu, Gtk.Menu):
                menu.popup_at_widget(button, Gdk.Gravity.SOUTH_WEST,
                                     Gdk.Gravity.NORTH_WEST, event)
            else:
                cm = getattr(item, 'context_menu', None)
                if cm:
                    try:
                        cm(int(event.x_root), int(event.y_root))
                    except Exception as e:
                        logger.error(f"ContextMenu error: {e}")
