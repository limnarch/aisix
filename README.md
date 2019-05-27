# aisix

Extreme work-in-progress.

Attempt to build a unix-like OS for the LIMNstation fantasy computer.

A long-term goal is a windowed GUI, short term goals are a bootloader, filesystem utilities, and a stub of a kernel.

## Building

Create a blank disk image.

Replace `disk.img` with the desired name of your disk image.

`dd if=/dev/zero of=disk.img bs=4096 count=1024`

Then, run the following commands with the LIMN sdk folder in your current directory:

Again, replace `disk.img` with the name of your disk image.

`./aisix/build-boot.sh ./disk.img`

`./aisix/build-stand.sh ./disk.img`

`./aisix/build-aisix.sh ./disk.img`

## Booting

Run the following command with the LIMNstation emulator (`./vm/`) in your current directory:

Again, replace `disk.img` with the name of your aisix disk image.

`./vm/vm.sh -dks ./disk.img`

At the a3x firmware prompt, the following command should work to boot the image:

`boot /ebus/platformboard/citron/dks/0`

At the bootloader's `>>` prompt, type `aisix` or just press enter. AISIX should boot! (as far as it can at the moment)

If you want to avoid these long-winded commands, it's possible to make the firmware do it automatically.

At the firmware prompt, type the following sequence of commmands:

`
setenv boot-dev /ebus/platformboard/citron/dks/0
setenv auto-boot? true
`

This sets the NVRAM variable boot-dev to point towards the devicetree path of our boot disk.

It sets the variable auto-boot? to true, to tell the firmware to automatically try to boot from boot-dev.

If you want to automate the bootloader prompt as well, type the following command at the firmware prompt:

`
setenv boot-args boot:auto=aisix
`

The bootloader, by default, will have a two second delay to give an opportunity to cancel the boot.

If you don't want this, type this command instead:

`
setenv boot-args boot:auto=aisix -boot:nodelay
`