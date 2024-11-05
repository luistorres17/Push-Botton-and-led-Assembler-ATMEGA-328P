; Programa para encender un LED con un bot�n usando el Atmega328P
; El LED se apaga al presionar el bot�n y se enciende al soltarlo

.include "m328pdef.inc"      ; Incluir la definici�n del microcontrolador

.org 0x0000                  ; Direcci�n de inicio del programa
rjmp start                   ; Salto a la etiqueta de inicio

start:
    ; Configuraci�n del pin 0 del puerto D como salida (LED)
    ldi r16, 0x01            ; Cargar el valor 0x01 en r16 (bit 0 en alto)
    out DDRD, r16            ; Configurar el pin 0 del puerto D como salida (DDRD = 0x01)

    ; Configuraci�n del pin 2 del puerto D como entrada con pull-up
    ldi r16, 0x04            ; Cargar el valor 0x04 en r16 (bit 2 en alto)
    out PORTD, r16           ; Habilitar el pull-up interno en el pin 2 del puerto D (PORTD = 0x04)

    ; Inicializar el LED como encendido
    ldi r16, 0x01            ; Inicializar el LED como encendido
    out PORTD, r16           ; Encender el LED al principio

loop:
    ; Leer el estado del pin 2 (entrada del bot�n)
    in r17, PIND             ; Leer el registro de entrada (PIND)
    sbrs r17, 2              ; Saltar si el bit 2 de PIND est� en 0 (bot�n presionado)
    rjmp loop                ; Volver al inicio del bucle si el bot�n no est� presionado

    ; Cambiar el estado del LED
    in r17, PORTD            ; Leer el estado actual del LED (de PORTD)
    ldi r18, 0x01            ; Cargar el valor 0x01 en r18 (para alternar el LED)
    eor r17, r18             ; Invertir el estado actual del LED
    out PORTD, r17           ; Escribir el nuevo estado del LED en PORTD

    ; Esperar a que el bot�n se suelte (no presionado)
wait_release:
    in r17, PIND             ; Leer el registro de entrada nuevamente
    sbrc r17, 2              ; Saltar si el bit 2 de PIND est� en 1 (bot�n no presionado)
    rjmp wait_release        ; Volver a leer hasta que se suelte el bot�n

    rjmp loop                ; Volver al inicio del bucle
