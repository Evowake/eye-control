#!/bin/bash
cp eye-toggle.sh ~/
chmod +x ~/eye-toggle.sh
cat > ~/.local/share/applications/eye-toggle.desktop << EOF
[Desktop Entry]
Name=Eye Protection Toggle
Exec=/home/\$USER/eye-toggle.sh
Type=Application
Icon=video-display
Terminal=false
Categories=Utility;
EOF
cp ~/.local/share/applications/eye-toggle.desktop ~/Desktop/
gio set ~/Desktop/eye-toggle.desktop metadata::trusted true
notify-send "Eye Protection Toggle installed!"Copied!   
