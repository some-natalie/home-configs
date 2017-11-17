# Arch Linux + IOMMU

Work in progress on another machine.

General steps:
1. Install Arch Linux and your desktop environment of choice - [general directions](https://wiki.archlinux.org/index.php/Installation_guide)
1. Use the `linux-vfio` kernel because I have identical graphics cards - [link](https://aur.archlinux.org/packages/linux-vfio/)
1. Set up PCI passthrough - [link](https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF)
1. Set up your VM
  - Make sure MSI is turned on in the registry editor
