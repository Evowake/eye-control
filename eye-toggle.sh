#!/bin/bash
if [[ $(gsettings get org.gnome.settings-daemon.plugins.color night-light-enabled) == "true" ]]; then
    gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled false
    notify-send "👁️ Protection: OFF"
else
    gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature 1000
    gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
    notify-send "👁️ Protection: MAX (1000K)"
fi   
