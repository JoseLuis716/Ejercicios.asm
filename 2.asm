;. Crea un programa que emplee macros y procedimientos para realizar una calculadora básica (4 operaciones básicas).
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
push ax
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


STACK SEGMENT STACK
   DB 64 DUP(?)
STACK ENDS
DATA segment
    aviso db 'Digite opcion: $'
    aviso1 db '1)Suma$'
    aviso2 db '2)Resta$'
    aviso3 db '3)Multiplicacion$'
    aviso4 db '4)Division$'
    usuario1 db 'Dame numero 1: $'
	usuario2 db 'Dame numero 2: $'
	cadena1 db '    $'
	cadena2 db '    $'
	con db 0
	con2 db 0
	Entero  dw  0
    Entero2 dw 0
    Factor  dw  10
	msgsum db '  La suma es: $'
	msgres db '  La resta es: $'
	msgmul db '  El producto es: $'
	msgcos db '  La division es: $'
	msgrs  db '  Residuo: $'
	ENTER DB 13,10, '$'
DATA ends


CODE SEGMENT
Assume DS:DATA, CS:CODE, SS:STACK
BEGIN:mov ax,data
      mov ds,ax
	   
	  mov ah,00h
      mov al,03h ;Modo de video
      int 10h
	  	
	 CALL MENU
	 
validador:	 
	 mov ah,07h;	Pide caracter
	 int 21h
	
	 cmp al,31h;	comparador: Compara que solo se ingresen los numeros que tiene el menú
	 jl validador
	 cmp al,34h
     ja validador
	 mov dl,al
	mov ah,02h;	Imprime caracter
	int 21h
	 sub al,30h
	 
	 cmp al,1;	comparador
	 je sumar
	 cmp al,2;	comparador
	 je restar
	 cmp al,3;	comparador
	 je multiplicar
	 cmp al,4;	comparador
	 je dividir
	 
	
     
	
sumar: CALL ENTRADA  ;PIDO NUMEROS
        CALL Sumap
		jmp FIN
restar: CALL ENTRADA
       CALL Restap
	   JMP FIN
multiplicar: CALL ENTRADA
            call Multiplicacionp
			JMP FIN
dividir: CALL ENTRADA
         call Divisionp
		 JMP FIN
   
FIN:   mov ax, 4c00h 
       int 21h 	

		

; <!--------- PROCEDIMIENTOS ---------------->	
Sumap proc near	
        mov ax,0
		mov bx,0
		mov cx,0
		mov dx,0
		IMPRIME msgsum
		mov ax,Entero		;sumar ax = n1
		add ax,Entero2	;      ax = ax + n2
		call mostrarAXnum
		ret
Sumap endp
		
Restap proc near
        mov ax,0
		mov bx,0
		mov cx,0
		mov dx,0
		IMPRIME ENTER
		IMPRIME msgres
		mov ax,Entero		;restar ax = n1
		sub ax,Entero2		;       ax = ax - n2
		call mostrarAXnum
		ret
Restap endp
		
Multiplicacionp proc near
        mov ax,0
		mov bx,0
		mov cx,0
		mov dx,0
		IMPRIME ENTER
		IMPRIME msgmul
		
		mov ax,Entero		;multilpicar  ax = n1
		mul Entero2	;             ax = ax * n
		call mostrarAXnum
		ret
Multiplicacionp endp

Divisionp proc near
        mov ax,0
		mov bx,0
		mov cx,0
		mov dx,0		
		IMPRIME ENTER
		IMPRIME msgcos
		
		mov dx,0
		mov ax,Entero		;dividir      ax = n1
		div Entero2			;             ax = ax / n2    dx = res
		push dx
		call mostrarAXnum
		;
		IMPRIME msgrs
		
		pop ax
		call mostrarAXnum
		ret
Divisionp endp
		
	
	     
ENTRADA proc near
pedir1:		
       IMPRIME ENTER
	   IMPRIME usuario1
	   mov cx,4 
       mov si,0  ;Puntero de pila
	      	   
ciclo: mov ah,07h ;recibe caracter y lo coloca en al
       int 21h 
       cmp al, 13 ; si es un ENTER salte del diclo [termina]
	   JE convertir	 
;Hay que validar que lo ingresado sea un numero y no un texto
	 cmp al,30h;	comparador: Compara que solo se ingresen 0-9
	 jl ciclo
	 cmp al,39h
     ja ciclo
	 
	   mov dl,al  ;movemos a dl para usar 02h
       mov ah,02h ;02 muestra caracter que está en dl
       int 21h    
       mov cadena1[si],al ; Movemos dato a la cadena
	   inc si  ;incrementa puntero
	   inc con ;este es un contador que nos dice la longitud del numero
	   
       loop ciclo ;loop decrementa cx (termina ciclo hasta que cx=0
	   
	  
convertir:

    mov SI,offset [cadena1]   ; Apuntar al digito mas  
                            ; significativo.
    CLD                     ; Establecer el sentido de
                             ; de recorrido de la cadena
     mov cl,0                       ; de izquierda a derecha.
            
C1: cmp con,cl
	je pedir2               ;si es igual
    mov AX,Entero           ; Multiplicar el contenido
    mul Factor              ; de Entero por 10.
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
		 IMPRIME usuario2
     
		
		

       mov cx,4 ;Contador 13 para que admita una palabra larga
       mov si,0  ;Puntero de pila
	      	   
ciclo2: mov ah,07h ;recibe caracter y lo coloca en al
       int 21h 
       cmp al, 13 ; si es un ENTER salte del diclo [termina]
	   JE convertir2	   
	   mov dl,al  ;movemos a dl para usar 02h
       mov ah,02h ;02 muestra caracter que está en dl
       int 21h    ;ejecuta todo esto [podria ser solo un int21h]
       mov cadena2[si],al ; Movemos dato a la cadena
	   inc si  ;incrementa puntero
	   inc con2
       loop ciclo2 ;loop decrementa cx (termina ciclo hasta que cx=0)
	   
convertir2:
   
    mov SI,offset [cadena2]    ; Apuntar al digito mas  
                                     ; significativo.
    CLD                              ; Establecer el sentido de
                                     ; de recorrido de la cadena
                              ; de izquierda a derecha.
    mov Cl,0                    ; Poner el contador de pro-
                                    ; grama en 4.
C2:cmp con2,cl
   je termino
   mov AX,Entero2               ; Multiplicar el contenido
   mul Factor                     ; de Entero por 10.
   mov Entero2,AX               ;
   xor AX,AX                      ; Limpiar AX
   lodsb                             ; Leer el caracter apuntado.
   sub AL,30h                    ; Pasar de caracter a numero.
   add AX,Entero2               ; Sumar el numero resultante
   mov Entero2,AX              ; a Entero.
  	inc cl
	jmp C2              ; Ir a leer otro digito.

termino:IMPRIME ENTER
        ret
ENTRADA endp


MENU proc near
	 IMPRIME aviso1
	 IMPRIME ENTER
	 IMPRIME aviso2
	 IMPRIME ENTER
	 IMPRIME aviso3
	 IMPRIME ENTER
	 IMPRIME aviso4
	 IMPRIME ENTER
	 IMPRIME ENTER
	 IMPRIME aviso
	
	 ret
MENU endp


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


pausa proc near
	mov ah,08h		;sin eco				01h con eco
	int 21h
	ret
pausa endp
		
		
CODE ENDS
     END BEGIN