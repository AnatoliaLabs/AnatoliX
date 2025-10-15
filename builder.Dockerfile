FROM ghcr.io/terrapkg/builder:f42

RUN --mount=type=cache,target=/var/cache dnf install -y \
    git \
    xorriso \
    rpm \
    limine \
    systemd \
    btrfs-progs \
    e2fsprogs \
    xfsprogs \
    dosfstools \
    grub2 \
    parted \
    util-linux-core \
    systemd-container \
    grub2-efi \
    uboot-images-armv8 \
    uboot-tools \
    rustc \
    qemu-user-static-aarch64 \
    qemu-user-binfmt \
    qemu-kvm \
    qemu-img \
    cargo \
    systemd-devel \
    mkpasswd \
    clang-devel \
    moby-engine \
    squashfs-tools \
    erofs-utils \
    grub2-tools \
    grub2-tools-extra \
    isomd5sum \
    moby-engine \
    podman \
    buildah \
    katsu

CMD [ "katsu" ]
