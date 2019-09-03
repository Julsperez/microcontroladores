/*
 * Se?ales_cuadradas.asm
 *
 *  Created: 26/05/2019 02:18:18 p. m.
 *   Author: quetz
 */ 

.include "m8535def.inc"




;; toggle a bit in a output
.macro toggle
	sbis @0,@1
	rjmp toggle_set_macro_label
	cbi @0,@1 
	rjmp exitToggleMacro

	toggle_set_macro_label:
		sbi @0,@1

	exitToggleMacro:
	
.endmacro





.def temp = R16
.def cont = R17

.set factor = 50 ; 500khz -> 10khz







; AQUI SE INDICA LA POSICION DONDE COMENZARA EL PROGRAMA 
; ADEMAS DE LA DIRECCION DE LAS INTERRUPCIONES PARA REALIZAR LAS RUTINAS INDICADAS

.org 0x00
rjmp START ; Reset Handler

.org 0x13 ; TIM0_COMP Handler
rjmp TIM0_COMP




START: ; Main program start
	ldi temp, high(RAMEND)
    out SPH,temp ; Set Stack Pointer to top of RAM
    ldi temp, low(RAMEND)
    out SPL,temp

	ser temp
	;out DDRA,temp ; se declara el puerto A como salida
	out DDRC,temp ; se declara el puerto C como salida
	;out PORTB,temp ; se declara el puerto B como entrada y pull ups
	;out PORTD,temp ; se declara el puerto D como entrada y pull ups


	; habilitar interrupciones y modo
	ldi temp,$02 ; OCIE0
	out TIMSK, temp

	ldi temp,$0a ; CTC, 8 prescaler
	out TCCR0,temp

	ldi temp,1
	out OCR0,temp

	sei ; SE HABILITA LA INTERRUPCION GLOBAL


	clr cont


	main: ; BUCLE INFINITO

	rjmp main





TIM0_COMP: ; rutina para interrupcion TIM0_COMP
	toggle portc,1

	cpi cont,factor
	brne exit_TIM0_COMP

	clr cont
	toggle portc,0

	
	exit_TIM0_COMP:
		inc cont
		reti