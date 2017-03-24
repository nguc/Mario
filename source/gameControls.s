.section .text

.globl inGameControl
inGameControl:

  bPress   .req    r4

  push  {r4, lr}

gameControls:
  mov 	r0, #1
  lsl 	r0, #18
  bl 		wait                    // make a delay so user doesnt double click

  mov   r1, #1
  ldr   b, =Bpressed            // keeps track if b was pressed or not
  strb  r1, b                   // reset b to 1 (not pressed)

  bl    read_SNES               // get info about which buttons are pressed

  ldr 	r1, =0xffff 						// value if no buttons pressed
  teq   r0, r1                  // test if no buttons pressed
  beq   gameControls            // read controller again if no buttons pressed

/*checking which button(s) were pressed*/

  mov   r3, #1                  // set up bit used to test if button was pressed
  and   r4, r0, r3              // align and test bit [1]
  teq   r4, #0                  // test if "B" was pressed
  //beq   bPress

  lsl   r3, #3                  // align bit to [3]
  and   r4, r0, r3              // test if "start" was pressed
  teq   r4, #0
  //beq   startPress

  lsl   r3, #3                  // align bit to [6]
  and   r4, r0, r3              // test if "left" was presed
  teq   r4, #0
  beq   leftPress

  lsl   r3, #1                  // align bit to [7]
  and   r4, r0, r3              // test if "right" was presed
  teq   r4, #0
  beq   rightPress

  lsl   r3, #1                  // align bit to [8]
  and   r4, r0, r3              // test if "A" was presed
  teq   r4, #0
  beq   aPress      


bPress:
 // used for powers?

startPress:
  // open the ingame meun 
  // change to menu gameControls

leftPress:
  bl    MoveLeft
  b     gameControls

rightPress:
  bl    MoveRight               // move player right if possible
  b     gameControls            // go back up to gameControls

aPress:                         // used for jumping
  bl    MoveUp                  
  b     gameControls



.section .data
.align 2

bPressed: .byte 1               // 1 = not pressed; 0 = pressed
