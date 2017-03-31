.section .text

.globl inGameControl
inGameControl:

  LRPush  .req    r3              // 0 - none; 1 - left pushed; 2 - right pushed

  push  {r4-r5, lr}

gameControls:

  mov 	r0, #1
  lsl 	r0, #18
  bl 		wait                    // make a delay so user doesnt double click

  mov   LRPush, #0              // reset to 0

  bl    read_SNES               // get info about which buttons are pressed

  ldr 	r1, =0xffff 						// value if no buttons pressed
  teq   r0, r1                  // test if no buttons pressed
  beq   gameControls            // read controller again if no buttons pressed

/*checking which button(s) were pressed*/

  mov   r4, #1                  // set up bit used to test if button was pressed
  and   r5, r0, r4              // align and test bit [0]
  teq   r5, #0                  // test if "B" was pressed
  //beq   bPress

  lsl   r4, #3                  // align bit to [3]
  and   r5, r0, r4              // test if "start" was pressed
  teq   r5, #0
  beq   startPress

  lsl   r4, #2                  // align bit to [5]
  and   r5, r0, r4              // test if "down" was presed
  teq   r5, #0
  beq   downPress

  lsl   r4, #1                  // align bit to [6]
  and   r5, r0, r4              // test if "left" was presed
  teq   r5, #0
  moveq LRPush, #1

  lsl   r4, #1                  // align bit to [7]
  and   r5, r0, r4              // test if "right" was presed
  teq   r5, #0
  moveq LRPush, #2

checkA:
  mov   r4, #1
  lsl   r4, #8                  // align bit to [8]
  and   r5, r0, r4              // test if "A" was presed
  teq   r5, #0
  beq   aPress

  b     finalCheck

bPress:
 // used for powers?

startPress:
  bl DrawInGAMEMenu
  bl inGameMenuControlRead
  cmp r0, #0                  //Same thing as our startGame, if 0 Restart else QuitGame
  bne quitGame

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
  b   StartTheGame

quitGame:
  b  startingPoint

leftPress:
  bl    MoveLeft               // move player right if possible

  cmp   r0, #9                 // if nothing below mario, fall
  bne   gameControls

  bl     decendLoop            // go back up to gameControls
  b      gameControls


rightPress:
  bl    MoveRight               // move player right if possible

  cmp   r0, #9                  // if nothing below mario, fall
  bne   gameControls

  bl     decendLoop            // go back up to gameControls
  b      gameControls

downPress:
  bl    DownPressed             // do nothing unless mario is standing on an Up pipe

  cmp   r0, #9                  // if empty cell below mario, fall
  bne   gameControls

  bl    decendLoop              // if Mario went down a pipe, animation for falling to next level
  b     gameControls

aPress:                         // used for jumping


  cmp   LRPush, #1
  blt   jumpUp
  beq   jumpLeft
  bgt   jumpRight

// ================================================================================== //

jumpUp:                         // does a straight up jump
  bl  jumpUpLoop

  bl  decendLoop

  b gameControls
// ================================================================================== //

jumpLeft:                       // does an arch jump towards the left
  bl  jumpUpLoop

  cmp r0, #0
  beq gameControls

  mov   r0, #1
  lsl   r0, #15
  bl    wait                    // slow it down to see the jumping animation

  bl  MoveLU

  mov   r0, #1
  lsl   r0, #15
  bl    wait                    // slow it down to see the jumping animation

  bl  MoveLeft
  mov   r0, #1
  lsl   r0, #15
  bl    wait                    // slow it down to see the jumping animation

  bl  MoveLD
  mov   r0, #1
  lsl   r0, #15
  bl    wait                    // slow it down to see the jumping animation

  bl  decendLoop

  b   gameControls

// ================================================================================== //

jumpRight:          // does an arch jump towards the right
  bl  jumpUpLoop

  cmp r0, #0
  beq gameControls

  mov   r0, #1
  lsl   r0, #15
  bl    wait                    // slow it down to see the jumping animation

  bl  MoveRU

  mov   r0, #1
  lsl   r0, #15
  bl    wait                    // slow it down to see the jumping animation

  bl  MoveRight
  mov   r0, #1
  lsl   r0, #15
  bl    wait                    // slow it down to see the jumping animation

  bl  MoveRD
  mov   r0, #1
  lsl   r0, #15
  bl    wait                    // slow it down to see the jumping animation

  bl  decendLoop

  b   gameControls


// ================================================================================== //

jumpUpLoop:
  push  {lr}
  mov   r4, #3
jmp:
  bl    MoveUp

  cmp   r0, #2                  // check if wall block was returned above mario
  beq   BreakBlock

  cmp   r0, #4                 // chech if coin block was returned above mario
  beq   Coinblock

  mov   r0, #1
  lsl   r0, #15
  bl    wait                    // slow it down to see the jumping animation

  sub   r4, #1
  cmp   r4, #0                  // if mario has jump all cells
  bne   jmp                     // go read controller

  pop   {pc}


decendLoop:
  push  {lr}

dcn:
  mov   r0, #1
  lsl   r0, #15
  bl    wait

  mov   r0, #0                  // 0 = mario falling, not user pressing down
  bl    MoveDown

  cmp   r0, #9                  // check if it is empty
  beq   dcn

  cmp   r0, #6                   // check if it is a coin
  beq   dcn

  cmp   r0, #7                  // check if it is a goomba
  beq KillGoomba

  cmp   r0, #8                  // check if it is a Koopa
  beq   doneDCN

doneDCN:
  pop   {pc}

finalCheck:
  cmp   LRPush, #1
  blt   gameControls            // if LRPush = 0 then nothing was pressed
  beq   leftPress               // if LRPush = 1 then only left was pressed
  bgt   rightPress              // if LRPush = 2 then only right was pressed

.globl restartGameEND
restartGameEND:
pop   {r4-r5, pc}


KillGoomba:
  bl GoombaKill
  bl ScoreEvent
  bl jumpUpLoop
  bl decendLoop

  mov r0, #0                    // make mario continue to fall down
  b   doneDCN

BreakBlock:
  bl BlockBreak
  bl decendLoop

  mov r0, #0                    // make mario continue to fall down
  b   doneDCN

Coinblock:
  bl ScoreEvent                      // update score
  bl UpdateCoinBlock
  bl decendLoop

  mov r0, #0                   // make mario continue to fall down
  b   doneDCN
