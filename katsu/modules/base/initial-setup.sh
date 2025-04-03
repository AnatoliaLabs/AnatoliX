#!/bin/bash -x
# Set up initial setup, might be redundant idk

# Note from Cappy:
# This script may fail if the system is not properly configured, we need to ensure that packages are installed and configured correctly.

echo "==== Initial Setup ===="
if rpm -q gnome-initial-setup; then
    mkdir -p /var/lib/gdm
    echo "Creating initial setup file for GNOME"
    touch /var/lib/gdm/run-initial-setup
elif rpm -q taidan; then
    echo "Enabling Taidan Initial Setup"
    systemctl enable taidan-initial-setup || echo "WARNING: Failed to enable Taidan Initial Setup: $?"
elif rpm -q kiss; then
    echo "Enabling KDE Initial Setup"
    systemctl enable org.kde.initialsystemsetup.service || echo "WARNING: Failed to enable KDE Initial Setup: $?"
elif rpm -q initial-setup-gui; then
    echo "Enabling Anaconda Initial Setup"
    systemctl enable initial-setup || echo "WARNING: Failed to enable Anaconda Initial Setup: $?"
else
    echo "WARNING: No initial setup module found!? Please check the system configuration."
fi

# Set default target to graphical
systemctl set-default graphical.target


# Verify that services are actually enabled based on installed packages
echo "==== Verifying Initial Setup Services ===="
if rpm -q gnome-initial-setup; then
    if [ -f /var/lib/gdm/run-initial-setup ]; then
        echo "GNOME Initial Setup is properly configured"
    else
        echo "ERROR: GNOME Initial Setup file not created properly"
        exit 1
    fi
elif rpm -q taidan; then
    if systemctl is-enabled taidan-initial-setup >/dev/null 2>&1; then
        echo "Taidan Initial Setup is properly enabled"
    else
        echo "ERROR: Taidan Initial Setup is not enabled"
        exit 1
    fi
elif rpm -q kiss; then
    if systemctl is-enabled org.kde.initialsystemsetup.service >/dev/null 2>&1; then
        echo "KDE Initial Setup is properly enabled"
    else
        echo "ERROR: KDE Initial Setup is not enabled"
        exit 1
    fi
elif rpm -q initial-setup-gui; then
    if systemctl is-enabled initial-setup >/dev/null 2>&1; then
        echo "Anaconda Initial Setup is properly enabled"
    else
        echo "ERROR: Anaconda Initial Setup is not enabled"
        exit 1
    fi
else
    echo "WARNING: No initial setup package was found, skipping verification"
fi