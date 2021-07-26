#!/bin/bash

# Automated script to install nvidia-optimus-manager

# VARIABLES
####################################
SDDM=/etc/sddm.conf.d
MOD=/etc/modprobe.d
BIN=/usr/bin
OPT=nvidia-optimus-manager
DIR=`pwd`
SYSD=nvidia-optimus-autoconfig.service
####################################

echo "Setting up NVIDIA Optimus Manager"
echo ""
echo "Setting up for KDE Plasma..."
echo ""
sleep 2
sudo mkdir /etc/sddm.conf.d
sudo cp $DIR/99-nvidia-sddm.conf $SDDM/99-nvidia-sddm.conf
sudo cp $DIR/$OPT $BIN/$OPT
sudo chmod a+x ${BIN}/${OPT}
sudo cp $DIR/$SYSD /etc/systemd/system/$SYSD
echo ""
sudo systemctl daemon-reload && sudo systemctl enable nvidia-optimus-autoconfig
echo ""
# SYSTEM PREP
echo ""
echo "Getting things ready..."
echo ""
sleep 2
sudo mkdir -p ${MOD}
echo "blacklist nouveau" | sudo tee ${MOD}/blacklist-nouveau.conf
echo ""
echo "Installing necessary applications while enabling NVIDIA DRM Module..."
echo ""
sudo eopkg it pciutils
echo ""
echo "nvidia-drm.modeset=1" | sudo tee /etc/kernel/cmdline.d/50-nvidia-drm.conf
echo ""
sleep 2
echo "Updating boot configuration..."
sudo clr-boot-manager update
echo ""
echo "...done! Please reboot for the effects to take change!"
sleep 2
