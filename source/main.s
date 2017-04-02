.section    .init
.globl     _start

_start:
    b       main

.section .text

main:
  bl		InstallIntTable			// *** MUST COME FIRST, sets the stack pointer
	bl		EnableJTAG
	bl		InitFrameBuffer
  bl    Init_GPIO

  // enable GPIO IRQ lines on Interrupt Controller
	ldr		r0, =0x3F00B214			// Enable IRQs 2
	mov		r1, #0x001E0000			// bits 17 to 20 set (IRQs 49 to 52)
	str		r1, [r0]

	// Enable IRQ
	mrs		r0, cpsr
	bic		r0, #0x80
	msr		cpsr_c, r0

.globl startingPoint
startingPoint:              // resets all the gamestates to starting state and resets all game values to default values
ldr   r0, =LifeCount
ldrb  r1, [r0]
mov   r1, #51
strb  r1, [r0]

ldr   r0, =CoinINT
mov   r1, #48
strb  r1, [r0]
strb  r1, [r0, #1]

ldr   r0, =ScoreINT
ldrb  r1, [r0]
ldrb  r2, [r0,#1]
mov   r2, #48
mov   r1, #48
strb  r1, [r0]
strb  r1, [r0,#1]

ldr   r0, =CoinBlockCounter
mov   r1, #5
strb  r1, [r0]

ldr r0, =GameState1
ldr r1, =GameState1Copy
bl  GameReset

ldr r0, =GameState2
ldr r1, =GameState2Copy
bl  GameReset

ldr r0, =GameState3
ldr r1, =GameState3Copy
bl  GameReset

bl    clearScreen
bl    DrawMenu

maincontrol:
bl    mainMenuControlRead
cmp   r0, #0
bne  quit

.globl StartTheGame
StartTheGame:
    bl clearScreen

    ldr r1, =MarioPosition
    mov r2, #1
    mov r3, #17
    strb r2, [r1]
    strb r3, [r1, #1]

    ldr r1, =CurrentGameState
    mov  r2, #1
    strb r2, [r1]

    ldr   r0, =GameState1
    bl		DrawGameScreen
    b    startGame

.globl startGame
startGame:
    /*
      quit game restart stage PERFECTLY
      restart game sets to main menu, but breaks
      *to keep previous mario state don't reload =MarioPosition or anything like that.
      *to be used on start in game menu start press.
    */
    bl drawScoreBoard
    bl inGameControl
    cmp r0, #0
    beq  startingPoint

.globl restartGame1
restartGame1:
    ldr r0, =GameState1
    bl  GameReset
    b   StartTheGame
quit:
    bl   clearScreen



.globl haltLoop$
haltLoop$:
	b		haltLoop$

.section .data
