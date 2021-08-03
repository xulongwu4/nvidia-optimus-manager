#!/bin/bash

# Automated script for MATE

# VARIABLES
####################################
GDM=/etc/gdm
MOD=/etc/modprobe.d
BIN=/usr/bin
OPT=nvidia-optimus-manager
DIR=`pwd`
SYSD=nvidia-optimus-autoconfig.service
####################################

echo "NVIDIA Optimus Manager installer"
echo ""
echo "Setting up for MATE..."
echo ""
sleep 2
sudo cp $DIR/99-nvidia.conf $GDM/99-nvidia.conf
sudo cp $DIR/$OPT $BIN/$OPT
sudo cp $DIR/$SYSD /etc/systemd/system/$SYSD
echo ""
sudo systemctl daemon-reload && sudo systemctl enable nvidia-optimus-autoconfig
echo ""
# SYSTEM PREP
echo ""
echo "Getting things ready..."
echo ""
sudo mkdir -p ${MOD}
echo "blacklist nouveau" | sudo tee ${MOD}/blacklist-nouveau.conf
echo ""
echo "Installing necessary applications while enabling NVIDIA DRM Module to avoid tearing..."
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
