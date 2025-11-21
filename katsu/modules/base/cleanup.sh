#!/bin/bash -x

# Set DNF defaults in libdnf config instead of dnf.conf
mkdir -p /usr/share/dnf5/libdnf.conf.d/
cat >> /usr/share/dnf5/libdnf.conf.d/50-default.conf << 'EOF'
[main]
max_parallel_downloads=20
defaultyes=True
EOF


# Set default timezone to UTC
ln -sf /usr/share/zoneinfo/UTC /etc/localtime

rm -f /var/lib/systemd/random-seed
rm -f /etc/NetworkManager/system-connections/*.nmconnection

rm -f /etc/machine-id
touch /etc/machine-id

rm -f /var/lib/rpm/__db*
