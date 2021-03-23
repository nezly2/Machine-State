//Practica 4
//Flavio Jimenez, Nezly Yanez
//Marzo 5, 2021

.data
simSCGC5: .long 0x1C00			//clock encendido para PORT B Y PORT D
gpio: .long 0x100				//GPIO para B8(Boton), B18(Rojo), B19(Verde), D1(Azul)
outB: .long 0xC0000				//Asigna B18(Rojo), B19(Verde) como output
outC: .long 0x4					//Asigna C2(boton) como input
outD: .long 0x2					//Asigna D1(Azul) como output
rojoonverdeoff: .long 0x80000	//led rojo
rojooffverdeon: .long 0x40000	//led verde
rojooffverdeoff: .long 0xC0000	//ambos apagados
rojoonverdeon: .long 0x0		//led amarillo
azulon: .long 0x0				//led azul
azuloff: .long 0x2				//Apagar led azul
rojooff: .long 0x80000			//Apagar led rojo
verdeoff: .long 0x40000			//Apagar led verde
ledsoff: .long 0xC0002			//Apagar todos los led
sleep: .long 0xF4240			//Retraso de frecuencia para ver los led, 3M aprox 1 segundos
boton: .long 0x4

.text
.global practica4
.type practica4 function

practica4:
////////////////////////////////////////////////////////////CONFIGURACION/////////////////////////////////////////////////////////////////////////////
//CLOCK PORT B, C & D encendidos
LDR r0, =simSCGC5			//carga en r0 la direccion de simSCGC5
LDR r0, [r0]				//carga en r0 el valor que hay en la direccion de [r0]
LDR r1, =0x40048038			//carga en r1 la direccion de CLOCK
STR r0, [r1]				//almacena en la direccion de [r1] el valor que hay en la direccion de r0

//GPIO (PORTx_PCRx)
LDR r0, =gpio				//carga en r0 la direccion de gpio
LDR r0, [r0]				//almacena en la direccion de [r1] el valor que hay en la direccion de r0
LDR r1, =0x4004A048			//carga en r1 la direccion de B18 (led rojo)
STR r0, [r1]				//almacena en la direccion de [r1] el valor que hay en la direccion de r0
LDR r1, =0x4004A04C			//carga en r1 la direccion de B19 (led verde)
STR r0, [r1]				//almacena en la direccion de [r1] el valor que hay en la direccion de r0
LDR r1, =0x44004B008		//carga en r1 la direccion de C2 (boton)
STR r0, [r1]				//almacena en la direccion de [r1] el valor que hay en la direccion de r0
LDR r1, =0x4004C004			//carga en r1 la direccion de D1 (led azul)
STR r0, [r1]				//almacena en la direccion de [r1] el valor que hay en la direccion de r0

//PDDR (configurar si input o output)
LDR r0, =outB				//carga en r0 la direccion de outB
LDR r0, [r0]				//carga en r0 el valor que hay en la direccion de [r0]
LDR r1, =0x400FF054			//carga en r1 el valor de la direccion de (GPIOB_PDDR)
STR r0, [r1]				//almacena en la direccion de [r1] el valor que hay en la direccion de r0
LDR r0, =outC				//carga en r0 la direccion de outC
LDR r0, [r0]				//carga en r0 el valor que hay en la direccion de [r0]
LDR r1, =0x400FF094			//carga en r1 el valor de la direccion de (GPIOC_PDDR)
STR r0, [r1]				//almacena en la direccion de [r1] el valor que hay en la direccion de r0
LDR r0, =outD				//carga en r0 la direccion de outD
LDR r0, [r0]				//carga en r0 el valor que hay en la direccion de [r0]
LDR r1, =0x400FF0D4			//carga en r3 el valor de la direccion de (GPIOD_PDDR)
STR r0, [r1]				//almacena en la direccion de [r1] el valor que hay en la direccion de r0

//PDOR o PDIR
LDR r1, =0x400FF040			//direccion PDOR para PORT B18(rojo) y B19(verde)
LDR r2, =0x400FF0C0			//direccion PDOR para PORT D1(azul)

//apagar leds
LDR r0, =rojooffverdeon		//carga en r0 la direccion de rojooffverdeon
LDR r0, [r0]				//carga en r0 el valor que hay en la direccion de [r0]
STR r0, [r1]				//almacena en la direccion de [r1] el valor que hay en la direccion de r0
LDR r0, =rojooffverdeoff	//carga en r0 la direccion de rojooffverdeoff
LDR r0, [r0]				//carga en r0 el valor que hay en la direccion de [r0]
STR r0, [r1]				//almacena en la direccion de [r1] el valor que hay en la direccion de r0
LDR r0, =azuloff			//carga en r0 la direccion azuloff
LDR r0, [r0]				//carga en r0 el valor que hay en la direccion de [r0]
STR r0, [r2]				//almacena en la direccion de [r1] el valor que hay en la direccion de r0
LDR r7, =boton				//carga en r7 la direccion de boton
LDR r7, [r7]				//carga en r7 el valor que hay en la direccion de [r7]

////////////////////////////////////////////////////////////ONEHOT////////////////////////////////////////////////////////////////////////////////////
OHe0:	//estado 0: rojo prendido
LDR r0, =rojoonverdeoff		//carga en r0 la direccion ROJOONVERDEOFF
LDR r0, [r0]				//carga en r0 el valor que hay en la direccion de [r0]
STR r0, [r1]				//almacena en la direccion de [r1] el valor que hay en la direccion de r0
LDR r0, =sleep
LDR r0, [r0]
B cuentaOHe0

cuentaOHe0:
CMP r0, #0
BNE restaOHe0
LDR r0, =ledsoff
LDR r0, [r0]
STR r0, [r1]
LDR r6, =0x400FF090			//direccion PDIR para PORT C2(boton)
LDR r6, [r6]
CMP r6, r7
BEQ Je0
B OHe1

restaOHe0:
SUB r0, r0, #1
B cuentaOHe0

OHe1:	//estado 1: verde prendido
LDR r0, =rojooffverdeon
LDR r0, [r0]
STR r0, [r1]
LDR r0, =sleep
LDR r0, [r0]
B cuentaOHe1

cuentaOHe1:
CMP r0, #0
BNE restaOHe1
LDR r0, =ledsoff
LDR r0, [r0]
STR r0, [r1]
LDR r6, =0x400FF090			//direccion PDIR para PORT C2(boton)
LDR r6, [r6]
CMP r6, r7
BEQ Je0
B OHe2

restaOHe1:
SUB r0, r0, #1
B cuentaOHe1

OHe2:	//estado 2: azul prendido
LDR r0, =azulon
LDR r0, [r0]
STR r0, [r2]
LDR r0, =sleep
LDR r0, [r0]
B cuentaOHe2

cuentaOHe2:
CMP r0, #0
BNE restaOHe2
LDR r0, =ledsoff
LDR r0, [r0]
STR r0, [r2]
LDR r6, =0x400FF090			//direccion PDIR para PORT C2(boton)
LDR r6, [r6]
CMP r6, r7
BEQ Je0
B OHe3

restaOHe2:
SUB r0, r0, #1
B cuentaOHe2

OHe3:	//estado 3: amarillo prendido
LDR r0, =rojoonverdeon
LDR r0, [r0]
STR r0, [r1]
LDR r0, =sleep
LDR r0, [r0]
B cuentaOHe3

cuentaOHe3:
CMP r0, #0
BNE restaOHe3
LDR r0, =ledsoff
LDR r0, [r0]
STR r0, [r1]
LDR r6, =0x400FF090			//direccion PDIR para PORT C2(boton)
LDR r6, [r6]
CMP r6, r7
BEQ Je0
//B Je0
B OHe0

restaOHe3:
SUB r0, r0, #1
B cuentaOHe3

puente2:
B OHe0

////////////////////////////////////////////////////////////JOHNSON///////////////////////////////////////////////////////////////////////////////////
Je0:		//estado 0: ninguno prendido
LDR r0, =ledsoff
LDR r0, [r0]
STR r0, [r1]
LDR r0, =sleep
LDR r0, [r0]
B cuentaJe0

cuentaJe0:
CMP r0, #0
BNE restaJe0
LDR r6, =0x400FF090			//direccion PDIR para PORT C2(boton)
LDR r6, [r6]
CMP r6, r7
LDR r6, =0x400FF090			//direccion PDIR para PORT C2(boton)
LDR r6, [r6]
CMP r6, r7
BEQ bounce
B Je1

restaJe0:
SUB r0, r0, #1
B cuentaJe0

Je1:		//estado 1: rojo prendido
LDR r0, =rojoonverdeoff
LDR r0, [r0]
STR r0, [r1]
LDR r0, =sleep
LDR r0, [r0]
B cuentaJe1

cuentaJe1:
CMP r0, #0
BNE restaJe1
LDR r0, =ledsoff
LDR r0, [r0]
STR r0, [r1]
LDR r6, =0x400FF090			//direccion PDIR para PORT C2(boton)
LDR r6, [r6]
CMP r6, r7
BEQ bounce
B Je2

restaJe1:
SUB r0, r0, #1
B cuentaJe1

Je2:		//estado 2: amarillo prendido
LDR r0, =rojoonverdeon
LDR r0, [r0]
STR r0, [r1]
LDR r0, =sleep
LDR r0, [r0]
B cuentaJe2

cuentaJe2:
CMP r0, #0
BNE restaJe2
LDR r0, =ledsoff
LDR r0, [r0]
STR r0, [r1]
LDR r6, =0x400FF090			//direccion PDIR para PORT C2(boton)
LDR r6, [r6]
CMP r6, r7
BEQ bounce
B Je3

restaJe2:
SUB r0, r0, #1
B cuentaJe2

Je3:		//estado 3: blanco prendido
LDR r0, =rojoonverdeon		//amarillo
LDR r0, [r0]
LDR r3, =azulon				//azul
LDR r3, [r3]
STR r0, [r1]
STR r3, [r2]				//amarillo(verde y rojo) + azul = blanco, RGB prendidos
LDR r0, =sleep
LDR r0, [r0]
B cuentaJe3

cuentaJe3:
CMP r0, #0
BNE restaJe3
LDR r0, =rojooffverdeoff
LDR r0, [r0]
LDR r3, =azuloff
LDR r3, [r3]
STR r0, [r1]
STR r3, [r2]
LDR r6, =0x400FF090			//direccion PDIR para PORT C2(boton)
LDR r6, [r6]
CMP r6, r7
BEQ bounce
B Je4

restaJe3:
SUB r0,r0, #1
B cuentaJe3

bounce:
B Be0

Je4:		//estado 4: magenta prendido
LDR r0, =rojoonverdeoff			//rojo
LDR r0, [r0]
LDR r3, =azulon					//azul
LDR r3, [r3]
STR r0, [r1]
STR r3, [r2]					//rojo+azul = magenta
LDR r0, =sleep
LDR r0, [r0]
B cuentaJe4

cuentaJe4:
CMP r0, #0
BNE restaJe4
LDR r0, =ledsoff
LDR r0, [r0]
LDR r3, =azuloff
LDR r3, [r3]
STR r0, [r1]
STR r3, [r2]
LDR r6, =0x400FF090			//direccion PDIR para PORT C2(boton)
LDR r6, [r6]
CMP r6, r7
BEQ Be0
B Je5

restaJe4:
SUB r0, r0, #1
B cuentaJe4

Je5:		//estado 5: cyan prendido
LDR r0, =rojooffverdeon			//verde
LDR r0, [r0]
LDR r3, =azulon					//azul
LDR r3, [r3]
STR r0, [r1]
STR r3, [r2]					//verde+azul= cyan
LDR r0, =sleep
LDR r0, [r0]
B cuentaJe5

cuentaJe5:
CMP r0, #0
BNE restaJe5
LDR r0, =ledsoff
LDR r0, [r0]
LDR r3, =azuloff
LDR r3, [r3]
STR r0, [r1]
STR r3, [r2]
LDR r6, =0x400FF090			//direccion PDIR para PORT C2(boton)
LDR r6, [r6]
CMP r6, r7
BEQ Be0
B Je6

restaJe5:
SUB r0, r0, #1
B cuentaJe5

Je6:		//estado 6: azul prendido
LDR r0, =azulon
LDR r0, [r0]
STR r0, [r2]
LDR r0, =sleep
LDR r0, [r0]
B cuentaJe6

cuentaJe6:
CMP r0, #0
BNE restaJe6
LDR r0, =ledsoff
LDR r0, [r0]
STR r0, [r2]
LDR r6, =0x400FF090			//direccion PDIR para PORT C2(boton)
LDR r6, [r6]
CMP r6, r7
BEQ Be0
B Je7

restaJe6:
SUB r0, r0, #1
B cuentaJe6

Je7:		//estado 7: verde prendido
LDR r0, =rojooffverdeon
LDR r0, [r0]
STR r0, [r1]
LDR r0, =sleep
LDR r0, [r0]
B cuentaJe7

cuentaJe7:
CMP r0, #0
BNE restaJe7
LDR r0, =ledsoff
LDR r0, [r0]
STR r0, [r1]
LDR r6, =0x400FF090			//direccion PDIR para PORT C2(boton)
LDR r6, [r6]
CMP r6, r7
BEQ Be0
B Je0

restaJe7:
SUB r0, r0, #1
B cuentaJe7

puente1:
B puente2

////////////////////////////////////////////////////////////BOUNCE////////////////////////////////////////////////////////////////////////////////////
Be0:		//estado 0: rojo prendido
LDR r0, =rojoonverdeoff
LDR r0, [r0]
STR r0, [r1]
LDR r0, =sleep
LDR r0, [r0]
B cuentaBe0

cuentaBe0:
CMP r0, #0
BNE restaBe0
LDR r0, =ledsoff
LDR r0, [r0]
STR r0, [r1]
LDR r6, =0x400FF090			//direccion PDIR para PORT C2(boton)
LDR r6, [r6]
CMP r6, r7
BEQ puente1
B Be1

restaBe0:
SUB r0, r0, #1
B cuentaBe0

Be1:		//estado 1: verde prendido
LDR r0, =rojooffverdeon
LDR r0, [r0]
STR r0, [r1]
LDR r0, =sleep
LDR r0, [r0]
B cuentaBe1

cuentaBe1:
CMP r0, #0
BNE restaBe1
LDR r0, =ledsoff
LDR r0, [r0]
STR r0, [r1]
LDR r6, =0x400FF090			//direccion PDIR para PORT C2(boton)
LDR r6, [r6]
CMP r6, r7
BEQ puente1
B Be2

restaBe1:
SUB r0, r0, #1
B cuentaBe1

Be2:		//estado 2: azul prendido
LDR r0, =azulon
LDR r0, [r0]
STR r0, [r2]
LDR r0, =sleep
LDR r0, [r0]
B cuentaBe2

cuentaBe2:
CMP r0, #0
BNE restaBe2
LDR r0, =ledsoff
LDR r0, [r0]
STR r0, [r2]
LDR r6, =0x400FF090			//direccion PDIR para PORT C2(boton)
LDR r6, [r6]
CMP r6, r7
BEQ puente1
B Be3

restaBe2:
SUB r0, r0, #1
B cuentaBe2

Be3:	//estado 3: magenta prendido
LDR r0, =rojoonverdeoff
LDR r0, [r0]
LDR r3, =azulon
LDR r3, [r3]
STR r0, [r1]
STR r3, [r2]
LDR r0, =sleep
LDR r0, [r0]
B cuentaBe3

cuentaBe3:
CMP r0, #0
BNE restaBe3
LDR r0, =ledsoff
LDR r0, [r0]
LDR r3, =azuloff
LDR r3, [r3]
STR r0, [r1]
STR r3, [r2]
LDR r6, =0x400FF090			//direccion PDIR para PORT C2(boton)
LDR r6, [r6]
CMP r6, r7
BEQ puente1
B Be4

restaBe3:
SUB r0, r0, #1
B cuentaBe3

Be4:		//estado 4: azul prendido
LDR r0, =azulon
LDR r0, [r0]
STR r0, [r2]
LDR r0, =sleep
LDR r0, [r0]
B cuentaBe4

cuentaBe4:
CMP r0, #0
BNE restaBe4
LDR r0, =ledsoff
LDR r0, [r0]
STR r0, [r2]
LDR r6, =0x400FF090			//direccion PDIR para PORT C2(boton)
LDR r6, [r6]
CMP r6, r7
BEQ puente1
B Be5

restaBe4:
SUB r0, r0, #1
B cuentaBe4

puente:
B puente1

Be5:		//estado 5: verde prendido
LDR r0, =rojooffverdeon
LDR r0, [r0]
STR r0, [r1]
LDR r0, =sleep
LDR r0, [r0]
B cuentaBe5

cuentaBe5:
CMP r0, #0
BNE restaBe5
LDR r0, =ledsoff
LDR r0, [r0]
STR r0, [r1]
LDR r6, =0x400FF090			//direccion PDIR para PORT C2(boton)
LDR r6, [r6]
CMP r6, r7
BEQ puente1
B Be6

restaBe5:
SUB r0, r0, #1
B cuentaBe5

Be6:		//estado 6: rojo prendido
LDR r0, =rojoonverdeoff
LDR r0, [r0]
STR r0, [r1]
LDR r0, =sleep
LDR r0, [r0]
B cuentaBe6

cuentaBe6:
CMP r0, #0
BNE restaBe6
LDR r0, =ledsoff
LDR r0, [r0]
STR r0, [r1]
LDR r6, =0x400FF090			//direccion PDIR para PORT C2(boton)
LDR r6, [r6]
CMP r6, r7
BEQ puente
B Be0

restaBe6:
SUB r0, r0, #1
B cuentaBe6
