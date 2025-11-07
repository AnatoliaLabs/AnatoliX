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

# if aarch64

arch=$(uname -m)
if [[ $arch == "aarch64" ]]; then
cp -P /usr/share/uboot/rpi_arm64/u-boot.bin /boot/efi/rpi-u-boot.bin
cp -P /usr/share/uboot/rpi_3/u-boot.bin /boot/efi/rpi3-u-boot.bin
cp -P /usr/share/uboot/rpi_4/u-boot.bin /boot/efi/rpi4-u-boot.bin
fi
rm -f /var/lib/systemd/random-seed
rm -f /etc/NetworkManager/system-connections/*.nmconnection

rm -f /etc/machine-id
touch /etc/machine-id

rm -f /var/lib/rpm/__db*
