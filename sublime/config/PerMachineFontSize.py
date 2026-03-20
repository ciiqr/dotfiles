import socket
import logging
import sublime
import sublime_plugin

logger = logging.getLogger(__name__)

def plugin_loaded():
    logger.setLevel(logging.DEBUG)

class PerMachineFontSize(sublime_plugin.EventListener):
    def on_load(self, view):
        logger.debug(f"[{__name__}] View loaded", view)

        # fetch settings
        settings = sublime.load_settings("Preferences.sublime-settings")
        base_font_size = settings.get("font_size")
        per_machine_font_size = settings.get("per_machine_font_size")

        # TODO: listen for setting changes
        # view.settings().add_on_change('color_scheme', lambda: set_proper_scheme(view))

        # determine font size
        # TODO: handle missing
        hostname = socket.gethostname()
        machine_font_size = per_machine_font_size[hostname]

        # set font size
        logger.debug(f"[{__name__}] setting view font_size = {machine_font_size}")
        view.run_command(
            "set_setting", {"setting": "font_size", "value": machine_font_size}
        )

        # debugging logs
        logger.debug(f"[{__name__}] hostname = {hostname}")
        logger.debug(f"[{__name__}] base_font_size = {base_font_size}")
        logger.debug(f"[{__name__}] per_machine_font_size = {per_machine_font_size}")

# adjust_per_machine_font_size
class AdjustPerMachineFontSizeCommand(sublime_plugin.TextCommand):
    def run(self, edit, **kwargs):
        delta = kwargs.get('delta')

        # fetch settings
        settings = sublime.load_settings("Preferences.sublime-settings")
        base_font_size = settings.get("font_size")
        per_machine_font_size = settings.get("per_machine_font_size")

        # determine new font size
        # TODO: handle missing
        hostname = socket.gethostname()
        machine_font_size = per_machine_font_size[hostname]
        new_font_size = machine_font_size + delta

        # save new font size
        per_machine_font_size[hostname] = new_font_size
        settings.set("per_machine_font_size", per_machine_font_size)
        sublime.save_settings("Preferences.sublime-settings")

        # set font size for open views
        logger.debug(f"[{__name__}] setting view font_size = {new_font_size}")
        for window in sublime.windows():
            for view in window.views():
                view.run_command(
                    "set_setting", {"setting": "font_size", "value": new_font_size}
                )


