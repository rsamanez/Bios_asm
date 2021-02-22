# Bios_asm

Sample Programs in Assembler to Run without Operating System, it uses only BIOS rutines and direct access to Video Memory. All programs are running in 16bits for x86 processors.   
   
Tested with *bochs* emulator, the binary files are made lo load from the bios booting process.

### How to run
```
# Build the binary file
nasm myfile.asm -f bin -o bootloader.bin

# check the bochs configuration file have the correct configuration
floppya: type=1_2, 1_2="bootloader.bin", status=inserted, write_protected=0

# run the emulator
bochs

#in the emulator
[6] to Begin Simulation
c   type "c" to continue the execution

```


