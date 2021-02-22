# Digital Clock Demo
This demo is created to run on an x86 model PC without an Operating System. It uses the BIOS routines to load the program.   
   

The BIOS loads the bootloader from the first sector of the Hard Drive, and then executes the startup program, this, in turn, loads the next 13 sectors of the Hard Disk, starting from sector 2.    
The first 2 sectors contain the main program, and the rest contain the graphic representation data of the digits to show.   
   
The digits data to show are created from the PNG images that are in 2 colors. To make the transformation uses the Python3 script (**png_to_binary.py** ) that generates the file named **numbers.bin**.   
    
Each digit is a **48x89** image, which is transformed into a **6x89** byte binary array, arranged consecutively from 0 to 9.
   
   
Este demo esta creado para ejecutarse en una PC modelo x86 sin Sistema Operativo. Utiliza las rutinas de la BIOS para cargar el programa.   
   
El BIOS carga el bootloader desde el primer sector del Disco Duro, y luego ejecuta el programa de inicio, este a su vez, carga los siguientes 13 sectores 
del Disco Duro, a partir del sector 2. los 2 primeros sectores contienen el programa principal, y el resto contiene la data de 
la representacion grafica de los digitos a mostrar.
   
   
La data de los digitos a mostrar se crea a partir de las imagenes PNG que estan en 2 colores, para hacer la transformacion se utiliza el 
script en Python3 ( **png_to_binary.py** ) que genera el archivo llamado **numbers.bin**.   
   
Cada digito es una imagen de **48x89**, que es transformada en un arreglo binario de **6x89** bytes, acomodados consecutivamente del 0 al 9.  
   
![image](https://raw.githubusercontent.com/rsamanez/Bios_asm/main/digital_clock/images/memory.png)
   
   
