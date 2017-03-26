.section    .init
.globl     _start

_start:
    b       main

.section .text

main:
  mov     sp, #0x8000
	bl		EnableJTAG
	bl		InitFrameBuffer
  bl    Init_GPIO

bl clearScreen
bl GameReset

mov		r0, #0
mov		r1, #0
ldr   r2, =GameState1Copy
bl		DrawGameScreen


.globl startGame
startGame:

bl inGameControl



haltLoop$:
	b		haltLoop$

.section .data
