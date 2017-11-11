# Fedora 26 + IOMMU

I put this together based on my own machine at home because I knew I'd forget this process if I ever had to do it again.  There was a lot of reading of Bugzilla, StackOverflow, and random blogs all over the internet.  Thanks to everyone who did something similar so I could cobble together something from all of them that Works On My Machine.  This is by no means the only way to solve the problem.  :)


### Prerequisites
- Fedora 26 (fresh install off the live USB image)
- Computer with two graphics cards (in my case, identical, but they don't need to be)
- A fresh backup of anything you don't care to lose


### Setup and configuration of the host machine
1. Add RPM Fusion
    ```shell
    sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    ```

1. Update and reboot
    ```shell
    sudo dnf clean all
    sudo dnf update -y
    sudo reboot
    ```

1. Install virtualization software and add yourself to the user group
    ```shell
    sudo dnf install @virtualization
    sudo usermod -G libvirt -a $(whoami)
    sudo usermod -G kvm -a $(whoami)
    ```

1. Install nVidia drivers
    ```shell
    sudo su -
    dnf install xorg-x11-drv-nvidia akmod-nvidia "kernel-devel-uname-r == $(uname -r)" xorg-x11-drv-nvidia-cuda vulkan vdpauinfo libva-vdpau-driver libva-utils
    dnf remove *nouveau*
    echo "blacklist nouveau" >> /etc/modprobe.d/blacklist.conf
    ```

1. Reboot again!
    ```shell
    sudo reboot
    ```

1. Verify that the nVidia drivers are installed correctly.
    ```shell
    lsmod | grep nouveau   # This should display nothing
    lsmod | grep nvidia    # This should display at least a couple things
    ```

1. Edit `/etc/default/grub` to enable IOMMU, blacklist nouveau, and turn on vfio-pci
    ```
    GRUB_CMDLINE_LINUX="rd.driver.pre=vfio-pci rd.driver.blacklist=nouveau modprobe.blacklist=nouveau rd.lvm.lv=fedora/root rd.lvm.lv=fedora/swap rhgb quiet intel_iommu=on iommu=pt"
    ```

1. Rebuild GRUB's configuration
    ```shell
    sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
    ```

1. Edit `/etc/modprobe.d/kvm.conf`.  These are edited out due to stability concerns.  YMMV.
    ```
    #options kvm_intel nested=1
    #options kvm_amd nested=1
    ```

1. Create or edit `/etc/modprobe.d/local.conf`
    ```
    install vfio-pci /sbin/vfio-pci-override-vga.sh
    ```

1. Create or edit `/etc/dracut.conf.d/local.conf`
    ```
    add_drivers+="vfio vfio_iommu_type1 vfio_pci vfio_virqfd"
  install_items+="/sbin/vfio-pci-override-vga.sh /usr/bin/find /usr/bin/dirname"
    ```

1. Create a file `/sbin/vfio-pci-override-vga.sh` with permissions `755`
    ```shell
    #!/bin/sh
    for i in $(find /sys/devices/pci* -name boot_vga); do
      if [ $(cat $i) -eq 0 ]; then
        GPU=$(dirname $i)
        AUDIO=$(echo $GPU | sed -e "s/0$/1/")
        echo "vfio-pci" > $GPU/driver_override
        if [ -d $AUDIO ]; then
          echo "vfio-pci" > $AUDIO/driver_override
        fi
      fi
    done

    modprobe -i vfio-pci
    ```

1. Rebuild using `dracut`
    ```shell
    sudo dracut -f --kver `uname -r`
    ```

1. Reboot again!

1. Verify that your target hardware is using `vfio-pci` as the driver.  Omit the `-s 00:02:00` on another machine to get the entire output.
    ```shell
    nataliepc /h/n/k/kernel $ lspci -vv -n -s 00:02:00
    02:00.0 0300: 10de:1c82 (rev a1) (prog-if 00 [VGA controller])
      Subsystem: 3842:6251
      Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
      Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
      Interrupt: pin A routed to IRQ 10
      Region 0: Memory at dc000000 (32-bit, non-prefetchable) [disabled] [size=16M]
      Region 1: Memory at a0000000 (64-bit, prefetchable) [disabled] [size=256M]
      Region 3: Memory at b0000000 (64-bit, prefetchable) [disabled] [size=32M]
      Region 5: I/O ports at d000 [disabled] [size=128]
      Expansion ROM at dd000000 [disabled] [size=512K]
      Capabilities: <access denied>
      Kernel driver in use: vfio-pci
      Kernel modules: nouveau, nvidia_drm, nvidia

    02:00.1 0403: 10de:0fb9 (rev a1)
      Subsystem: 3842:6251
      Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
      Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
      Interrupt: pin B routed to IRQ 11
      Region 0: Memory at dd080000 (32-bit, non-prefetchable) [disabled] [size=16K]
      Capabilities: <access denied>
      Kernel driver in use: vfio-pci
      Kernel modules: snd_hda_intel
    ```

1. Proceed to set up your virtual machine.


:information_source: I needed to use the [ACS patch](https://lkml.org/lkml/2013/5/30/513) in order to detach one, but not both, dedicated graphics cards.  More on that later.
