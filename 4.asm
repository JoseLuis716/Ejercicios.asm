;Crea un programa que emplee macros y procedimientos para leer una cadena, lo guarde en un archivo.
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

;------------------------ segmento de pila ------------------------
STACK SEGMENT STACK
   DB 64 DUP(?)
STACK ENDS

;------------------------ segmento de datos ------------------------
DATA SEGMENT
vec db 50 dup('$')   ;variable a usar para la escritura del archivo.
mensaje db 'Ingrese el texo para guardarlo en el archivo: $'
mensaje2 db 'el archivo ha sido creado con exito $'
ENTER DB 13,10, '$'
nombre db 'Archivo.txt',0 ;nombre archivo y debe terminar en 0
DATA ENDS

CODE SEGMENT
Assume DS:DATA, CS:CODE, SS:STACK
BEGIN:mov ax,data
       mov ds,ax
	   
	   mov ah,00h
       mov al,03h ;Modo de video
       int 10h
	   
	   IMPRIME mensaje
	   CALL crear
	   CALL leer
	   IMPRIME mensaje2
	   
	   
	   mov ax, 4c00h 
       int 21h 	
	   
	     
; <!--------- PROCEDIMIENTOS ---------------->
crear proc near

      mov ah,3ch ;crear archivo
      mov cx,0
      mov dx,offset nombre
      int 21h
	  
	  mov bx,ax
      mov ah,3eh ;cierra el archivo
      int 21h
ret 
crear endp

leer proc near
   pedir:
        mov ah,01h
        int 21h
        mov vec[si],al
        inc si
        cmp al,0dh
        ja pedir
        jb pedir

editar:
       mov ah,3dh ;abrir el archivo
       mov al,1h  ;Abrimos el archivo en solo escritura.
       mov dx,offset nombre
       int 21h

;Escritura de archivo
mov bx,ax ; mover hadfile
mov cx,si ;num de caracteres a grabar
mov dx,offset vec
mov ah,40h
int 21h

mov ah,3eh  ;Cierre de archivo
int 21h

ret
leer endp

CODE ENDS
     END BEGIN