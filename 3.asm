;Crea un programa que emplee macros y procedimientos para leer una cadena y la muestre en una coordenada indicada por el usuario. Validar las coordenadas.
IMPRIME MACRO arg1
push ax
push dx
mov ah,9
lea dx,arg1
int 21h
pop dx
pop ax
ENDM
;---UN MACRO SE USA CUANDO HACES ALGO MUY REPETITIVO--
POSICION MACRO x,y
mov ah,02h
;xor bh,bh
mov bx,0000h
mov dl,x
mov dh,y
int 10h
ENDM

LIMPIAR MACRO
mov cx, 0000h        
mov dx, 1550h 
xor al, al     ;Limpiamos al   
mov bh, 07h ;Fondo negro, letra roja
mov ah, 6
int 10h 
		
mov dx, 0000h
mov bh,00
mov ah,02
int 10h	 
ENDM 
;-----PROCEDIMIENTOS-----;
;1- LEER
;2-


STACK SEGMENT STACK
   DB 64 DUP(?)
STACK ENDS

DATA SEGMENT
cadena db '             $'
mensaje db 'Ingrese cadena a posicionar: $'
mensaje2 db 'Dame x: $'
mensaje3 db 'Dame y: $'
cadena2 db 'hola$'
aviso db 'Fuera del rango en pantalla, presione cualquier tecla para volver a intentar $'
x db 0
y db 0
u db 0
d db 0
u1 db 0
d1 db 0
ENTER DB 13,10, '$'
DATA ENDS

CODE SEGMENT
Assume DS:DATA, CS:CODE, SS:STACK
BEGIN:mov ax,data
       mov ds,ax
	   
	   mov ah,00h
       mov al,03h ;Modo de video
       int 10h
	   IMPRIME mensaje
	   
	   CALL leer
	  
	   POSICION x,y  ; el usuario las pone
	   IMPRIME [cadena]
	  	
TERMINAR:mov ax, 4C00H  
         int 21H 	
		 
; <!--------- PROCEDIMIENTOS ---------------->
Leer proc near
       mov cx,13 ;Contador 23 para que admita una palabra larga
       mov si,0  ;Puntero de pila
	      	   
ciclo: mov ah,07h ;recibe caracter y lo coloca en al
       int 21h 	  
	   mov dl,al  ;movemos a dl para usar 02h
       mov ah,02h ;02 muestra caracter que está en dl
       int 21h    ;ejecuta todo esto [podria ser solo un int21h]
       mov cadena[si],al ; Movemos dato a la cadena
	   inc si  ;incrementa puntero
	   cmp al, 13 ; si es un ENTER salte del ciclo [termina]
	   JE Regreso ; SALTARÁ?
       loop ciclo ;loop decrementa cx (termina ciclo hasta que cx=0
	   
Regreso:
       LIMPIAR	  ;MACRO
	   	 	  
inicializar:	   
	   IMPRIME mensaje2 ;'dame x'   2 DIGITOS
	   CALL CoordenadaX

	   cmp x, 70
	   JG advertencia
	   jmp inicializar2
	   
advertencia: IMPRIME ENTER 
             mov ah,09h
             lea dx, aviso
			 int 21h
			 
			    
	         mov ah,01h ;espera caracter, lo exhibe y lo coloca en al
	         int 21h
			 jmp Regreso
			 
advertencia2: IMPRIME ENTER
              mov ah,09h
			  lea dx, aviso
			  int 21h
			  
			  mov ah,01h
              int 21h
              jmp inicializar2			  
	   
inicializar2:	   
	   IMPRIME ENTER 
	   IMPRIME mensaje3  ;'dame y'
	   CALL CoordenadaY
	   
	   cmp y, 24
	   JG advertencia2
	   jmp Regreso2
	   
Regreso2:	   
	    LIMPIAR
ret
Leer endp		

CoordenadaX proc near
       mov ah,01h ;lee, muestra y lo coloca en al
	   int 21h
	   sub al,30h ;LE RESTA 30H 
	   mov d,al		;Y SE GUARDA EN AL
	   
	   mov ah,01h ;lee, muestra y lo coloca en al
	   int 21h
	   sub al,30h	;LE RESTA 30H
	   mov u,al		;LO GUARDA EN AL
	   
	   mov al,d
	   mov bl,10
	   mul bl
	   add al, u
	   mov x,al
ret
CoordenadaX endp

CoordenadaY proc near
       mov ah,01h ;espera caracter, lo exhibe y lo coloca en al
	   int 21h
	   sub al,30h ;aqui se debe restar para obtener el valor
	   mov d1,al
	   
	   mov ah,01h ;lee, muestra y lo coloca en al
	   int 21h
	   sub al,30h
	   mov u1,al
	   
	   mov al,d1
	   mov bl,10
	   mul bl
	   add al, u1
	   mov y,al
ret
CoordenadaY endp
		 
		 
		 

CODE ENDS
     END BEGIN