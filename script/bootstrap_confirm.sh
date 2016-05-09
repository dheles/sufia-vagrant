#!/usr/bin/env bash

# confirmation script
echo "postgres services running: "
ps aux | grep 'postgres*'

echo "redis service: "
sudo systemctl status redis.service
redis-cli ping

echo "ImageMagick test: "
convert logo: logo.gif
identify logo.gif
rm logo.gif

echo "java version: "
java -version

echo "FITS and starts: "
wget -V
unzip -v
fits.sh -v

echo "ruby: "
ruby -v

# NOTE: don't try this. root does not have rails,
# so it throws an error and stops provisioning.
# echo "rails: "
# rails -v
