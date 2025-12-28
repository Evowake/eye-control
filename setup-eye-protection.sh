#!/bin/bash

# Create the toggle script
cat > ~/eye-toggle.sh << 'EOF'
#!/bin/bash
if [[ $(gsettings get org.gnome.settings-daemon.plugins.color night-light-enabled) == "true" ]]; then
    gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled false
    notify-send "👁️ Protection: OFF"
else
    gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature 1000
    gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
    gdbus call --session --dest org.gnome.SettingsDaemon.Color --object-path /org/gnome/SettingsDaemon/Color --method org.gnome.SettingsDaemon.Color.ScreenForceReload > /dev/null 2>&1
    notify-send "👁️ Protection: MAX (1000K)"
fi
EOF

# Make scripts executable
chmod +x ~/eye-toggle.sh

# Create desktop icon
cat > ~/Desktop/eye-toggle.desktop << EOF
[Desktop Entry]
Name=Eye Protection Toggle
Exec=/home/a/eye-toggle.sh
Type=Application
Icon=video-display
Terminal=false
Categories=Utility;
EOF

# Make desktop icon executable and trusted
chmod +x ~/Desktop/eye-toggle.desktop
gio set ~/Desktop/eye-toggle.desktop metadata::trusted true

# Create autostart directory and file
mkdir -p ~/.config/autostart
cat > ~/.config/autostart/eye-toggle.desktop << EOF
[Desktop Entry]
Name=Eye Protection Toggle
Exec=/home/a/eye-toggle.sh
Type=Application
Icon=video-display
Terminal=false
X-GNOME-Autostart-enabled=true
EOF

echo "Setup complete. Click the desktop icon to toggle 1000K protection."   
