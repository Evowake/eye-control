#!/bin/bash
if gsettings get org.gnome.settings-daemon.plugins.color night-light-enabled; then
    gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled false
    notify-send "👁️ Protection: OFF"
else
    gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature 1000
    gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
    # Force reload via D-Bus
    gdbus call --session --dest org.gnome.SettingsDaemon.Color --object-path /org/gnome/SettingsDaemon/Color --method org.gnome.SettingsDaemon.Color.ScreenForceReload > /dev/null 2>&1
    notify-send "👁️ Protection: MAX (1000K)"
fiCopied!   
