############
# ImageMagick
############

echo "Installing ImageMagick"

SHARED_DIR=$1

if [ -f "$SHARED_DIR/install_scripts/config" ]; then
  . $SHARED_DIR/install_scripts/config
fi

if [ ! -f "$DOWNLOAD_DIR/ImageMagick-7.0.8-10.tar.gz" ]; then
  echo -n "Downloading ImageMagic..."
  wget -q "https://www.imagemagick.org/download/ImageMagick-7.0.8-10.tar.gz" -O "$DOWNLOAD_DIR/ImageMagick-7.0.8-10.tar.gz"
  echo " done"
fi

cp $DOWNLOAD_DIR/ImageMagick-7.0.8-10.tar.gz /tmp
cd /tmp
tar -xzf ImageMagick-7.0.8-10.tar.gz
cd ImageMagick-7.0.8-10
./configure --with-openjp2=yes
make && make install
ldconfig /usr/local/lib