#!/bin/bash -x
# Set up initial setup, might be redundant idk

# Note from Cappy:
# This script may fail if the system is not properly configured, we need to ensure that packages are installed and configured correctly.

echo "==== Initial Setup ===="
if rpm -q gnome-initial-setup; then
    mkdir -p /var/lib/gdm
    echo "Creating initial setup file for GNOME"
    touch /var/lib/gdm/run-initial-setup
elif rpm -q initial-setup-gui; then
    echo "Enabling Anaconda Initial Setup"
    systemctl enable initial-setup || echo "WARNING: Failed to enable Anaconda Initial Setup: $?"
elif rpm -q taidan; then
    echo "Enabling Taidan Initial Setup"
    systemctl enable taidan || echo "WARNING: Failed to enable Taidan Initial Setup: $?"
else
    echo "WARNING: No initial setup module found!? Please check the system configuration."
fi

# Set default target to graphical
systemctl set-default graphical.target
