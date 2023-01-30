;--------------------------------
    ;@file:     Parcial2-Ejercicio2
    ;@brief:    Este programa hace un toggle de led de la 
    ;           placa(RF3, que es el programa principal),
    ;           cuando pulsas la INT0(RA3) inicia una secuencia de leds,si 
    ;           presionas INT1(RB4) capta los leds almomento que pulsate, y 
    ;           vuelve al programa principal, mientras que INT2(RF2) reinicia
    ;           la secuencia y vuelve al progrma principal, y si no pulsas
    ;           INT1 O INT2,entonces durante 5 repeticiones de la secuencia 
    ;           de leds, acaba la secuencia y vuvle al programa principal
    ;@author:   Adrian Ancajima Yangua 
    ;Grupo:     6
    ;@date:     29/01/2023
    ;Frecuencia a trabajar : 4MHz
    ;TCY = 1us
    ;----------------------------
PROCESSOR 18F57Q84
#include "Bit_Config.inc" 
#include<xc.inc>    
PSECT udata_acs
Conta5:     DS 1    ; 1BYTE a Contar5 donde este se guarda en access ram   
Contar:     DS 1    ; 1BYTE a Contar5 donde este se guarda en access ram  
Offset:     DS 1    ; 1BYTE a Contar5 donde este se guarda en access ram 
Verificar:  DS 1    ; 1BYTE a Contar5 donde este se guarda en access ram
Variable1:  DS 1    ; 1BYTE a Contar5 donde este se guarda en access ram
Variable2:  DS 1    ; 1BYTE a Contar5 donde este se guarda en access ram
  
PSECT BajaPrioridad,class=CODE,reloc=2
BajaPrioridad:
    BTFSS   PIR1,0,0     ;¿Se ha producido la INT0?-->PIR1(0)=1??, 
    GOTO    Exit1        ;se va a la subrutina Exit1
    BCF	    PIR1,0,0     ;limpiamos el flag de INT0
    GOTO    Iniciar      ;se va a la subrutina Iniciar
Exit1:
    RETFIE         
  
PSECT AltaPrioridad,class=CODE,reloc=2
AltaPrioridad:
    BTFSC   PIR6,0,0     ;¿Se ha producido la INT1?-->PIR6(0)=0??, 
    GOTO    Captura      ;se va a la subrutina Captura
    BTFSC   PIR10,0,0    ;¿Se ha producido la INT2?-->PIR10(0)=0??, 
    GOTO    Reinicia
Exit3:  
    RETFIE  
PSECT resetVect,class=CODE,reloc=2
resetVect:
    goto Main
        
PSECT CODE 
Main:
    CALL   CONFI_OSC,1    ;Llamamos a la subrutina CONFI_OS
    CALL   CONFI_PORT,1   ;Llamamos a la subrutina CONFI_POR
    CALL   CONFI_PPS,1    ;Llamamos a la subrutina CONFI_PPS
    CALL   CONFI_INTG,1   ;Llamamos a la subrutina CONFI_INTG
    
Toggle_Led:
    BANKSEL LATF             ;Llamamos a LATF
    BTG	    LATF,3,0         ;Complemento de LATF(3)
    CALL    Delay_250ms,1    ;Llamamos a la subrutina Delay_250ms
    CALL    Delay_250ms,1    ;Llamamos a la subrutina Delay_250ms
    BTG	    LATF,3,0         ;Cambiar el LATF(3)
    CALL    Delay_250ms,1    ;Llamamos a la subrutina Delay_250ms
    CALL    Delay_250ms,1    ;Llamamos a la subrutina Delay_250ms
    GOTO    Toggle_Led       ;se va a la subrutina Toggle_Led
Iniciar:
    MOVLW   5           ;(W)= 5
    MOVWF   Conta5,0    ;(W)-->Conta5,y es el numero de repeti.. de la S.L
    MOVLW   0           ;(W)=0
    MOVWF   Verificar,0 ;(W)-->Verificar,nos permite para hacer la C.L y R.P 
    GOTO    Siguiente   ;se va a la subrutina Siguiente   
    
Siguiente: 
    BSF	    LATF,3,1      ; LATF(3) tiene un estado de 5V---Led apagado
    MOVLW   10            ; W=10
    MOVWF   Contar,0       ;(W)-->Contar,es el numero de V.O h que hace
    MOVLW   0x00          ;(W)=0
    MOVWF   Offset,0      ;(W)-->Offset, Offset es el valor del offset  
    GOTO    Loop          ; se va a la subrutina Loop  
    
Loop: 
    BANKSEL PCLATU              ; Llamamos a PCLATU
    MOVLW   low highword(Table) ; (W)=low highword(Table),Cargar el B.S (CPU)
    MOVWF   PCLATU,1            ; (W)-->PCLATU , Escribir el B.S a PCLATU 
    MOVLW   high(Table)         ; (W -->high(Table), cargar el B.A (PCH)
    MOVWF   PCLATH,1            ; (W)-->PCLATH, Escribir el B.A en PCLATH
    RLNCF   Offset,0,0          ; Rotacion del Offset de izquierda a derecha 
    CALL    Table               ; Llamamos a la subrutina Table 
    MOVWF   LATC,0              ; (W)-->LATC
    CALL    Delay_250ms         ; Llamamos a la subrutina Delay_250ms
    DECFSZ  Contar,1,0          ; Decrementa en menos uno a Contar,Contar=0? 
    GOTO    SecuenOff           ; se va a la subrutina SecuenOff    
    GOTO    Apagado             ; se va a la subrutina Apagado
SecuenOff:
    INCF    Offset,1,0          ; Incrementa en uno mas al Ofsset
    BTFSS   Verificar,1,0       ; si Verificar(1)=1, entonces hace un salto 
    GOTO    Loop                ; se va a la subrutina Loop
    GOTO    Exit1               ; se va a la subrutina Exit1 
    
Apagado:
    DECFSZ  Conta5,1,0    ; Decrementa en menos uno a Conta5,Conta5=0?
    GOTO    Siguiente     ; se va a la subrutina Siguiente
    GOTO    Exit1         ; se va a la subrutina  Exit1 
    
Table:
    ADDWF   PCL,1,0     ;(W)+PCL
    RETLW   01111110B   ;Offset: 0 ,(offset)-->W y retorna a la S.I
    RETLW   10111101B   ;Offset: 1 ,(offset)-->W y retorna a la S.I 
    RETLW   11011011B   ;Offset: 2 ,(offset)-->W y retorna a la S.I
    RETLW   11100111B   ;Offset: 3 ,(offset)-->W y retorna a la S.I
    RETLW   11111111B   ;Offset: 4 ,(offset)-->W y retorna a la S.I
    RETLW   11100111B   ;Offset: 5 ,(offset)-->W y retorna a la S.I
    RETLW   11011011B   ;Offset: 6 ,(offset)-->W y retorna a la S.I
    RETLW   10111101B   ;OFfset: 7 ,(offset)-->W y retorna a la S.I
    RETLW   01111110B   ;Offset: 8 ,(offset)-->W y retorna a la S.I
    RETLW   11111111B   ;Offset: 9 ,(offset)-->W y retorna a la S.I
 
Captura:
    BCF	    PIR6,0,0      ; limpiamos el flag de INT1
    SETF    Verificar,0   ; Verificar = FFh 
    GOTO    Exit3         ; se va a la subrutina Exit3
    
Reinicia:
    BCF	    PIR10,0,0     ; limpiamos el flag de INT2
    SETF    Verificar,0   ; Verificar = FFh 
    SETF    LATC,0        ; LATC = FFh
    GOTO    Exit3         ; se va a la subrutina Exit3
   

CONFI_OSC:  
    BANKSEL OSCCON1
    MOVLW   0x60      ;selecionar el bloque del oscilador interno con un div:1
    MOVWF   OSCCON1,1 ;(W)-->OSCCON1
    MOVLW   0x02      ;seleccionamos una frecuencia de 4MHz
    MOVWF   OSCFRQ,1  ;(W)-->OSCFRQ
    RETURN
    
CONFI_PORT:
    ;PORTA (RA3,PULSADOR DE LA PLACA--INT0)
    BANKSEL PORTA
    CLRF    PORTA,1	
    CLRF    ANSELA,1    ;ANSELA = 0 -- Digital
    BSF	    TRISA,3,1   ;TRISA = 1 --> entrada
    BSF	    WPUA,3,1    ;Activo la reistencia Pull-Up
    
    ;PORTB (RB4--INT1) 
    BANKSEL PORTB
    CLRF    PORTB,1
    BCF     ANSELB,4,1    ; Puerto digital
    BSF     TRISB,4,1     ; Puerto Entrada 
    BSF     WPUB,4,1      ; Activamos la resistencia
    
    ;Configuracion de PORTC
    BANKSEL PORTC       ;Llamamos a PORTC
    SETF    PORTC,1     ;PORTC = 0
    SETF    LATC,1      ;LATC = 0 -- Leds apagado
    CLRF    ANSELC,1    ;ANSELC = 0 -- Digital
    CLRF    TRISC,1 
    
    ;PORTF (RF2 Y RF3,INT2 Y LED DE LA PLACA)
    BANKSEL PORTF       ;Llamamos a PORTF
    CLRF    PORTF,1     ;PORTF = 0
    CLRF    ANSELF,1    ;ANSELF = 0 -- Digital    
    ;RF2---INT2
    BSF     TRISF,2,1   ; Puerto de Entrada 
    BSF     WPUF,2,1    ; Activamos la resistencia
    ;RF3---LED PLACA  
    BSF     LATF,3,1    ; LATF(3) tiene un estado de 5V---Led apagado
    BCF     TRISF,3,1   ;Puerto de salida
    RETURN 
    
CONFI_PPS:
    ;Config INT0
    BANKSEL INT0PPS     ;Llamamos a INT0PPS
    MOVLW   0x03        ;(W)=0x03h
    MOVWF   INT0PPS,1   ;(W)-->INT0PPS, entonces INT0 --> RA3  
   
    ;Config INT1
    BANKSEL INT1PPS     ;Llamamos a INT1PPS
    MOVLW   0x0C        ;(W)=0x0Ch
    MOVWF   INT1PPS,1   ;(W)-->INT1PPS, entonces INT1 --> RB4
    
    ;Config INT2
    BANKSEL INT2PPS     ;Llamamos a INT2PPS
    MOVLW   0x2A        ;(W)=0x2Ah
    MOVWF   INT2PPS,1   ;(W)-->INT1PPS, entonces INT2 --> RF2
    RETURN
CONFI_INTG:
    ;Prioridades
    BSF	INTCON0,5,0    ;INTCON0<IPEN> = 0 -- Habilitar prioridades
    BANKSEL IPR1
    BCF	IPR1,0,1       ;IPR1<INT0IP> = 0 -- INT0 de BAJA prioridad
    BSF	IPR6,0,1       ;IPR6<INT1IP> = 0 -- INT1 de baja prioridad
    BSF	IPR10,0,1      ;IPR10<INT2IP> = 1 -- INT2 de ALTA prioridad
    
    ;Configuracion INT0
    BCF	INTCON0,0,0   ;INTCON0<INT0EDG> = 0 -- INT0 por flanco de bajada
    BCF	PIR1,0,0      ;PIR1<INT0IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE1,0,0      ;PIE1<INT0IE> = 1 -- habilitamos la interrupcion ext
   
    ;Configuracion INT1
    BCF	INTCON0,1,0   ;INTCON0<INT1EDG> = 0 -- INT1 por flanco de bajada
    BCF	PIR6,0,0      ;PIR6<INT1IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE6,0,0      ;PIE6<INT1IE> = 1 -- habilitamos la interrupcion ext1
    
    ;Configuracion INT2
    BCF	INTCON0,2,0   ;INTCON0<INT2EDG> = 0 -- INT2 por flanco de bajada
    BCF	PIR10,0,0     ;PIR10<INT2IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE10,0,0     ;PIE10<INT2IE> = 1 -- habilitamos la interrupcion ext1
    ;Globales
    BSF	INTCON0,7,0   ;INTCON0<GIE/GIEH> = 1, habilitar la I de forma global
    BSF	INTCON0,6,0   ;INTCON0<GIEL> = 1 -- habilitar la I de baja prioridad
    RETURN
    
    ;; Retardo15(250ms)
;T= k2*(6+4(249))us + k2*(1us) + 6us = 250*(1ms) + 250us + 6us = 250.256ms
Delay_250ms:                ;  2TCY---Call
    MOVLW  250              ;  1TCY... k2=250
    MOVWF  Variable2,0      ;  1TCY
    ;T = (6+4k1)us = (6+4*(249))us = 1ms 
Loop_Ext8:  
    MOVLW  249              ;  k2*TCY.... k1=249
    MOVWF  Variable1,0      ;  k2*TCY
Loop_Int8:
    Nop                     ;  k2*k1*TCY
    DECFSZ Variable1,1,0    ;  k2*((k1-1) + 3*Tcy)
    GOTO   Loop_Int8        ;  k2*((k1-1)*2TCY)
    DECFSZ Variable2,1,0    ;  (k2-1) + 3*TCY
    GOTO   Loop_Ext8        ;  (k2-1)*2TCY
    RETURN                  ;  2*TCY	
END resetVect	   