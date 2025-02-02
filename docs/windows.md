# Windows VM Setup

Unlike some people who primarily use linux I have games that don't work on linux
at all. To remedy this I use a stripped down and optimized Windows 10 QEMU vm. To
get started you will first want to install `virt-manager` and `qemu` with KVM/HV,
on Arch Linux the packages for this are `virt-manager` and `qemu-desktop`, after
you have installed the necessary packages you can then enable the virtualizer by
running the following command: `systemctl enable --now libvirtd.service` after
that it should work.

## Initial VM Setup

To get started you want right click the connection in virt-manager and ensure that
the built-in NAT network is running and enabled at boot, as well as adding a second
storage pool to store your ISOs optionally so your VHDs and ISOs are seperate.

### Virtual Machine Settings

For my virtual machine in specific I am using the following settings in virt-manager,
you don't have to follow these settings exactly, you should set it up in a way that
is compatible with your system preferably so your host isn't overwhelmed.

- **vCPUs**: 16 (8 cores, 2 threads)
- **Memory**: 64 GiB (65535 MiB)
- **Storage**: 1 TiB (1024 GiB)

Ensure during setup you set the BIOS type to UEFI by setting it to `OVMF_CODE.4m.fd`,
this will ensure maximum compatibility with the operating system and also allow things
like optimizations that will make the VM run faster by utilizing UEFI functionality.

It also important to make sure that your storage type is set to `virtio`, while the
default `SATA` mode works fine, it is painfully slow especially when it comes to games
compared to the `virtio` driver. If using `virtio` you will need to a second CD drive
in the VM to load the driver disk, which can be downloaded using the link below:

https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso

### Operating System Configuration

For my operating system configuration I use a clean unmodified windows 10 ISO created
by Microsoft's windows 10 media creation tool. After installation I often use a tool
like [kms_vl_all_aio](https://github.com/abbodi1406/KMS_VL_ALL_AIO) to activate windows
so that I don't waste my personal key on the virtual machine in case it gets banned by
an anticheat or something similar. After activation I typically like to debloat and
optimize windows itself, to do this I often use one of two tools to do this:

- [AtlasOS](https://atlasos.net/) - A windows modification focused on gaming and performance
- [Windows-Optimize-Debloat](https://github.com/simeononsecurity/Windows-Optimize-Debloat) - A powershell script that debloats windows

It should be noted that you **do not** need to use both of these tools, AtlasOS' tool
will heavily debloat and optimize windows, and it is unnecessary to use the second tool
if using it. The same goes with the debloat script, you do not need to install AtlasOS
if you choose the debloat script. Please keep this in mind if you plan to follow in my
footsteps.

## Setting Up Passthrough

**Note:** While I use one GPU, it has a quirks and does not work completely. It will
successfully detach from the host and attach to the VM and passthrough successfully
but shutting down the VM to go back into linux **does not work**, you will have to
reboot your entire computer to get back into linux after shutting down windows. If
you have multiple GPUs, follow another guide.

### Setting Up QEMU Hooks

In the [windows](../windows) folder of this repository you will see a `hooks` folder,
this contains the libvirt / QEMU hooks that does the actual management for the GPU
that allows it to unmount from the host system and attach to the VM allowing it to be
passed through and allow hardware acceleration. To set the hooks up you can run the
following commands in your preferred terminal.

```console
$ sudo mkdir -p /etc/libvirt/hooks
$ sudo cp -r windows/hooks/* /etc/libvirt/hooks
```

Note that this assumes your windows virtual machine is named `windows`, if it is named
something else you will need to rename the `windows` folder in the hooks directory for
this to properly work. Without the name and directory matching it won't work.

### Obtaining Your GPU ROM

There is multiple ways to do this on linux, those being the following:

1. Obtain your ROM online via [TechPowerUp](https://www.techpowerup.com/vgabios/).
2. Dump your BIOS via a BIOS flashing tool.
  2a. For nvidia this is going to be [nvflash](https://www.techpowerup.com/download/nvidia-nvflash/).
  2b. For AMD this is going to be [AMDVBFlash](https://www.techpowerup.com/download/ati-atiflash/).
3. Dump the BIOS via linux `/sys` paths.

In my case I decided to go with Option 3 as I couldn't find my exact ROM online
and I couldn't get the `nvflash` command line tool to work as it always gave me
an error with `mmap` for whatever reason, so via linux was the easiest way to
obtain the rom.

```console
$ find /sys -name "rom" -type f
$ echo 1 | sudo tee /sys/devices/pci0000:00/0000:00:03.1/0000:0b:00.0/rom
$ sudo cat /sys/devices/pci0000:00/0000:00:03.1/0000:0b:00.0/rom > nvidia.rom
```

After we obtain the GPU rom we can now put it in a folder libvirt can access it.

```console
$ sudo mkdir -p /usr/share/vbios
$ sudo mv $PWD/nvidia.rom /usr/share/vbios
```

### Setting Up VM Hardware

In order to prepare the VM to be used for gaming and things we need to modify the
hardware that is currently connected and configured. To get started we will first
remove some of the hardware we won't need in the long run, those being listed below.

1. USB Redirector 1
2. USB Redirector 2
3. Display Spice
4. Channel (spice)
5. Console 1
6. Video QXL
7. Sound ich9
8. Tablet

After these components have been removed we are now going to add and configure our own
hardware to passthrough to the virtual machine. We will start with our graphics card.
To set this up we will add a `PCI Host Device` component. If you are on NVIDIA this will
be straight forward, and you just need to add both of the devices on that PCI bus.

```
0000:0B:00:0 NVIDIA Corporation GA102 [GeForce RTX 3080 Lite Hash Rate]
0000:0B:00:1 NVIDIA Corporation GA102 High Definition Audio Controller
```

After adding both of the components you will want to modify their XML and add a line
like the following.

```xml
<rom file="/usr/share/vbios/nvidia.rom"/>
```

This will give libvirtd and qemu the ROM for our graphics card to ensure it works properly.
You will want to add any other hardware you want to passthrough to the VM via USB or PCI host
device passthrough. This will let them work inside the VM.

## Virtual Machine Optimization

Most people will probably be using a Windows VM for gaming I imagine so they will
want to know how to configure it to be more optimize, there's a few tweaks we can
apply to achieve this and I'll list and explain the ones I made below.

### CPU Pinning

CPU Pinning is when you assign virtual cpu cores to real cpu cores, removing work
from the virtualizer's scheduler. This majorly helps performance as each virtual
core is basically acting and using a single real hardware core. When setting up
CPU pinning you want to ensure you use cores that have access to the L3 cache,
you can do this by running the following command and find similar output:

```console
$ lscpu -e
CPU NODE SOCKET CORE L1d:L1i:L2:L3 ONLINEMAXMHZ   MINMHZ   MHZ
0 0  00  0:0:0:0  yes 5084.0000 550.0000 4744.4761
1 0  01  1:1:1:0  yes 5084.0000 550.0000 3197.1980
2 0  02  2:2:2:0  yes 5084.0000 550.0000  550.0000
3 0  03  3:3:3:0  yes 5084.0000 550.0000 3820.6531
4 0  04  4:4:4:0  yes 5084.0000 550.0000 3626.5359
5 0  05  5:5:5:0  yes 5084.0000 550.0000 3498.9441
6 0  06  6:6:6:0  yes 5084.0000 550.0000 3679.9131
7 0  07  7:7:7:0  yes 5084.0000 550.0000  550.0000
8 0  08  8:8:8:1  yes 5084.0000 550.0000 4022.5530
9 0  09  9:9:9:1  yes 5084.0000 550.0000 3213.1760
100  0   10  10:10:10:1   yes 5084.0000 550.0000 3252.9919
110  0   11  11:11:11:1   yes 5084.0000 550.0000 3574.3840
120  0   12  12:12:12:1   yes 5084.0000 550.0000  550.0000
130  0   13  13:13:13:1   yes 5084.0000 550.0000 3519.2959
140  0   14  14:14:14:1   yes 5084.0000 550.0000 3543.3191
150  0   15  15:15:15:1   yes 5084.0000 550.0000  550.0000
```

The thing we're looking for here is the numbers in the 5th column with the colons.
These are the values for our caches, the last number represents if that core has
access to the L3 cache. So in my case I would want to use cores 8 through 15. My
command output has more cores than this, but in result we can setup our config
like this:

```xml
<cputune>
  <vcpupin vcpu="0" cpuset="8"/>
  <vcpupin vcpu="1" cpuset="9"/>
  <vcpupin vcpu="2" cpuset="10"/>
  <vcpupin vcpu="3" cpuset="11"/>
  <vcpupin vcpu="4" cpuset="12"/>
  <vcpupin vcpu="5" cpuset="13"/>
  <vcpupin vcpu="6" cpuset="14"/>
  <vcpupin vcpu="7" cpuset="15"/>
  <vcpupin vcpu="8" cpuset="24"/>
  <vcpupin vcpu="9" cpuset="25"/>
  <vcpupin vcpu="10" cpuset="26"/>
  <vcpupin vcpu="11" cpuset="27"/>
  <vcpupin vcpu="12" cpuset="28"/>
  <vcpupin vcpu="13" cpuset="29"/>
  <vcpupin vcpu="14" cpuset="30"/>
  <vcpupin vcpu="15" cpuset="31"/>
  <emulatorpin cpuset="6-7,22-23"/>
  <iothreadpin iothread="1" cpuset="6-7,22-23"/>
</cputune>
```

The other thing to note in this part of the config are the `emulatorpin` as well
as the `iothreadpin` values. These are basically the cpu cores the emulator itself
and IO are managed and handled on. For this I am using cores 6-7 and 22-23 as they
are not L3 cores and are directly before our two sets of L3 cores giving us good
performance in the long run.

### CPU Optimization

On top of CPU pinning we can do some small changes to change how our virtual cpu
interacts with the host system. To do these we're going to change how the cache
works as well enable a certain extension that's needed on AMD systems for things
like hyperthreading.

```xml
<cpu mode="host-passthrough" check="none" migratable="on">
  <topology sockets="1" dies="1" clusters="1" cores="8" threads="2"/>
  <cache mode="passthrough"/>
  <feature policy="require" name="topoext"/>
</cpu>
```

### Disabling Clocks

When running our virtual machine the only real clock we need is the one hyperv
provides. We can disable all other clocks in our config by making the `clock` part
of our virtual machine configuration look like the one below.

```xml
<clock offset="localtime">
  <timer name="rtc" present="no" tickpolicy="catchup"/>
  <timer name="pit" present="no" tickpolicy="delay"/>
  <timer name="hpet" present="no"/>
  <timer name="kvmclock" present="no"/>
  <timer name="hypervclock" present="yes"/>
</clock>
```

### Disk Performance

As mentioned previously in the guide it is recommended to use the VIRTIO driver
for the disk as it is paravirtualized and will offer the best performanced, but
we can take this a step further by configuring other things like the way the disk
handles caching, etc.

```xml
<disk type="file" device="disk">
  <driver name="qemu" type="qcow2" cache="none" io="native" discard="unmap" iothread="1" queues="8"/>
  <source file="/var/lib/libvirt/disks/windows.qcow2"/>
  <target dev="vda" bus="virtio"/>
  <serial>048a3389-c5cb-4b2d-923b-d1d96dfef0e2</serial>
  <boot order="2"/>
  <address type="pci" domain="0x0000" bus="0x04" slot="0x00" function="0x0"/>
</disk>
```

As you can see here we configure some things with how our driver works, namely
the `cache`, `io`, `discard`, `iothread` and `queues` values. The `iothread` is
set to the number we previously configured for the iothread when CPU pinning. The
`cache` field is set to `none` as we want our host system to handle the caching
of the disk. The `discard` field is set to `unmap` to tell qemu to remove stuff
from memory when disc data is removed, and lastly `queues` tells qemu how many
workers to use for the disk IO.

### HyperV Enlightments

Lastly it is recommended to enable all the available HyperV enlightments to ensure
that the system is as fast as possible when being virtualized by the hypervisor. You
can do this by enabling the features in the `hyperv` section like the following.

```xml
<hyperv mode="custom">
  <relaxed state="on"/>
  <vapic state="on"/>
  <spinlocks state="on" retries="8191"/>
  <vpindex state="on"/>
  <synic state="on"/>
  <stimer state="on">
    <direct state="on"/>
  </stimer>
  <reset state="on"/>
  <vendor_id state="on" value="1291c80dd118"/>
  <frequencies state="on"/>
  <reenlightenment state="on"/>
  <tlbflush state="on"/>
  <ipi state="on"/>
</hyperv>
```

## Avoiding Anticheats

The best way to avoid anticheats is to configure the VM's SMBIOS and serials on
things like the disk, motherboard, and similar. You can see an example of my
serial for the disk above, and how I configured my system SMBIOS below if you
wish. It is also recommended to enable HyperV (without management tools) inside
the VM to help hide that the system is being virtualized.

```xml
<sysinfo type="smbios">
  <bios>
    <entry name="vendor">CatGirl</entry>
    <entry name="version">Premium</entry>
  </bios>
  <system>
    <entry name="manufacturer">CatGirl</entry>
    <entry name="product">Premium</entry>
    <entry name="version">2025.01</entry>
  </system>
  <baseBoard>
    <entry name="manufacturer">CatGirl</entry>
    <entry name="product">Premium</entry>
    <entry name="version">2025.01</entry>
    <entry name="serial">83d26290-a945-4458-96d4-085420ebc9eb</entry>
  </baseBoard>
  <chassis>
    <entry name="manufacturer">CatGirl</entry>
    <entry name="version">2025.01</entry>
    <entry name="serial">9ef0ee7b-b7ee-4819-8c63-4115c8b165f5</entry>
    <entry name="asset">Premium</entry>
    <entry name="sku">CatGirl Premium</entry>
  </chassis>
</sysinfo>
<!-- ... -->
<os firmware="efi">
  <smbios mode="sysinfo"/>
</os>
```
