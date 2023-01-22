;--------------------------------
    ;@file:     P1-Corrimiento_Leds.s
    ;@brief:    En este codigo hara un corrimiento de leds pares con un retardo de 500ms y un corrimiento de leds impar, sujeto a otro dos leeds donde uno prende cuando hacae un corrimiento par y el otro un corrimiento impar
    ;@date:     14/01/2023
    ;@author:   Adrian Ancajima Yangua 
    ;Frecuencia a trabajar : 4MHz
    ;TCY = 1us
    ;----------------------------
    

 
PROCESSOR 18F57Q84
#include"Bit_Config.inc"
#include <xc.inc>
#include"Retardos.inc"
PSECT inicio, class=CODE, reloc=2
Principal: 
    GOTO Main

PSECT CODE
Main:
  CALL CONFI_OSCC,1                ;Llamamos a una subrutina
  CALL CONFI_PORT,1                ;Llamamos a una subrutina
Inicio:
    BTFSC   PORTA,3,0              ; si preionamos PORA3=0
    GOTO    APAGADO_INICIAL        ;Llama a una subrutina
    
    
    ;PORA=0-> salta para encender   
Leds_pares:
    BCF     LATE,0,1               ;El RE0 tiene 0v--leed impar esta apagado
    MOVLW   1                      ; W=1
    MOVWF   0X502,a                ; (W)->0x0502
  LOPP:
    RLNCF   0x502,f,a              ;Incrementa en uno al contenido de 0x502
    MOVF    0X502,w,a              ;(0x502)->W
    BANKSEL PORTC                  ;Llamamos a PORTC
    MOVWF   PORTC,1                ;(W)->PORTC
    BSF     LATE,1,1               ;El RE1 tiene 5v--leed par esta prendido
    CALL    Delay_250ms,1          ;Retardo de 250ms de leed par a otro leed par
    CALL    Delay_250ms,1          ;Retardo de 250ms de leed par a otro leed par
    BTFSC   PORTA,3,0              ; si preionamos PORA3=0---hace un salto
    GOTO    Continua_par           ;Pasa a una subrutina
    GOTO    PARE_1                 ;Pasa a una subrutina
  Continua_par:
    BTFSC   0x502,7,0              ;si el bit 7 del registro 0x502 es 0->hace un salto
    GOTO    Leds_impar             ;Pasa a una subrutina
    RLNCF   0x502,f,a              ;Incrementa en uno al contenido de 0x502         
    MOVF    0X502,w,a              ;(0x502)->W
    GOTO    LOPP                   ;Pasa a una subrutina
    
Leds_impar:
    BCF     LATE,1,1               ;El RE1 tiene 0--leed par esta apagado
    MOVLW   1                      ;W = 1
    MOVWF   0X502,a                ;(W)->0x0502
  LOPP2:
    BANKSEL PORTC                  ;Llamamos a PORTC
    MOVWF   PORTC,1                ;(W)->PORTC 
    BSF     LATE,0,1               ;El RE0 tiene 5v--leed impar esta prendido
    CALL    Delay_250ms,1          ;Retardo de 250ms de leed impar a otro leed impar
    BTFSC   PORTA,3,0              ; si preionamos PORA3=0---Este hace un salto
    GOTO    Continua_impar         ;Llamado a una subrutina
    GOTO    PARE_2                 ;Llamado a una subrutina
Continua_impar:
    BTFSC   0x502,6,0              ;si el bit 6 del registro 0x502 es 0->hace un salto
    GOTO    Leds_pares             ;Llamado a una subrutina 
    RLNCF   0x502,f,a              ;Incrementa a uno al contenido de 0x502
    RLNCF   0x502,f,a              ;Incrementa a uno al contenido de 0x502
    MOVF    0X502,w,a              ;(0x502)->W
    GOTO    LOPP2                  ;Llamado a subrutina
    
APAGADO_INICIAL:
    CLRF    PORTC,1                ;El contenido de PORTC es 0
    GOTO    Inicio                 ;Llamado a una subrutina
    
PARE_1:
   RETARDO:
    CALL    Delay_250ms            ;Retardo de 250ms para el ledd capturado
    CALL    Delay_250ms            ;Retardo de 250ms para el ledd capturado
    CALL    Delay_250ms            ;Retardo de 250ms para el ledd capturado
    CALL    Delay_250ms            ;Retardo de 250ms para el ledd capturado
   CAPTURA:
    MOVF    0X502,w,a              ;(0x502)->W
    BANKSEL PORTC                  ;Llamamos al registro PORTC
    MOVWF   PORTC,1                ;(W)->PORTC
    BSF     LATE,1,1               ;El RE1 tiene 5v--leed par esta prendido
    BTFSC   PORTA,3,0              ;si preionamos PORA3=0-> Hace un salto
    GOTO    CAPTURA                ;Llamamos a una subritna 
    GOTO    Continua_par           ;Llamamos a una subrutina 
   
PARE_2:
   RETARDO2:
    CALL    Delay_250ms            ;Retardo de 250ms para el ledd capturado
    CALL    Delay_250ms            ;Retardo de 250ms para el ledd capturado
    CALL    Delay_250ms            ;Retardo de 250ms para el ledd capturado
    CALL    Delay_250ms            ;Retardo de 250ms para el ledd capturado
   CAPTURA2:  
    MOVF    0X502,w,a              ;(0x502)->W
    BANKSEL PORTC                  ;Llamamos al registro PORTC
    MOVWF   PORTC,1                ;(W)->PORTC
    BSF     LATE,0,1               ;El RE0 tiene 5v--leed impar esta prendido
    BTFSC   PORTA,3,0              ;si preionamos PORA3=0-> Hace un salto
    GOTO    CAPTURA2               ;Llamamos a una subrutina  
    GOTO    Continua_impar         ;Llamamos a una subrutina 
    
  
  CONFI_OSCC:  
    ;Configuracion del oscilador interno a una frecuencia de 4MHz
    BANKSEL OSCCON1 
    MOVLW 0x60                    ;Seleccionamos el bloque del osc con un div:1
    MOVWF OSCCON1
    MOVLW 0x02                    ; Seleccionamos una frecuencia de 4Hz
    MOVWF OSCFRQ
    
  CONFI_PORT:
    ; Conf. de puertos para los leds de corrimiento
    BANKSEL PORTC   
    CLRF    PORTC,1	          ;PORTC=0
    CLRF    LATC,1	          ;LATC=0, Leds apagado
    CLRF    ANSELC,1	          ;ANSELC=0, Digital
    CLRF    TRISC,1	          ;Todos salidas 
    ; Conf. de leds para visualizar cuando se da el corrimiento par o impar.
    BANKSEL PORTE   
    CLRF    PORTE,1	          ;PORTC=0
    BCF     LATE,0,1	          ;LATC=1, Leds apagado
    BCF     LATE,1,1              ;LATC=1, Leds apagado
    CLRF    ANSELE,1	          ;ANSELC=0, Digital
    CLRF    TRISE,1	          ;Todos salidas 
    ;confi butom
    BANKSEL PORTA
    CLRF    PORTA,1	          ;El contenido de PORTA es 0 
    CLRF    ANSELA,1	          ;ANSELA=0, Digital
    BSF	    TRISA,3,1	          ; TRISA=1 -> entrada
    BSF	    WPUA,3,1	          ;Activo la reistencia Pull-Up
    RETURN
END Principal