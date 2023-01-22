;--------------------------------
    ;@file:     P2-Display_7SEG.s
    ;@brief:    Cuando no esta presionado el boton del microcontrolador se muestran los valores del 0_9 y cuando se pulsa el boton se muestra las letras de A_F usando un dysplay
    ;@date:     14/01/2023
    ;@author:   Adrian Ancajima Yangua 
    ;Frecuencia a trabajar : 4MHz
    ;TCY = 1us
    ;----------------------------
    
    
PROCESSOR 18F57Q84
#include "Bit_Config.inc"  /*config statements should precede project file includes.*/
#include <xc.inc>
#include "Retardos.inc"

PSECT resetVect,class=CODE,reloc=2
    
    
resetVect:
    goto Main 
    

PSECT CODE 

Main:
    
 
 Config_OSC:
    ;Configuracion del oscilador interno a una frecuencia de 4MHz
    BANKSEL OSCCON1 
    MOVLW 0x60     ;Seleccionamos el bloque del osc con un div:1
    MOVWF OSCCON1
    MOVLW 0x02     ; Seleccionamos una frecuencia de 4Hz
    MOVWF OSCFRQ
    
    
Con_Puertos:       
    
    ;RDA_Salidas para los displays
    BANKSEL  PORTD           ;Seleccionamos el registro PORTA
    CLRF     ANSELD,1       ;El contenido de los 8 bits del registro PORTD son digital
    CLRF     LATD,1         ;El contenido de los 8 bits del registro PORTD son GND
    CLRF     TRISD,1        ;El contenido de los 8 bits del registro PORTD Son salidas
    
    ;RA3_Entrada(Boton)
    BANKSEL  PORTA           ;Seleccionamos el registro PORTA
    CLRF     PORTA,1         ;El contenido de los 8 bits del registro PORTA es 0
    CLRF     ANSELA,1        ;Los 8 bits son entrada digital
    BSF      TRISA,3,1       ;El (bit(3)=1) es una entrada 
    BSF      WPUA,3,1        ;Activamos la resistencia RA3 
   
Boton:  
    BTFSC    PORTA,3,1       ; Si presionas = 0 --> (b(3)=0?), si es 0 entonces hace un salto
    GOTO    No_Presionado   ; Regresa a la subrutina No_Presionado
    
Si_Presionado:
    
    
  ;Valores (A_F) 
  ;RD0(a),RD1(b),RD2(c),RD3(d);RD4(e);RD5(f);RD6(g);RD7(.)  
  
  
;Letra_A
    CLRF     PORTD,1           ;El contenido de los 8 bits del registro PORTD es 0 
    BSF      PORTD,7,1         ;El (bit(7)=1)
    BSF      PORTD,3,1         ;El (bit(7)=1)
    CALL     Delay_250ms      ;Retardo de 250ms de A_B
    CALL     Delay_250ms      ;Retardo de 250ms de A_B
    CALL     Delay_250ms      ;Retardo de 250ms de A_B
    CALL     Delay_250ms      ;Retardo de 250ms de A_B
    BTFSC    PORTA,3,1         ;Si presionas = 0 --> (b(3)=0?), si es 0 entonces hace un salto
    GOTO     No_Presionado     ;Regresa a la subrutina No_Presionado
  
  ;Letra_b
    MOVLW    10000011B        ;10000011-->(W)
    MOVWF    PORTD,1          ;(w)-> PORTD, PORTD= 10000011
    CALL     Delay_250ms      ;Retardo de 250ms de B_C
    CALL     Delay_250ms      ;Retardo de 250ms de B_C
    CALL     Delay_250ms      ;Retardo de 250ms de B_C
    CALL     Delay_250ms      ;Retardo de 250ms de B_C
    BTFSC    PORTA,3,1         ;Si presionas = 0 --> (b(3)=0?), si es 0 entonces hace un salto
    GOTO     No_Presionado     ;Regresa a la subrutina No_Presionado
  
;Letra_C
    MOVLW    11000110B        ;11000110-->(W)
    MOVWF    PORTD,1          ;(w)-> PORTD, PORTD= 11000110
    CALL     Delay_250ms      ;Retardo de 250ms de C_D
    CALL     Delay_250ms      ;Retardo de 250ms de C_D
    CALL     Delay_250ms      ;Retardo de 250ms de C_D
    CALL     Delay_250ms      ;Retardo de 250ms de C_D
    BTFSC    PORTA,3,1         ;Si presionas = 0 --> (b(3)=0?), si es 0 entonces hace un salto
    GOTO     No_Presionado     ;Regresa a la subrutina No_Presionado
  
 ;Letra_d
    MOVLW    10100001B        ;10100001-->(W)
    MOVWF    PORTD,1          ;(w)-> PORTD, PORTD= 10100001
    CALL     Delay_250ms      ;Retardo de 250ms de D_E
    CALL     Delay_250ms      ;Retardo de 250ms de D_E
    CALL     Delay_250ms      ;Retardo de 250ms de D_E
    CALL     Delay_250ms      ;Retardo de 250ms de D_E
    BTFSC    PORTA,3,1         ;Si presionas = 0 --> (b(3)=0?), si es 0 entonces hace un salto
    GOTO     No_Presionado     ;Regresa a la subrutina No_Presionado
  
  
  ;Letra_E  
    MOVLW    10000110B        ;10000110-->(W)
    MOVWF    PORTD,1          ;(w)-> PORTD, PORTD= 10000110
    CALL     Delay_250ms      ;Retardo de 250ms de E_F
    CALL     Delay_250ms      ;Retardo de 250ms de E_F
    CALL     Delay_250ms      ;Retardo de 250ms de E_F
    CALL     Delay_250ms      ;Retardo de 250ms de E_F
    BTFSC    PORTA,3,1         ;Si presionas = 0 --> (b(3)=0?), si es 0 entonces hace un salto
    GOTO     No_Presionado     ;Regresa a la subrutina No_Presionado
  
;Letra_F
    MOVLW    10001110B        ;10001110-->(W)
    MOVWF    PORTD,1          ;(w)-> PORTD, PORTD= 10001110
    CALL     Delay_250ms      ;Retardo de 250ms de F_A
    CALL     Delay_250ms      ;Retardo de 250ms de F_A
    CALL     Delay_250ms      ;Retardo de 250ms de F_A
    CALL     Delay_250ms      ;Retardo de 250ms de F_A
    BTFSC    PORTA,3,1         ;Si presionas = 0 --> (b(3)=0?), si es 0 entonces hace un salto
    GOTO     No_Presionado     ;Regresa a la subrutina No_Presionado
    RETURN                    ;Retornar a la subrutina donde pertenece en este caso (Si_Presiona)
    

No_Presionado:
  ;Valores (0_9)
  ;RD0(a),RD1(b),RD2(c),RD3(d);RD4(e);RD5(f);RD6(g);RD7(.) 
  
  
  ;Numero_0
 
    MOVLW    11000000B        ;11000000-->(W)
    MOVWF    PORTD,1          ;(w)-> PORTD, PORTD= 10000011
    CALL     Delay_250ms      ;Retardo de 250ms de 0_1
    CALL     Delay_250ms      ;Retardo de 250ms de 0_1
    CALL     Delay_250ms      ;Retardo de 250ms de 0_1
    CALL     Delay_250ms      ;Retardo de 250ms de 0_1
    BTFSS    PORTA,3,1        ;No presionas = 1 --> (b(3)=1?), si es 1 entonces hace un salto
    GOTO     Si_Presionado    ;Regresa a la subrutina Si_Presionado
    
;Numero_1
    MOVLW    11111001B        ;11111001-->(W)
    MOVWF    PORTD,1          ;(w)-> PORTD, PORTD= 11111001
    CALL     Delay_250ms      ;Retardo de 250ms de 1_2
    CALL     Delay_250ms      ;Retardo de 250ms de 1_2
    CALL     Delay_250ms      ;Retardo de 250ms de 1_2
    CALL     Delay_250ms      ;Retardo de 250ms de 1_2
    BTFSS    PORTA,3,1        ;No presionas = 1 --> (b(3)=1?), si es 1 entonces hace un salto
    GOTO     Si_Presionado    ;Regresa a la subrutina Si_Presionado
    
    
;Numero_2
    MOVLW    10100100B        ;10100100-->(W)
    MOVWF    PORTD,1          ;(w)-> PORTD, PORTD= 10100100
    CALL     Delay_250ms      ;Retardo de 250ms de 2_3
    CALL     Delay_250ms      ;Retardo de 250ms de 2_3
    CALL     Delay_250ms      ;Retardo de 250ms de 2_3
    CALL     Delay_250ms      ;Retardo de 250ms de 2_3
    BTFSS    PORTA,3,1        ;No presionas = 1 --> (b(3)=1?), si es 1 entonces hace un salto
    GOTO     Si_Presionado    ;Regresa a la subrutina Si_Presionado
  
;Numero_3
    MOVLW    10110000B        ;10110000-->(W)
    MOVWF    PORTD,1          ;(w)-> PORTD, PORTD= 10110000
    CALL     Delay_250ms      ;Retardo de 250ms de 3_4
    CALL     Delay_250ms      ;Retardo de 250ms de 3_4
    CALL     Delay_250ms      ;Retardo de 250ms de 3_4
    CALL     Delay_250ms      ;Retardo de 250ms de 3_4
    BTFSS    PORTA,3,1        ;No presionas = 1 --> (b(3)=1?), si es 1 entonces hace un salto
    GOTO     Si_Presionado    ;Regresa a la subrutina Si_Presionado
  
;Numero_4
    MOVLW    10011001B        ;10011001-->(W)
    MOVWF    PORTD,1          ;(w)-> PORTD, PORTD= 10011001
    CALL     Delay_250ms      ;Retardo de 250ms de 4_5
    CALL     Delay_250ms      ;Retardo de 250ms de 4_5
    CALL     Delay_250ms      ;Retardo de 250ms de 4_5
    CALL     Delay_250ms      ;Retardo de 250ms de 4_5
    BTFSS    PORTA,3,1        ;No presionas = 1 --> (b(3)=1?), si es 1 entonces hace un salto
    GOTO     Si_Presionado    ;Regresa a la subrutina Si_Presionado
  
;Numero_5 
    MOVLW    10010010B        ;10010010-->(W)
    MOVWF    PORTD,1          ;(w)-> PORTD, PORTD= 10010010
    CALL     Delay_250ms      ;Retardo de 250ms de 5_6
    CALL     Delay_250ms      ;Retardo de 250ms de 5_6
    CALL     Delay_250ms      ;Retardo de 250ms de 5_6
    CALL     Delay_250ms      ;Retardo de 250ms de 5_6
    BTFSS    PORTA,3,1        ;No presionas = 1 --> (b(3)=1?), si es 1 entonces hace un salto
    GOTO     Si_Presionado    ;Regresa a la subrutina Si_Presionado
    
  
;Numero_6
    MOVLW    10000010B        ;10000010-->(W)
    MOVWF    PORTD,1          ;(w)-> PORTD, PORTD= 10000010
    CALL     Delay_250ms      ;Retardo de 250ms de 6_7
    CALL     Delay_250ms      ;Retardo de 250ms de 6_7
    CALL     Delay_250ms      ;Retardo de 250ms de 6_7
    CALL     Delay_250ms      ;Retardo de 250ms de 6_7
    BTFSS    PORTA,3,1        ;No presionas = 1 --> (b(3)=1?), si es 1 entonces hace un salto
    GOTO     Si_Presionado    ;Regresa a la subrutina Si_Presionado
  

;Numero_7 
    MOVLW    11111000B        ;111110000-->(W)
    MOVWF    PORTD,1          ;(w)-> PORTD, PORTD= 11111000
    CALL     Delay_250ms      ;Retardo de 250ms de 7_8
    CALL     Delay_250ms      ;Retardo de 250ms de 7_8
    CALL     Delay_250ms      ;Retardo de 250ms de 7_8
    CALL     Delay_250ms      ;Retardo de 250ms de 7_8
    BTFSS    PORTA,3,1        ;No presionas = 1 --> (b(3)=1?), si es 1 entonces hace un salto
    GOTO     Si_Presionado    ;Regresa a la subrutina Si_Presionado
  
;Numero_8
    MOVLW    10000000B        ;1000000-->(W)
    MOVWF    PORTD,1          ;(w)-> PORTD, PORTD= 1000000
    CALL     Delay_250ms      ;Retardo de 250ms de 8_9
    CALL     Delay_250ms      ;Retardo de 250ms de 8_9
    CALL     Delay_250ms      ;Retardo de 250ms de 8_9
    CALL     Delay_250ms      ;Retardo de 250ms de 8_9
    BTFSS    PORTA,3,1        ;No presionas = 1 --> (b(3)=1?), si es 1 entonces hace un salto
    GOTO     Si_Presionado    ;Regresa a la subrutina Si_Presionado
  
;Numero_9

    MOVLW    10011000B        ;10011000-->(W)
    MOVWF    PORTD,1          ;(w)-> PORTD, PORTD= 10011000
    CALL     Delay_250ms      ;Retardo de 250ms de 9_0
    CALL     Delay_250ms      ;Retardo de 250ms de 9_0
    CALL     Delay_250ms      ;Retardo de 250ms de 9_0
    CALL     Delay_250ms      ;Retardo de 250ms de 9_0
    BTFSS    PORTA,3,1        ;No presionas = 1 --> (b(3)=1?), si es 1 entonces hace un salto
    GOTO     Si_Presionado    ;Regresa a la subrutina Si_Presionado
    RETURN
END resetVect    