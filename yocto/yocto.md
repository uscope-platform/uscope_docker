uScope platform build
==============

Custom Distribution
-----------------

The custom linux distribution is built using yocto, with Xilinx meta layers
A custom meta layer does all the needed configurations in a single recipe


TODO: 
    fix docker compose python dependencies

1. Enable docker to start at boot
    
    `systemctl enable docker.service`
    
    `systemctl enable containerd.service`


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

7. generate fit image with new kernel and device tree with the files in fitimage_tools (USE THE CORRECT DEVICE TREE WITH SUPPORT FOR ucube lkm)

    `mkimage -f fitImage.its fit.itb`

7. copy the output modules into the proper location on the target filesystem

    `cp -r modules/lib/modules/5.4.0-xilinx-v2020.1/ /media/fils/root/lib/modules `

8. Compile the ucube_lkm module from sources

9. move the ucube lkm module in /media/fils/root/lib/modules/5.4.0-xilinx-v2020.1/kernel/drivers/scope and reconstruct the dependency list

    `depmod`



Provvisioning
-----------------------------------

1. The following  python packages need to be installed for docker compose 

    `pip3 install -Iv requests==2.14.2`

    `pip3 install -Iv pyYAML==3.10`
    
    `pip3 install -Iv jsonschema==2.5.1`


Uscope stack
-----------------------------------

1. Clone repos



Ansible
-------------------------------------

ansible -i inventory uzed -m ping -u root


HTTPS commisioning
--------------------------------------


from https://blogg.bekk.no/how-to-sign-a-certificate-request-with-openssl-e046c933d3ae
1) Generate CA key and certificate

`openssl genrsa -des3 -out uscope_root.key 4096`

`openssl req -new -x509 -days 10000 -key uscope_root.key -out uscope_root.crt`

3) Generate the CSR 

`openssl req -new -newkey rsa:4096 -nodes -keyout uscope_0.pem -out uscope_0_req.pem -subj "/C=IT/CN=localhost" -addext "subjectAltName = DNS:localhost"`

4) Sign key

`openssl ca -rand_serial -config ca.conf -out uscope_0.crt -infiles uscope_0_req.pem`