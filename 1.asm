;macros y procedimientos para calcular el promedio de 3 calificaciones de un alumno ( 3 digitos máximo) e indique si el alumno esta aprobado o reprobado. 
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
LIMPIAR MACRO
push  ax
push bx
push cx
push dx
mov cx, 0000h        
mov dx, 1550h 
xor al, al     ;Limpiamos al   
mov bh, 07h 
mov ah, 6
int 10h 
		
mov dx, 0000h
mov bh,00
mov ah,02
int 10h	 
pop ax
pop bx
pop cx
pop dx
ENDM 
;------------------------------------------------ SEGMENTO DE PILA ------------------------------------------------
STACK SEGMENT STACK
   DB 64 DUP(?)
STACK ENDS

DATA SEGMENT
cadena db '             $'
cadena2 db '   $'
cadena3 db '   $'
cadena4 db '   $'
mensaje db 'Escribe Nombre del alumno: $'
mensaje2 db 'Ingrese calificacion 1: $'
mensaje3 db 'Ingrese calificacion 2: $'
mensaje4 db 'Ingrese calificacion 3: $'
mensaje5 db 'Su promedio es: $'
aprobado db 'Esta aprobado con: $'
reprobado db 'Esta reprobado con: $'
con db 0
con2 db 0
con3 db 0
Entero  dw  0
Entero2 dw 0
Entero3 dw 0
Factor  dw  10
suma dw 0
dividir dw 3
promedio dw 0
ENTER DB 13,10, '$'
DATA ENDS

CODE SEGMENT
Assume DS:DATA, CS:CODE, SS:STACK
BEGIN:mov ax,data
      mov ds,ax
	   
	  mov ah,00h
      mov al,03h ;Modo de video
      int 10h
	  
	  IMPRIME mensaje ; pide nombre
	  
	  mov cx,23 ;Contador 23 para que admita una palabra larga
      mov si,0  ;Puntero de pila
	      	  
	      	   
ciclo:  mov ah,07h ;recibe caracter y lo coloca en al
       int 21h 	
       cmp al, 13 ; si es un ENTER salte del diclo [termina]
	   JE cicloaux	   
	   mov dl,al  ;movemos a dl para usar 02h
       mov ah,02h ;02 muestra caracter que está en dl
       int 21h    ;ejecuta todo esto [podria ser solo un int21h]
       mov cadena[si],al ; Movemos dato a la cadena
	   inc si  ;incrementa puntero
       loop ciclo ;loop decrementa cx (termina ciclo hasta que cx=0
	   
cicloaux:	   
	   IMPRIME ENTER
	   IMPRIME mensaje2; INGRESA CALIFICACION 1
	
pedir1:		
	   mov cx,3 
       mov si,0  ;Puntero de pila
	      	   
ciclo2: mov ah,07h ;recibe caracter y lo coloca en al
       int 21h 
       cmp al, 13 ; si es un ENTER salte del diclo [termina]
	   JE convertir	  
		cmp al,30h ;Aqui se validan que lo ingresado sean solo numeros y no texto
		jl ciclo2
		cmp al,39h
		ja ciclo2  ;fin de las validaciones
	   mov dl,al  ;movemos a dl para usar 02h
       mov ah,02h ;02 muestra caracter que está en dl
       int 21h    ;ejecuta todo esto [podria ser solo un int21h]
       mov cadena2[si],al ; Movemos dato a la cadena
	   inc si  ;incrementa puntero
	   inc con ;incrementa contador
       loop ciclo2 ;loop decrementa cx (termina ciclo hasta que cx=0
	     
convertir:	
    mov SI,offset [cadena2]   ; Apuntar al digito mas  
                            ; significativo.
    CLD                     ; Establecer el sentido de
                             ; de recorrido de la cadena
     mov cl,0                       ; de izquierda a derecha.
            
C1: cmp con,cl
	je pedir2               ;si es igual
    mov AX,Entero           ; Multiplicar el contenido
    mul Factor              ; de Entero por 10. AX POR FACTOR
    mov Entero,AX           ;
    xor AX,AX               ; Limpiar AX
    lodsb                   ; Leer el caracter apuntado.
    sub AL,30h              ; Pasar de caracter a numero.
    add AX,Entero           ; Sumar el numero resultante
    mov Entero,AX           ; a Entero.
	inc cl
	jmp C1              ; Ir a leer otro digito.
	
pedir2:	
       IMPRIME ENTER
	   IMPRIME mensaje3; calif 2
	   mov cx,3 
       mov si,0  ;Puntero de pila
	      	   
ciclo3: mov ah,07h ;recibe caracter y lo coloca en al
       int 21h 
       cmp al, 13 ; si es un ENTER salte del diclo [termina]
	   JE convertir2
	   cmp al,30h
	   jl ciclo3
	   cmp al,39h
	   ja ciclo3
	   mov dl,al  ;movemos a dl para usar 02h
       mov ah,02h ;02 muestra caracter que está en dl
       int 21h    ;ejecuta todo esto [podria ser solo un int21h]
       mov cadena3[si],al ; Movemos dato a la cadena
	   inc si  ;incrementa puntero
	   inc con2 ;incrementa contador PARA SABER LA LONGITUD DE LA CADENA
       loop ciclo3 ;loop decrementa cx (termina ciclo hasta que cx=0
	     
convertir2:	
    mov SI,offset [cadena3]   ; Apuntar al digito mas  
                            ; significativo.
    CLD                     ; Establecer el sentido de
                             ; de recorrido de la cadena
     mov cl,0                       ; de izquierda a derecha.
            
C2: cmp con2,cl
	je pedir3               ;si es igual
    mov AX,Entero2           ; Multiplicar el contenido
    mul Factor              ; de Entero por 10.
    mov Entero2,AX           ;
    xor AX,AX               ; Limpiar AX
    lodsb                   ; Leer el caracter apuntado.
    sub AL,30h              ; Pasar de caracter a numero.
    add AX,Entero2           ; Sumar el numero resultante
    mov Entero2,AX           ; a Entero.
	inc cl
	jmp C2             ; Ir a leer otro digito.
	
pedir3:
       IMPRIME ENTER
	   IMPRIME mensaje4; calif 3
       mov cx,3 
       mov si,0  ;Puntero de pila
	      	   
ciclo4: mov ah,07h ;recibe caracter y lo coloca en al
       int 21h 
       cmp al, 13 ; si es un ENTER salte del diclo [termina]
	   JE convertir3	
	   cmp al,30h
	   jl ciclo4
	   cmp al,39h
	   ja ciclo4
	   mov dl,al  ;movemos a dl para usar 02h
       mov ah,02h ;02 muestra caracter que está en dl
       int 21h    ;ejecuta todo esto [podria ser solo un int21h]
       mov cadena4[si],al ; Movemos dato a la cadena
	   inc si  ;incrementa puntero
	   inc con3 ;incrementa contador
       loop ciclo4 ;loop decrementa cx (termina ciclo hasta que cx=0
		
	     
convertir3:	
    mov SI,offset [cadena4]   ; Apuntar al digito mas  
                            ; significativo.
    CLD                     ; Establecer el sentido de
                             ; de recorrido de la cadena
    mov cl,0                       ; de izquierda a derecha.
            
C3: cmp con3,cl
	je inicio              ;si es igual
    mov AX,Entero3           ; Multiplicar el contenido
    mul Factor              ; de Entero por 10.
    mov Entero3,AX           ;
    xor AX,AX               ; Limpiar AX
    lodsb                   ; Leer el caracter apuntado.
    sub AL,30h              ; Pasar de caracter a numero.
    add AX,Entero3           ; Sumar el numero resultante
    mov Entero3,AX           ; a Entero.
	inc cl
	jmp C3             ; Ir a leer otro digito.   
	
inicio:
    mov ax,0
	mov bx,0
	mov cx,0
	mov dx,0
	
	mov ax,Entero   ;sumar ax = n1
	add ax,Entero2	;ax = ax + n2
	add ax,Entero3  ;ax=ax+ax+n3   
    div dividir	    ;ax = ax / n2    
	
    IMPRIME ENTER
	IMPRIME [cadena] ;nombre
	cmp ax,70
	jge aprobacion
	cmp ax,70
	jl reprobacion
aprobacion:
    IMPRIME aprobado
	call mostrarAXnum 
	jmp fin
reprobacion:
    IMPRIME reprobado
	call mostrarAXnum
	     
fin:	   
	   mov ax, 4c00h 
       int 21h 	
	   
;-------PROCEDIMIENTOS---------
mostrarAXnum proc near
xor cx,cx
mov si,10
bucle2ccr:
	    xor dx,dx			
		div si 			;ax = ax div si     dx = ax mod si
		push dx
		inc cx
		cmp ax,0
		jne bucle2ccr		
bucle3ccr:
		pop dx			
		add dx,48
		mov ah,2
		int 21h			
		loop bucle3ccr
		ret
mostrarAXnum endp 

mostrarDXmsg proc near
mov ah,9
int 21h
ret
mostrarDXmsg endp
	   
		 
CODE ENDS
     END BEGIN