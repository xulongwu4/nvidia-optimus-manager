#!/bin/bash

# Automated script to install nvidia-optimus-manager

# VARIABLES
####################################
LDM=/etc/lightdm/lightdm.conf.d    # OLD DIRECTORY - USER CONFIRM
GDM=/etc/gdm
MOD=/etc/modprobe.d
BIN=/usr/bin
OPT=nvidia-optimus-manager
DIR=`pwd`
SYSD=nvidia-optimus-autoconfig.service
####################################

clear
echo ""
echo "     -------------------------------------------"
echo ""
echo "           NVIDIA-OPTIMUS-MANAGER INSTALLER"
echo ""
echo "     -------------------------------------------"
echo ""
sleep 3
echo ""
clear
echo ""
echo "This script will install and autoconfigure"
echo "the Nvidia-Optimus-Manager for Solus Budgie"
echo "or Gnome editions."
echo ""
echo "This WILL require a reboot, once completed"
echo ""
sleep 4
clear

# DESKTOP CHECKS & CONFIGURATION

if [ `echo $XDG_CURRENT_DESKTOP` = "GNOME" ]
then
  echo ""
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
    sudo mkdir -p ${MOD}
    echo "blacklist nouveau" | sudo tee ${MOD}/blacklist-nouveau.conf
    echo ""
    echo "Installing necessary applications..."
    echo ""

elif [ `echo $XDG_CURRENT_DESKTOP` = "Budgie:GNOME" ]
then
  echo ""
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
    sudo mkdir -p ${MOD}
    echo "blacklist nouveau" | sudo tee ${MOD}/blacklist-nouveau.conf
    echo ""
    echo "Installing necessary applications..."
    echo ""
fi
echo ""
echo "               INSTALLATION COMPLETE!"
echo ""
echo "    You will need to reboot to apply all changes."
echo ""
echo ""

        read -p "              Reboot now (y/n)?" choice
        case "$choice" in 
          y|Y ) sudo reboot;;
          n|N ) echo "Goodbye";;
        esac
        exit
