set
ls -lR
mkdir -p images
# for folder in artifacts

pack_image() {
  file=$1
  type=$2

  IMAGEDIR=images/$type/ultramarine/43/
  mkdir -p $IMAGEDIR

  filename=$(basename -- "$file")
  # create sha256sum
  sha256sum $file > $IMAGEDIR/$filename.sha256sum
  mv $file $IMAGEDIR
}

for file in artifacts/*-iso/*; do
  # if is file
  if [ -f "$file" ]; then
    pack_image $file isos
  fi
done

for file in artifacts/*-image/*; do
  # if is file
  if [ -f "$file" ]; then
    pack_image $file images
  fi
done

for file in artifacts/*-tar/*; do
  # if is file
  if [ -f "$file" ]; then
    pack_image $file images
  fi
done
