uScope platform build
==============

Custom Distribution
-----------------

The custom linux distribution is built using yocto, with Xilinx meta layers
A custom meta layer does all the needed configurations in a single recipe


TODO: 
    fix docker compose python dependencies

Kernel 
-----------------

In order to fully support docker the kernel must be built separately with a custom configurations
as the Xilinx layers do not support that use case, not using yocto kernel customization facilities and discarding user supplied
configs. Moreover the kernel needs to be custom built regardless in order to compile the uscope kernel driver.


1. clone the kernel

    `git clone https://github.com/Xilinx/linux-xlnx.git`

2. checkout the correct branch

    `git checkout -b xilinx-v2020.1`

3. copy uscope_config.cfg to the kernel source as .config

4. compile the kernel

    `make -j15 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- UIMAGE_LOADADDR=0x8000 uImage`

5. compile loadable modules

    `make -j15 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=../modules modules`

6. install modules to the specified directory

    `make -j15 ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- INSTALL_MOD_PATH=../modules modules_install`

7. generate fit image with new kernel and device tree with the files in fitimage_tools

    `mkimage -f fitImage.its fit.itb`

7. copy the output modules into the proper location on the target filesystem

    `cp -r /modules/lib/modules/5.4.0-xilinx-v2020.1/ /media/fils/root/lib/modules/5.4.0-xilinx-v2020.1 `