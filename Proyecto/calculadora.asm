; INSTITUTO TECNOLOGICO SUPERIOR DE VALLADOLID
; LENGUAJE Y AUTOMATAS II
; LEONEL PECH MAY
; ANDREA GUADALUPE XOOC MIS

include 'emu8086.inc'

org 100h 
.model medium
.stack 100
.data


nmacro macro dato
        mov ah,02h
        mov dl,dato  ;entrada del dato
    
        add dl,40h  
endm

     mostrarMenu db '******MENU******',13,10
                 db '1. SUMA',13,10
                 db '2. RESTA',13,10
                 db '3. MULTIPLICACION',13,10
                 db '4. DIVISION',13,10
                 db '5. Salir',13,10,13,10
                 db 'Seleccione una Opcion -> $',13,10
                 
     numsum db 13,10,"******SUMA******$",13,10
     numrest db 13,10,"******RESTA******$",13,10
     nummult db 13,10,"******MULTIPLICACION******$",13,10           
     numdiv db 13,10,"******DIVISION******$",13,10
     numesc db 13,10," - ESC para regresar$",13,10
    
     msj1    db 13,10,"Numero 1: $",13,10
     msj2    db 13,10,"Numero 2: $",13,10
     msj     db 13,10,"El resultado es: $",13,10
    
     salto db 13,10," "," $"
    
     ;variables de datos
     datosum db 100 dup(?)
     dato db 100 dup(?)
     var1 db 100 dup(?)
     var2 db 100 dup(?)
     resultado db 100 dup(?)
     cen db 0
     dece db 0
     uni db 0
     div1 db 0
     div2 db 0  
     cociente db 0
     residuo db 0
                 
.code

    Menu:
         mov ah,0
         mov al,3h ;modo texto
         int 10h ; interrupcion 

         mov ax,0600h 
         mov bh,0fh 
         mov cx,0000h
         mov dx,184Fh
         int 10h
         mov ah,02h
         mov bh,00
         mov dh,00
         mov dl,00
         int 10h
     
         mov ah,09 ; 
         lea dx, mostrarMenu ;se muestra el mensaje
         int 21h ;interrupcion de video
 
         mov ah,08 ;captura de datos 08 espera que el usuario presione una tecla
         int 21h
     
         cmp al,49
         je suma 
         
         cmp al,50
         je resta
     
         cmp al,51
         je multi
         
         cmp al,52 
         je division 
         je Salir
         
         
         ;OPERACION DE SUMA
         suma:
                call limpiar
                mov ah,09
                lea dx,numsum
                int 21h

                Sumas proc 
                printn " "
                print "Numero 1: "
                call scan_num
                mov datosum[0],cl;posicion 0 de la variable se almacena el primer valor
                printn " "
                print "Numero 2: "
                call scan_num
                mov datosum[1],cl;posicion 1 de la variable se almacena el primer valor
                printn " "
                xor ax,ax ;suma logica exclusiva
                add al,datosum[0]
                add al,datosum[1]
                printn " "
                print "El resultado es: "
                call print_num  
                    Sumas endp
                define_print_string
                define_print_num
                define_print_num_uns
                define_scan_num
      
                mov ah,09
                lea dx,numesc
                int 21h
    
                mov ah,01
                int 21h
 
                cmp al,27
                je Menu
         
         ;OPERCION DE RESTA
         resta:
                call limpiar
                mov ah,09
                lea dx,numrest
                int 21h
           
                ;numero 1
                mov ah, 09
                lea dx, msj1
                int 21h
                mov ah, 01
                int 21h
                sub al, 30h
                mov var1,al
    
                ;numero 2
                mov ah, 09
                lea dx, msj2
                int 21h
                mov ah, 01
                int 21h
                sub al, 30h
                mov var2,al
    
                
                mov al,var1
                sub al,var2
                mov resultado,al
    
                ;mostrando la resta
                mov ah,09
                lea dx,msj
                int 21h
                mov dl,resultado
                add dl,30h 
                mov ah,02
                int 21h
        
                mov ah,09
                lea dx,numesc
                int 21h
       
                mov ah,01
                int 21h
    
                cmp al,27
                je Menu
    
            
         ;OPERACION DE MULTIPLICACION
         multi:
                call limpiar
                mov ah,09
                lea dx,nummult  
                int 21h
    
                lea dx, msj1
                int 21h

                mov ah,01h
                int 21h

                sub al,30h ;restar 30h para obtener el primer numero
                mov var1,al 

                mov ah,09h
                lea dx, msj2 
                int 21h

                mov ah,01h
                int 21h

                sub al,30h ;restar 30h para obtener segundo numero
                mov var2,al 
   
                mov ah,09
                lea dx,salto
                int 21h

                mov al,var1
                mov bl,var2
                imul bl
                mov bl,10
                div bl
                mov bx,ax
                or bx,3030h
                mov ah,02h
                Mov dl,bl
                Int 21h
                Mov ah,02h
                Mov dl,bh
                int 21h
       
    
                mov ah,09
                lea dx,numesc
                int 21h
       
                mov ah,01
                int 21h 
        
                cmp al,27
                je Menu
      
         
         ;OPERACION  DE DIVISION       
         division:
                call limpiar
                ;teclado numero 1
                mov ah,09
                lea dx, numdiv ;nombre del mensaje
                int 21h ;interrupcion de video
                mov ah, 09
                lea dx, msj1
                int 21h
                mov ah, 01
                int 21h
                sub al, 30h
                mov div1,al
    
                ;teclado numero 2
                mov ah, 09
                lea dx, msj2
                int 21h
                mov ah, 01
                int 21h
                sub al, 30h
                mov div2,al 
    
                mov ah,09h
                lea dx,salto ;desplegar div
                int 21h
                xor ax,ax ;limpiamos el registro ax.
                mov al,div2
                mov bl,al
                mov al,div1
                div bl 
                mov bl,al
                mov dl,bl
                add dl,30h
                mov ah,02h
                int 21h
    
                mov ah,09
                lea dx,numesc
                int 21h
    
                mov ah,01;pausa y captura de datos
                int 21h
    
                cmp al,27
                je Menu    
                
         limpiar:
                mov ah,00h
                mov al,03h
                int 10h
                ret
   
           Salir:
                mov ah,04ch
                int 21h
    
end ;fin