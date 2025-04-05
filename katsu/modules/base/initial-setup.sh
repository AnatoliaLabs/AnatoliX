#!/bin/bash -x
# Set up initial setup, might be redundant idk

# Note from Cappy:
# This script may fail if the system is not properly configured, we need to ensure that packages are installed and configured correctly.

# Key-value pairs of package-service name - numbered to preserve order
declare -A pkg_service_map=(
    ["1_gnome-initial-setup"]="!"
    ["2_taidan"]="taidan-initial-setup"
    ["3_kiss"]="org.kde.initialsystemsetup.service"
    ["4_initial-setup-gui"]="initial-setup"
)

assert_svc() {
    local svc=$1
    if systemctl is-enabled $svc >/dev/null 2>&1; then
        echo "$svc is properly enabled"
    else
        echo "$svc is not enabled"
    fi
}

enable_svc() {
    local pkg=$1
    local svc=$2
    systemctl enable -f $svc || echo "WARNING: Failed to enable $svc: $?"

}
echo "==== Initial Setup ===="
setup_found=false

# Handle gnome-initial-setup as the primary check
if rpm -q gnome-initial-setup >/dev/null 2>&1; then
    mkdir -p /var/lib/gdm
    echo "Creating initial setup file for GNOME"
    touch /var/lib/gdm/run-initial-setup
    sed '/[daemon]/a InitialSetupEnable=True' /etc/gdm/custom.conf
    setup_found=true
else
    # If gnome-initial-setup isn't installed, check each package in the map
    for pkg in "${!pkg_service_map[@]}"; do
        if [[ "${pkg_service_map[$pkg]}" == "!" ]]; then
            continue  # Skip special case entries
        fi

        # Check if package is installed
        pkg_name="${pkg#*_}"  # Remove the number prefix when checking
        if rpm -q "$pkg_name" >/dev/null 2>&1; then
            svc="${pkg_service_map[$pkg]}"
            echo "Enabling $pkg_name Initial Setup"
            enable_svc "$pkg_name" "$svc"
            setup_found=true
            break  # Exit loop after finding the first valid setup
        fi
    done
fi

if [ "$setup_found" = false ]; then
    echo "WARNING: No initial setup module found!? Please check the system configuration."
fi

# Set default target to graphical
systemctl set-default graphical.target

# Verify that services are actually enabled based on installed packages
echo "==== Verifying Initial Setup Services ===="
found_pkg_svc=false

# Verify GNOME Initial Setup (special case)
if rpm -q gnome-initial-setup >/dev/null 2>&1; then
    if [ -f /var/lib/gdm/run-initial-setup ]; then
        echo "GNOME Initial Setup is properly configured"
        found_pkg_svc=true
    else
        echo "ERROR: GNOME Initial Setup file not created properly"
        exit 1
    fi
else
    # Only verify other packages if GNOME setup is not installed
    for pkg in "${!pkg_service_map[@]}"; do
        if [[ "${pkg_service_map[$pkg]}" == "!" ]]; then
            continue  # Skip special case entries
        fi

        pkg_name="${pkg#*_}"  # Remove the number prefix when checking
        if rpm -q "$pkg_name" >/dev/null 2>&1; then
            svc="${pkg_service_map[$pkg]}"
            assert_svc "$svc"
            if ! systemctl is-enabled "$svc" >/dev/null 2>&1; then
                echo "ERROR: $pkg_name Initial Setup is not enabled"
                exit 1
            fi
            found_pkg_svc=true
            break  # Exit loop after verifying the first valid setup
        fi
    done
fi

if [ "$setup_found" = false ] && [ "$found_pkg_svc" = false ]; then
    echo "WARNING: No initial setup package was found, skipping verification"
fi