## Introduction

This repository has a set of tools to manage the status of the NVIDIA graphics card on an Optimus™ setup. It now supports [Solus](https://getsol.us/home/) with [Budgie](https://budgie-desktop.org/home/), [MATE](https://mate-desktop.org/) or [Gnome](https://www.gnome.org/) desktop.

Three profiles are implemented in the `nvidia-optimus-manager` script:
- `intel`: The Intel integrated GPU is used for display rendering and the dGPU is suspended by runtime power management. Running the `nvidia-smi` command gives
```
$ nvidia-smi
NVIDIA-SMI has failed because it couldn't communicate with the NVIDIA driver. Make sure that the latest NVIDIA driver is installed and running.
```
- `hybrid`: The Intel iGPU is used for display rendering while the dGPU is still on and its driver is loaded for other tasks (e.g., deep learning, etc.). In this configuration, the `nvidia-smi` command produces the following output:
```
$ nvidia-smi
Sun Dec  2 16:22:40 2018       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 410.78       Driver Version: 410.78       CUDA Version: 10.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  GeForce GTX 106...  On   | 00000000:01:00.0 Off |                  N/A |
| N/A   43C    P0    23W /  N/A |      0MiB /  6078MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID   Type   Process name                             Usage      |
|=============================================================================|
|  No running processes found                                                 |
+-----------------------------------------------------------------------------+
```
- `nvidia`: The dGPU will be used as the sole source of rendering. Running the `nvidia-smi` command produces
```
$ nvidia-smi
Sun Dec  2 16:25:42 2018       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 410.78       Driver Version: 410.78       CUDA Version: 10.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  GeForce GTX 106...  On   | 00000000:01:00.0 Off |                  N/A |
| N/A   48C    P0    23W /  N/A |    207MiB /  6078MiB |      6%      Default |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID   Type   Process name                             Usage      |
|=============================================================================|
|    0      8485      G   /usr/lib64/xorg-server/Xorg                  137MiB |
|    0      8726      G   budgie-wm                                     44MiB |
|    0      8995      G   ...-token=F8BB065232F55048CF73ECAC02D5EDA6     5MiB |
|    0      9092      G   ...-token=AEC61D9914CB773E37DFD8EFFFFEB6DB     7MiB |
|    0      9126      G   ...-token=215073FE33E4C44F4B99DE67F9B5AA88     9MiB |
+-----------------------------------------------------------------------------+
```
## AUTOMATED SCRIPT INSTALL
- Install the NVIDIA proprietary graphics driver
- Download this repo, extract, cd into nvidia-optimus-manager-master, and from your terminal, run: 
    ```
    sh nvidia-optimus-installer.sh
    ```
    Please note: Don't run with `sudo`
    
- The script will automatically install and configure everything for Gnome, MATE, or Budgie. 
- Reboot
- That's it!

## Things to do before manual installation

- Install the NVIDIA proprietary graphics driver
- Blacklist the `nouveau` driver:

*If you installed the NVIDIA proprietary driver from the Solus repo, this is automatically taken care of.*
```
$ sudo mkdir -p /etc/modprobe.d
$ echo "blacklist nouveau" | sudo tee /etc/modprobe.d/blacklist-nouveau.conf
```
- Install `pciutils` by `sudo eopkg it pciutils`

Reboot to let these changes take effect.

## Installation

For Budgie: 
- `99-nvidia.conf`: copy to `/etc/lightdm/lightdm.conf.d/99-nvidia.conf` # This may be the old path! User must confirm.
- `99-nvidia.conf`: copy to `/etc/gdm/99-nvidia.conf` # This is confirmed to be the path for new installs. 

For MATE:
- `99-nvidia.conf`: copy to `/etc/gdm/99-nvidia.conf`

For Gnome:
- `99-nvidia.conf`: copy to `/etc/gdm/99-nvidia.conf`

For ALL:
- `nvidia-optimus-autoconfig.service`: copy to `/etc/systemd/system/nvidia-optimus-autoconfig.service`
- `nvidia-optimus-manager`: copy to `/usr/bin/nvidia-optimus-manager`

Then enable the service file at boot:
```
sudo systemctl daemon-reload
sudo systemctl enable nvidia-optimus-autoconfig
```

## Dependencies

- [Linux-driver-management](https://github.com/solus-project/linux-driver-management)
- NVIDIA proprietary graphics driver
- `pciutils`: for the `lspci` command to find the pci bus id for the NVIDIA graphics card.

## Usage

Three subcommands can be used with the `nvidia-optimus-manager` script:
- Check the current configuration of the dGPU with the `status` subcommand:
```
$ nvidia-optimus-manager status
Current profile: intel
OpenGL vendor: Intel
Discrete graphics card power status: suspended
```

- Switch profile with the `configure` subcommand (requires root previleges):
```
$ nvidia-optimus-manager configure intel
Info: selecting the intel profile
```
If the graphic card for the display rendering is changed during the switch of profile (e.g. intel -> nvidia, or nvidia -> hybrid), the user needs to log out before the switch can take effect:
```
$ nvidia-optimus-manager configure nvidia
Info: selecting the nvidia profile
Log out to take effect
```
Otherwise the switch happens immediately.

- `autoconfigure` subcommand: Automatically configure the dGPU based on the presence of relevant configuration files (blacklist-nvidia.conf, 00-ldm.conf). This command is used in the systemd service file (nvidia-optimus-autoconfig.service) and the lightdm configuration file (99-nvidia.conf)
