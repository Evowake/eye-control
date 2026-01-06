#!/bin/bash

# 1. Path Definitions (ET)
TARGET_SCRIPT="$HOME/eye-control.py"
DESKTOP_FILE="$HOME/Desktop/EyeControl.desktop"

# 2. Generate the Python UI Engine (IC)
cat << 'PY_EOF' > "$TARGET_SCRIPT"
import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, Gio, GLib
import os

class EyeControl(Gtk.Window):
    def __init__(self):
        Gtk.Window.__init__(self, title="Eye Sovereignty")
        self.set_border_width(15)
        self.set_default_size(300, 150)
        self.set_position(Gtk.WindowPosition.CENTER)
        self.set_keep_above(True)

        vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=15)
        self.add(vbox)

        # --- NIGHT LIGHT TOGGLE ---
        hbox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)
        lbl = Gtk.Label(label="Eye Protection", xalign=0)
        self.switch = Gtk.Switch()
        
        # Sync switch with current system state
        current_state = os.popen("gsettings get org.gnome.settings-daemon.plugins.color night-light-enabled").read().strip()
        self.switch.set_active(current_state == "true")
        self.switch.connect("notify::active", self.on_toggle)
        
        hbox.pack_start(lbl, True, True, 0)
        hbox.pack_end(self.switch, False, False, 0)
        vbox.pack_start(hbox, False, False, 0)

        # --- TEMPERATURE SLIDER ---
        vbox.pack_start(Gtk.Label(label="Warmth (1000K = Max)", xalign=0), False, False, 0)
        
        # Get current Kelvin value
        cur_t = int(os.popen("gsettings get org.gnome.settings-daemon.plugins.color night-light-temperature | awk '{print $2}'").read().strip() or 4000)
        
        adj = Gtk.Adjustment(value=cur_t, lower=1000, upper=10000, step_increment=100)
        self.slider = Gtk.Scale(orientation=Gtk.Orientation.HORIZONTAL, adjustment=adj)
        self.slider.set_digits(0)
        self.slider.connect("value-changed", self.on_slider_move)
        vbox.pack_start(self.slider, True, True, 0)

        self.show_all()

    def on_toggle(self, switch, gparam):
        state = "true" if switch.get_active() else "false"
        os.system(f"gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled {state}")

    def on_slider_move(self, widget):
        val = int(widget.get_value())
        os.system(f"gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature {val}")
        # Force Wayland refresh
        os.system("gdbus call --session --dest org.gnome.SettingsDaemon.Color --object-path /org/gnome/SettingsDaemon/Color --method org.gnome.SettingsDaemon.Color.ScreenForceReload > /dev/null 2>&1")

win = EyeControl()
win.connect("destroy", Gtk.main_quit)
Gtk.main()
PY_EOF

# 3. Create Launcher (AJ)
cat << L_EOF > "$DESKTOP_FILE"
[Desktop Entry]
Name=Eye Control
Comment=Blue Light Filter Control
Exec=python3 $TARGET_SCRIPT
Icon=weather-clear-night
Type=Application
Terminal=false
L_EOF

# 4. Final Permissions Setup
chmod +x "$TARGET_SCRIPT"
chmod +x "$DESKTOP_FILE"
gio set "$DESKTOP_FILE" metadata::trusted true

echo "✅ [SUCCESS]: Deployment Finished."
echo "👉 1. Find 'Eye Control' on your desktop."
echo "👉 2. Right-click -> 'Allow Launching'."
