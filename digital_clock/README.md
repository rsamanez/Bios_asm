# Digital Clock Demo
Este demo esta creado para ejecutarce en una PC modelo x86 sin Sistema Operativo. Utiliza las rutinas de la BIOS para cargar el programa.   
   
El BIOS carga el bootloader desde el primer sector del Disco Duro, y luego ejecuta el programa de inicio, este a su vez, carga los siguientes 13 sectores 
del Disco Duro, a partir del sector 2. los 2 primeros sectores contienen el programa principal, y el resto contiene la data de 
la representacion grafica de los digitos a mostrar.
   
   
La data de los digitos a mostrar se crea a partir de las imagenes PNG que estan en 2 colores, para hacer la transformacion se utiliza el 
script en Python3 ( **png_to_binary.py** ) que genera el archivo llamado **numbers.bin**.   
   
Cada digito es una imagen de 48x89, que es transformada en un arreglo binario de 6x89 bytes, acomodados consecutivamente del 0 al 9.   
   


