from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import *

class MyColorScheme(ColorScheme):
    def use(self, context):
        fg, bg, attr = default_colors

        if context.reset:
            return default_colors

        elif context.in_browser:
            fg = green if context.selected else red
            if context.empty or context.error:
                fg = red
            if context.border:
                fg = yellow
            if context.media:
                if context.image:
                    fg = yellow
                else:
                    fg = magenta
            if context.container:
                fg = red
            if context.directory:
                fg = blue
            elif context.executable and not any((context.media, context.container,
                                                 context.fifo, context.socket)):
                fg = green
            if context.socket:
                fg = magenta
            if context.fifo or context.device:
                fg = yellow
            if context.link:
                fg = cyan if context.good else magenta
            if context.tag_marker and not context.selected: 
                attr |= bold
                if fg in (red, magenta):
                    fg = white
                else:
                    fg = red
            if not context.selected and (context.cut or context.copied):
                fg = black
                attr |= bold
            if context.main_column:
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    fg = yellow
            if context.badinfo:
                if attr & reverse:
                    bg = magenta
                else:
                    fg = magenta

        return fg, bg, attr

# Define los colores basados en el fondo de pantalla
default_colors = (
    int('0x', 16),  # fg
    int('0x', 16),  # bg
    0  # attr
)

# Define otros colores
red = int('0x', 16)
green = int('0xffffffffffffffce32ffffffffffffffce', 16)
blue = int('0xffffffffffffffceffffffffffffffce32', 16)
yellow = int('0x', 16)
magenta = int('0x32ffffffffffffffce32', 16)
cyan = int('0xffffffffffffffce3232', 16)
