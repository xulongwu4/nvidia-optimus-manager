#!/bin/bash

# Automated script for nvidia-optimus-manager

# VARIABLES
####################################
GDM=/etc/gdm
SDDM=/etc/sddm.conf.d
MOD=/etc/modprobe.d
BIN=/usr/bin
OPT=nvidia-optimus-manager
DIR=`pwd`
SYSD=nvidia-optimus-autoconfig.service
####################################

echo "NVIDIA Optimus Manager Setup"
echo ""
echo "Checking up the current DE currently using..."
echo ""
sleep 2

if [ `echo $XDG_CURRENT_DESKTOP` = "KDE" ]
then
    echo "Setting up for KDE Plasma..."
    echo ""
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
fi

if [ `echo $XDG_CURRENT_DESKTOP` = "GNOME" ]
then
    echo "Setting things up for Gnome..."
    echo ""
    sleep 2
    sudo cp ${DIR}/99-nvidia.conf ${GDM}/99-nvidia.conf
    sudo cp ${DIR}/${OPT} ${BIN}/${OPT}
    sudo chmod a+x ${BIN}/${OPT}
    sudo cp ${DIR}/${SYSD} /etc/systemd/system/${SYSD}
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

fi

if [ `echo $XDG_CURRENT_DESKTOP` = "Budgie:GNOME" ]
then
    echo "Setting things up for Budgie..."
    echo ""
    sleep 2
    sudo cp ${DIR}/99-nvidia.conf ${GDM}/99-nvidia.conf
    sudo cp ${DIR}/${OPT} ${BIN}/${OPT}
    sudo chmod a+x ${BIN}/${OPT}
    sudo cp ${DIR}/${SYSD} /etc/systemd/system/${SYSD}
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
fi

if [ `echo $XDG_CURRENT_DESKTOP` = "MATE" ]
then
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
fi

read -p "               Installation completed! Do you want to reboot now? (y/n)?" choice
        case "$choice" in
            y|Y ) sudo reboot;;
            n|N ) echo "Okay, goodbye!";;
        esac
        exit
