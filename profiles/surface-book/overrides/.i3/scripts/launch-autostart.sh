
#!/usr/bin/env bash
sleep 1s
xfce4-terminal --initial-title=MainTerminal --title=MainTerminal &
xfce4-terminal --initial-title=htop --title=htop -e htop &
xfce4-terminal --initial-title=ranger --title=ranger -e ranger &
xfce4-terminal --initial-title=cava --title=cava -e cava &
protonmail-bridge &