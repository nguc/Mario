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


.globl startingPoint
startingPoint:
ldr   r0, =LifeCount
ldrb  r1, [r0]
mov   r1, #51
strb  r1, [r0]

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

    ldr r1, =OldCellObject
    mov r2, #9
    strb r2, [r1]

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
