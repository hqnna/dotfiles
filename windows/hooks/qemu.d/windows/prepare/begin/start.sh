#!/bin/bash
set -x

systemctl stop display-manager.service
killall gdm-x-session

echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

sleep 3

modprobe -r nvidia_drm
modprobe -r nvidia_modeset
modprobe -r nvidia_uvm
modprobe -r nvidia

modprobe vfio
modprobe vfio_iommu_type1
modprobe vfio_pci
