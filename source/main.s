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

ldr   r0, =GameState1
bl    GameReset

bl		DrawGameScreen


.globl startGame
startGame:
bl inGameControl



haltLoop$:
	b		haltLoop$

.section .data
