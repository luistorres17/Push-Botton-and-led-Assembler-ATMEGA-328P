; Programa para encender un LED con un botón usando el Atmega328P
; El LED se apaga al presionar el botón y se enciende al soltarlo

.include "m328pdef.inc"      ; Incluir la definición del microcontrolador

.org 0x0000                  ; Dirección de inicio del programa
rjmp start                   ; Salto a la etiqueta de inicio

start:
    ; Configuración del pin 0 del puerto D como salida (LED)
    ldi r16, 0x01            ; Cargar el valor 0x01 en r16 (bit 0 en alto)
    out DDRD, r16            ; Configurar el pin 0 del puerto D como salida (DDRD = 0x01)

    ; Configuración del pin 2 del puerto D como entrada con pull-up
    ldi r16, 0x04            ; Cargar el valor 0x04 en r16 (bit 2 en alto)
    out PORTD, r16           ; Habilitar el pull-up interno en el pin 2 del puerto D (PORTD = 0x04)

    ; Inicializar el LED como encendido
    ldi r16, 0x01            ; Inicializar el LED como encendido
    out PORTD, r16           ; Encender el LED al principio

loop:
    ; Leer el estado del pin 2 (entrada del botón)
    in r17, PIND             ; Leer el registro de entrada (PIND)
    sbrs r17, 2              ; Saltar si el bit 2 de PIND está en 0 (botón presionado)
    rjmp loop                ; Volver al inicio del bucle si el botón no está presionado

    ; Cambiar el estado del LED
    in r17, PORTD            ; Leer el estado actual del LED (de PORTD)
    ldi r18, 0x01            ; Cargar el valor 0x01 en r18 (para alternar el LED)
    eor r17, r18             ; Invertir el estado actual del LED
    out PORTD, r17           ; Escribir el nuevo estado del LED en PORTD

    ; Esperar a que el botón se suelte (no presionado)
wait_release:
    in r17, PIND             ; Leer el registro de entrada nuevamente
    sbrc r17, 2              ; Saltar si el bit 2 de PIND está en 1 (botón no presionado)
    rjmp wait_release        ; Volver a leer hasta que se suelte el botón

    rjmp loop                ; Volver al inicio del bucle
