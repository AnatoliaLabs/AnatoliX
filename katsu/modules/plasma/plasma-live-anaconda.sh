cat >>/var/lib/livesys/livesys-session-extra <<ALLEOF
# Install welcome screen
sed -i 's/Fedora/Ultramarine/g' /usr/share/anaconda/gnome/fedora-welcome
ALLEOF
