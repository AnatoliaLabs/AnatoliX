#!/bin/bash
set -x

sed -i 's/allowed_installtypes = \["wholedisk"\]/allowed_installtypes = \["chromebookinstall"\]/' /etc/readymade.toml
