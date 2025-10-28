

builder_image := "ghcr.io/ultramarine-linux/katsu:latest"
vol_mounts := "-v $PWD:/build"
common_podman_args := " --rm --privileged $(vol_mounts) "

push target:
    echo {{ target }}
