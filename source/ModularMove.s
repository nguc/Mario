/*
* Calculates and draws mario "moving"
* Move directions: 0 - none; 1 - right; 2 - left; 3 - up; 4 - down
*/


.section .data
.align 2

.globl MarioPosition
MarioPosition: .byte  1, 17        	// Starting x and y coord of Mario - will change when mario moves

.globl CurrentGameState
CurrentGameState:	.byte 1 				// keeps track of which game screen we are in

.globl CoinBlockCounter
CoinBlockCounter: .byte 5


.section .text

/* Moves Mario right if he is allowed
 * Args:
 *  none
 * Return:
 *  r0 - object below mario
 */
.globl MoveRight
MoveRight:
  marioX        .req  r4
  marioY        .req  r5
  currentCell   .req  r6      		        // The cell number you are moving from
  newX          .req  r7          	      // The cell number to the left of crnt position
  marioStartPos .req  r8       	          // What is in the cell (ex. wall)
  GameState     .req  r9                 // Holds address of the GameState array

  push        {r4-r9,lr}

  bl    GetCurrentGameState                // gets the address of the current game state array
  mov   GameState, r0                      // save the return value 

  ldr   r1, =MarioPosition      	         // Load address for location of Mario
  ldrb  marioX, [r1]                       // loading x coord of mario
  ldrb  marioY, [r1, #1]                   // loadking y coord of marioY
  add   newX, marioX, #1                   // Find x value of cell to the right (int)

  cmp     newX, #24                         // check if mario is going to move off screen -> go to new stage
  blt     contR                             // if still in screen continue check if he can move

  // ==== moving mario to a new stage ==== //
 
  mov     r0, marioX
  mov     r1, marioY
  mov     r2, GameState
  bl      ReplaceMarioInCurrent            // delete mario on screen and replace his array value with an empty cell
  
  mov     r0, #0                           // starting x coord
  mov     r1, #17                           // starting y coord
  mov     r2, #3                           // stage we are moving to 
  bl      SetupNextStage                   // set global variables and draw new stage

  b     doneR

 // ==== check if mario can move ==== //
contR:
  mov   r2, #24
  mla   currentCell, marioY, r2, newX      // check if move valid by checking object to the right of mario. currentCell = (y * width) + Newx
  ldrb  r0, [GameState, currentCell]
  mov   r1, #1                             // pass in direction
  mov   r2, currentCell
  bl    CheckMove                          // returns a value that tells us if mario can move or not

  cmp   r0, #1                             // check return value
  blt   doneR                              // if r0 is 0, then mario cant move                           
  beq   contR2                             // if r0 is 1, then mario moves right
                                           // else r0 is 2, mario dies and loses a life

// ===== mario loses a life ===== //

  mov   r0, marioX
  mov   r1, marioY
  mov   r2, GameState
  bl    ReplaceMarioInCurrent              // replace mario in array

  bl    loseLife                           // loseLife sequence

  b     doneR                              // finish with the move

// ==== mario moves to the right ==== //
contR2:                                    
  ldr   r1, =MarioPosition      	         // Load address for location of character
  strb   newX, [r1]                        // Update Mario postion

  mov   r0, marioX
  mov   r1, marioY
  mov   r2, GameState
  bl    ReplaceMarioInCurrent              // erase mario on screen and in array

  mov   r0, newX
  mov   r1, marioY
  mov   r2, GameState
  bl    MoveMarioToNewCell                 // draw mario on screen and find position to the right of mario was in array and replace

  // get object below mario
  add   marioY, marioY, #1                 
  mov   r2, #24
  mla   currentCell, marioY, r2, newX      // Find position below where mario was in array and replace
  ldrb  r0, [GameState, currentCell]       // Get object below mario

doneR:
  .unreq  marioX
  .unreq  marioY
  .unreq  currentCell
  .unreq  newX
  .unreq  marioStartPos
  .unreq  GameState

  pop   {r4-r9,pc}

// ============================================================================================================= //

/* Moves Mario left if he is allowed
 * Args:
 *  none
 * Return:
 *  r0 - object below mario
 */
.globl MoveLeft
MoveLeft:

marioX      .req  r4
marioY      .req r5
currentCell .req  r6      		// The cell number you are moving from
newX        .req  r7          	// The cell number to the left of crnt position
marioStartPos .req  r8       	// What is in the cell (ex. wall)
GameState   .req  r9          	// Holds address of the GameState array

push        {r4-r9,lr}

bl    GetCurrentGameState                // gets the address of the current game state array
mov   GameState, r0                      // save the return value 

ldr   r1, =MarioPosition      	         // Load address for location of character
ldrb  marioX, [r1]                       // loading x coord of mario
ldrb  marioY, [r1, #1]                   // loadking y coord of marioY
subs   newX, marioX, #1                  // Find x value of cell to the left (int)

cmp    newX, #0                          //check if mario is going to move off screen
bge    contL                             // if still in screen continue check if he can move

// ==== moving mario to a new stage ==== //

mov     r0, marioX
mov     r1, marioY
mov     r2, GameState
bl      ReplaceMarioInCurrent            // delete mario on screen and replace his array value with an empty cell
 
mov     r0, #23                           // starting x coord
mov     r1, #17                           // starting y coord
mov     r2, #1                           // stage we are moving to 
bl      SetupNextStage                   // set global variables and draw new stage

b     doneL

// ==== check if mario can move ==== //
contL:
  mov   r2, #24                            // checking if move is valid by checking object to the left of mario
  mla   currentCell, marioY, r2, newX      // Calculate cell to the left of mario, currentCell = (y * width) + Newx
  ldrb  r0, [GameState, currentCell]
  mov   r1, #2                             // pass in direction
  mov   r2, currentCell
  bl    CheckMove

  cmp   r0, #1                             // check return value
  blt   doneL                              // if r0 is 0, then mario cant move                           
  beq   contL2                             // if r0 is 1, then mario moves left
                                           // else r0 is 2, mario dies and loses a life

// ===== mario loses a life ===== //

mov   r0, marioX
mov   r1, marioY
mov   r2, GameState
bl    ReplaceMarioInCurrent                // replace mario in array

bl    loseLife                             // loseLife sequence

b     doneL                                // finish with the move

// ==== mario moves to the left ==== //
contL2: 
  ldr   r1, =MarioPosition      	         // Load address for location of character
  strb   newX, [r1]                        // Update Marios postion

  mov   r0, marioX
  mov   r1, marioY
  mov   r2, GameState
  bl    ReplaceMarioInCurrent               // erase mario on screen and in array

  mov   r0, newX
  mov   r1, marioY
  mov   r2, GameState
  bl    MoveMarioToNewCell                  // draw mario on screen and find position to the right of mario was in array and replace

  // Get object below mario
  add   marioY, marioY, #1                  // position below marios new position
  mov   r2, #24
  mla   currentCell, marioY, r2, newX       // Find position below where mario was in array and replace
  ldrb  r0, [GameState, currentCell]

  doneL:
  .unreq  marioX
  .unreq  marioY
  .unreq  currentCell
  .unreq  newX
  .unreq  marioStartPos
  .unreq  GameState


  pop   {r4-r9,pc}

// ============================================================================================================= //

/* Moves Mario up if he is allowed
 * Args:
 *  none
 * Return:
 *  r0 - object above mario
 */
.globl MoveUp
MoveUp:
  marioX      .req  r4
  marioY      .req r5
  currentCell .req  r6      		// The cell number you are moving from
  newY        .req  r7          	// The cell number to the left of crnt position
  valueOfOldCell .req  r8       	// What is in the cell (ex. wall)
  GameState   .req  r9         	// Holds address of the GameState array

  push        {r4-r9,lr}

  bl    GetCurrentGameState                // gets the address of the current game state array
  mov   GameState, r0                      // save the return value 

  ldr   r1, =MarioPosition      	       // Load address for location of character
  ldrb  marioX, [r1]                     // loading x coord of mario
  ldrb  marioY, [r1, #1]                 // loadking y coord of marioY
  sub   newY, marioY, #1                 // Find x value of cell to the above (int)

  // ==== check if mario can move ==== //
  mov   r2, #24
  mla   currentCell, newY, r2, marioX    // Find position above where mario was in array and replace
  ldrb  r0, [GameState, currentCell]
  mov   r1, #3                           // pass in direction
  mov   r2, currentCell
  bl    CheckMove

  cmp   r0, #0                            // if r0 is 0
  beq   doneU                             // then cant move

  ldr   r1, =MarioPosition      	       // Load address for location of character
  strb  newY, [r1, #1]                   // Update Marios postion

  mov   r0, marioX
  mov   r1, marioY
  mov   r2, GameState
  bl    ReplaceMarioInCurrent              // erase mario on screen and in array

  mov   r0, marioX
  mov   r1, newY
  mov   r2, GameState
  bl    MoveMarioToNewCell                 // draw mario on screen and find position above mario in array and replace

  // Get object above mario
  sub   newY, newY, #1
  mov   r2, #24
  mla   currentCell, newY, r2, marioX    
  ldrb  r0, [GameState, currentCell]


  doneU:
  .unreq  marioX
  .unreq  marioY
  .unreq  currentCell
  .unreq  newY
  .unreq  valueOfOldCell
  .unreq  GameState


  pop   {r4-r9,pc}

// ============================================================================================================= //

/* Moves Mario down if he is allowed
 * Args:
 *  None
 * Return:
 *  r0 - object below mario value
 */
.globl MoveDown
MoveDown:

  marioX      .req    r4
  marioY      .req    r5
  currentCell .req    r6      		        // The cell number you are moving from
  newY        .req    r7          	      // The cell number to the left of crnt position
  GameState   .req    r8          	      // Holds address of the GameState array

  push        {r4-r8,lr}

  bl    GetCurrentGameState                // gets the address of the current game state array
  mov   GameState, r0                      // save the return value 

  ldr   r1, =MarioPosition      	       // Load address for location of character
  ldrb  marioX, [r1]                     // loading x coord of mario
  ldrb  marioY, [r1, #1]                 // loadking y coord of marioY
  add   newY, marioY, #1                 // Find x value of cell to the right (int)

// ==== check if mario fell off the screen and loses a life ==== //
  cmp   newY, #20
  blt   contD

  mov   r0, marioX
  mov   r1, marioY
  mov   r2, GameState
  bl    ReplaceMarioInCurrent                // replace mario in array

  bl    loseLife                             // loseLife sequence

  b     doneD

  // ==== check if mario can move ==== //
  contD:
  mov   r2, #24
  mla   currentCell, newY, r2, marioX                  // Find position below where mario was in array and replace
  ldrb  r0, [GameState, currentCell]
  mov   r1, #4                                         // pass in direction
  mov   r2, currentCell
  bl    CheckMove

  cmp   r0, #0                                         // if r0 is 0
  beq   doneD                                          // then cant move

  ldr   r1, =MarioPosition      	                    // Load address for location of character
  strb  newY, [r1, #1]                                // Update Marios postion
  
  mov   r0, marioX
  mov   r1, marioY
  mov   r2, GameState
  bl    ReplaceMarioInCurrent                   // erase mario on screen and in array
  
  mov   r0, marioX
  mov   r1, newY
  mov   r2, GameState
  bl    MoveMarioToNewCell                     // draw mario on screen and find position below mario in array and replace

  // Get object below mario
  add   newY, newY, #1                                 // position below marios new position
  mov   r2, #24
  mla   currentCell, newY, r2, marioX                  // Find position below where mario was in array and replace
  ldrb  r0, [GameState, currentCell]

  b     doneD

doneD:
.unreq  marioX
.unreq  marioY
.unreq  currentCell
.unreq  newY
.unreq  GameState

  pop   {r4-r8,pc}

// ================================================================================================= //
.globl MoveRU
MoveRU:         // moves diagonally up and right
  marioX      .req     r4
  marioY      .req     r5
  currentCell .req     r6      		       // The cell number you are moving from
  newX        .req     r7
  newY        .req     r8                // The cell number to the left of crnt position
  GameState   .req     r9          	     // Holds address of the GameState array

  push        {r4-r9,lr}

  bl    GetCurrentGameState                // gets the address of the current game state array
  mov   GameState, r0                      // save the return value 

  ldr   r1, =MarioPosition      	       // Load address for location of character
  ldrb  marioX, [r1]                     // loading x coord of mario
  ldrb  marioY, [r1, #1]                 // loadking y coord of marioY
  add   newX, marioX, #1                 // find x value of cell to the right (int)
  sub   newY, marioY, #1                 // Find y value of cell above (int)

  // ==== check if mario can move ==== //
  mov   r2, #24
  mla   currentCell, newY, r2, newX      // Find position above where mario was in array and replace
  ldrb  r0, [GameState, currentCell]
  mov   r1, #3                           // pass in direction
  mov   r2, currentCell
  bl    CheckMove

  cmp   r0, #0                            // if r0 is 0
  beq   doneU                             // then cant move

  ldr   r1, =MarioPosition      	       // Load address for location of character
  strb  newX, [r1]
  strb  newY, [r1, #1]                   // Update Marios postion

  mov   r0, marioX
  mov   r1, marioY
  mov   r2, GameState
  bl    ReplaceMarioInCurrent              // erase mario on screen and in array

  mov   r0, marioX
  mov   r1, newY
  mov   r2, GameState
  bl    MoveMarioToNewCell                 // draw mario on screen and find position above mario in array and replace

  // Get object above mario
  sub   newY, newY, #1
  mov   r2, #24
  mla   currentCell, newY, r2, marioX    // Find position above where mario was in array and replace
  ldrb  r0, [GameState, currentCell]


doneRU:
  .unreq  marioX
  .unreq  marioY
  .unreq  currentCell
  .unreq  newY
  .unreq  newX
  .unreq  GameState


  pop   {r4-r9,pc}

// ================================================================================================= //
.globl MoveRD
MoveRD:// moves diagonally down and right
  marioX      .req     r4
  marioY      .req     r5
  currentCell .req     r6      		       // The cell number you are moving from
  newX        .req     r7
  newY        .req     r8                // The cell number to the left of crnt position
  GameState   .req     r9         	     // Holds address of the GameState array

  push        {r4-r9,lr}

  bl    GetCurrentGameState                // gets the address of the current game state array
  mov   GameState, r0                      // save the return value 

  ldr   r1, =MarioPosition      	       // Load address for location of character
  ldrb  marioX, [r1]                     // loading x coord of mario
  ldrb  marioY, [r1, #1]                 // loadking y coord of marioY
  add   newX, marioX, #1                 // find x value of cell to the right (int)
  add   newY, marioY, #1                 // Find y value of cell above (int)
 
  // ==== check if mario can move ==== //
  mov   r2, #24
  mla   currentCell, newY, r2, newX      // Find position above where mario was in array and replace
  ldrb  r0, [GameState, currentCell]
  mov   r1, #4                           // pass in direction
  mov   r2, currentCell
  bl    CheckMove

  cmp   r0, #0                            // if r0 is 0
  beq   doneU                             // then cant move

  ldr   r1, =MarioPosition      	       // Load address for location of character
  strb  newX, [r1]
  strb  newY, [r1, #1]                   // Update Marios postion

  mov   r0, marioX
  mov   r1, marioY
  mov   r2, GameState
  bl    ReplaceMarioInCurrent              // erase mario on screen and in array

  mov   r0, marioX
  mov   r1, newY
  mov   r2, GameState
  bl    MoveMarioToNewCell                 // draw mario on screen and find position above mario in array and replace

  // Get object below mario
  add   newY, newY, #1                                 // position below marios new position
  mov   r2, #24
  mla   currentCell, newY, r2, marioX                  // Find position below where mario was in array and replace
  ldrb  r0, [GameState, currentCell]

doneRD:
  .unreq  marioX
  .unreq  marioY
  .unreq  currentCell
  .unreq  newY
  .unreq  newX
  .unreq  GameState


    pop   {r4-r9,pc}

// ================================================================================================= //

.globl MoveLU
MoveLU:// moves diagonally down and right
  marioX      .req     r4
  marioY      .req     r5
  currentCell .req     r6      		       // The cell number you are moving from
  newX        .req     r7
  newY        .req     r8                // The cell number to the left of crnt position
  GameState   .req     r9         	   // Holds address of the GameState array

  push        {r4-r9,lr}

  bl    GetCurrentGameState                // gets the address of the current game state array
  mov   GameState, r0                      // save the return value 

  ldr   r1, =MarioPosition      	       // Load address for location of character
  ldrb  marioX, [r1]                     // loading x coord of mario
  ldrb  marioY, [r1, #1]                 // loadking y coord of marioY
  sub   newX, marioX, #1                 // find x value of cell to the right (int)
  sub   newY, marioY, #1                 // Find y value of cell above (int)

  // ==== check if mario can move ==== //
  mov   r2, #24
  mla   currentCell, newY, r2, newX      // Find position above where mario was in array and replace
  ldrb  r0, [GameState, currentCell]
  mov   r1, #4                           // pass in direction
  mov   r2, currentCell
  bl    CheckMove

  cmp   r0, #0                            // if r0 is 0
  beq   doneLU                             // then cant move

  ldr   r1, =MarioPosition      	       // Load address for location of character
  strb  newX, [r1]
  strb  newY, [r1, #1]                   // Update Marios postion

  mov   r2, #24
  mla   currentCell, marioY, r2, marioX   // Mario index in array. currentCell = (y * width) + x

  mov   r2, #9
  strb  r2, [GameState, currentCell]

  mov   r0, marioX
  mov   r1, marioY
  mov   r2, GameState
  bl    ReplaceMarioInCurrent              // erase mario on screen and in array

  mov   r0, marioX
  mov   r1, newY
  mov   r2, GameState
  bl    MoveMarioToNewCell                 // draw mario on screen and find position above mario in array and replace

  // Get object above mario
  sub   newY, newY, #1
  mov   r2, #24
  mla   currentCell, newY, r2, marioX    // Find position above where mario was in array and replace
  ldrb  r0, [GameState, currentCell]

doneLU:
  .unreq  marioX
  .unreq  marioY
  .unreq  currentCell
  .unreq  newY
  .unreq  valueOfOldCell
  .unreq  newX
  .unreq  GameState


    pop   {r4-r9,pc}


    // ================================================================================================= //

    .globl MoveLD
    MoveLD:// moves diagonally down and right
      marioX      .req     r4
      marioY      .req     r5
      currentCell .req     r6      		       // The cell number you are moving from
      newX        .req     r7
      newY        .req     r8                // The cell number to the left of crnt position     	    
      GameState   .req     r9         	   // Holds address of the GameState array

      push        {r4-r9,lr}

      bl    GetCurrentGameState                // gets the address of the current game state array
      mov   GameState, r0                      // save the return value 

      ldr   r1, =MarioPosition      	       // Load address for location of character
      ldrb  marioX, [r1]                     // loading x coord of mario
      ldrb  marioY, [r1, #1]                 // loadking y coord of marioY
      sub   newX, marioX, #1                 // find x value of cell to the right (int)
      add   newY, marioY, #1                 // Find y value of cell above (int)

      // ==== check if mario can move ==== //
      mov   r2, #24
      mla   currentCell, newY, r2, newX      // Find position above where mario was in array and replace
      ldrb  r0, [GameState, currentCell]
      mov   r1, #4                           // pass in direction
      mov   r2, currentCell
      bl    CheckMove

      cmp   r0, #0                            // if r0 is 0
      beq   doneLD                             // then cant move

      ldr   r1, =MarioPosition      	       // Load address for location of character
      strb  newX, [r1]
      strb  newY, [r1, #1]                   // Update Marios postion

        
      mov   r0, marioX
      mov   r1, marioY
      mov   r2, GameState
      bl    ReplaceMarioInCurrent              // erase mario on screen and in array

      mov   r0, marioX
      mov   r1, newY
      mov   r2, GameState
      bl    MoveMarioToNewCell                 // draw mario on screen and find position above mario in array and replace

      // Get object below mario
      add   newY, newY, #1                                 // position below marios new position
      mov   r2, #24
      mla   currentCell, newY, r2, marioX                  // Find position below where mario was in array and replace
      ldrb  r0, [GameState, currentCell]

      doneLD:
      .unreq  marioX
      .unreq  marioY
      .unreq  currentCell
      .unreq  newY
      .unreq  newX
      .unreq  GameState


        pop   {r4-r9,pc}

    // ================================================================================================= //
.globl DownPressed
DownPressed:
  marioX      .req    r4
  marioY      .req    r5
  currentCell .req    r6                  // The cell number you are moving from
  newY        .req    r7                  // The cell number to the left of crnt position
  valueOfOldCell .req r8                  // What is in the cell (ex. wall)
  GameState   .req    r9                  // Holds address of the GameState array

  push        {r4-r9,lr}

  bl    GetCurrentGameState                // gets the address of the current game state array
  mov   GameState, r0                      // save the return value 

  ldr   r1, =MarioPosition               // Load address for location of character
  ldrb  marioX, [r1]                     // loading x coord of mario
  ldrb  marioY, [r1, #1]                 // loadking y coord of marioY
  add   newY, marioY, #1                 // Find x value of cell to the right (int)

 // ==== check if mario is standing on a pipe ==== //
  mov   r2, #24
  mla   currentCell, newY, r2, marioX    // Find position below where mario was in array and replace 
  ldrb  r0, [GameState, currentCell]     // get cell value
  
  cmp   r0, #5                           // if cell value != 5...
  bne   doneDP                           // dont move

  mov     r0, marioX
  mov     r1, marioY
  mov     r2, GameState
  bl      ReplaceMarioInCurrent            // delete mario on screen and replace his array value with an empty cell
    
  mov     r0, #1                           // starting x coord
  mov     r1, #1                           // starting y coord
  mov     r2, #2                           // stage we are moving to 
  bl      SetupNextStage                   // set global variables and draw new stage

  doneDP:
  .unreq  marioX
  .unreq  marioY
  .unreq  currentCell
  .unreq  newY
  .unreq  valueOfOldCell
  .unreq  GameState

  pop   {r4-r9,pc}

    // ================================================================================================= //

/* Checks if mario can move
* directions: 0 - none; 1 - right; 2 - left; 3 - up; 4 - down; 5 - downpress
* Args:
* r0 - object
* r1 - direction
* r2 - stage number
*Return:
* r0: 0 - no move; 1 - can move; 2 - lose life
*/
.globl CheckMove
CheckMove:
    object      .req r0
    direction   .req r1
    stage       .req r2

    push {lr}

    cmp object, #1        // GroundBrick - can never break
    beq NoMove            // cant move

    cmp object, #2        // WallBlock - can break only when moving up and Mario is big
    beq WallBlockMove

    cmp object, #4        // QuestionBlock - trigger when moving up
    beq QuestionBlockMove

    cmp object, #5        // PipeUp - trigger when press down
    beq PipUpMove

    cmp object, #6        // Coin - move and collect
    beq CoinMove

    cmp object, #7        // Goomba - kill when moving down; die otherwise
    beq GoombaMove

    cmp object, #8        // Koopa - kill, move back beside it, shell remains in cell; die otherwise
    beq KoopaMove

    cmp object, #10       // empty coin block - can't move
    beq NoMove

    cmp object, #9        // empty - always move
    mov r0, #1            // return value saying mario can move

    b   doneMove

WallBlockMove:
    cmp direction, #3     // see if mario is moving up
    b NoMove              // if not moving up then dont move
    mov r0, #1            // else he can break the block
    b   doneMove

QuestionBlockMove:
    cmp direction, #3     // check if mario is moving up
    bne NoMove            // if not then dont move

PipUpMove:
    cmp direction, #5     // check if down was pressed
    bne NoMove
    mov r0, #1
    b   doneMove

CoinMove:
    bl  ScoreEvent        // collect and increment score
    mov r0, #1            // move to coin space
    b   doneMove

GoombaMove:
    cmp     direction, #4
    movne   r0, #2        // return lose life
    moveq   r0, #1        // return move

    b   doneMove

KoopaMove:



NoMove:
    mov r0, #0

doneMove:
    .unreq object
    .unreq direction
    .unreq stage

    pop {pc}


// ===================== animations for in game events =================== //

.globl GoombaKill
GoombaKill:
  marioX      .req  r4
  marioY      .req  r5
  currentCell .req  r6      		// The cell number you are moving from
  newY        .req  r7          	// The cell number to the left of crnt position
  GameState   .req  r8          	// Holds address of the GameState array

  push {r4-r8, lr}

  bl    GetCurrentGameState                // gets the address of the current game state array
  mov   GameState, r0                      // save the return value 

  ldr   r1, =MarioPosition      	       // Load address for location of character
  ldrb  marioX, [r1]                     // loading x coord of mario
  ldrb  marioY, [r1, #1]                 // loadking y coord of marioY
  add   newY, marioY, #1                 // Find x value of cell to the right (int)

  mov     r0, marioX
  mov     r1, newY
  mov     r2, GameState
  bl      ReplaceMarioInCurrent            // delete mario on screen and replace his array value with an empty cell

  .unreq  marioX
  .unreq  marioY
  .unreq  currentCell
  .unreq  newY
  .unreq  GameState

pop   {r4-r8,pc}


.globl BlockBreak
BlockBreak:
  marioX      .req  r4
  marioY      .req  r5
  currentCell .req  r6      		// The cell number you are moving from
  newY        .req  r7          	// The cell number to the left of crnt position
  GameState   .req  r8          	// Holds address of the GameState array

  push {r4-r10, lr}

  bl    GetCurrentGameState                // gets the address of the current game state array
  mov   GameState, r0                      // save the return value 

  ldr   r1, =MarioPosition      	       // Load address for location of character
  ldrb  marioX, [r1]                     // loading x coord of mario
  ldrb  marioY, [r1, #1]                 // loadking y coord of marioY
  sub   newY, marioY, #1                 // Find y value of cell above mario (int)

  mov     r0, marioX
  mov     r1, newY
  mov     r2, GameState
  bl      ReplaceMarioInCurrent            // delete mario on screen and replace his array value with an empty cell

  .unreq  marioX
  .unreq  marioY
  .unreq  currentCell
  .unreq  newY
  .unreq  GameState

  pop   {r4-r8,pc}


.globl UpdateCoinBlock
UpdateCoinBlock:
  push    {r4-r9, lr}

  marioX      .req  r4
  marioY      .req  r5
  currentCell .req  r6      		         // The cell number you are moving from
  newY        .req  r7          	       // The cell number to the left of crnt position
  coinCount   .req  r8       	       // What is in the cell (ex. wall)
  GameState   .req  r9          	       // Holds address of the GameState array

  
  bl    GetCurrentGameState                // gets the address of the current game state array
  mov   GameState, r0                      // save the return value 

  ldr   r1, =MarioPosition      	       // Load address for location of character
  ldrb  marioX, [r1]                     // loading x coord of mario
  ldrb  marioY, [r1, #1]                 // loadking y coord of marioY
  sub   newY, marioY, #1                 // Find y value of cell above mario (int)

  ldr r3, =CoinBlockCounter              // get counter value
  ldrb coinCount, [r3]
  sub coinCount, #1                             // decrement counter

  cmp coinCount, #0                             // if counter not at 0
  bne drawCoin                           // draw coin animation

  //    Find position above of where mario was in array and replace with empty cell
  mov   r2, #24
  mla   currentCell, newY, r2, marioX                 // Calculate index in array. currentCell = (y * width) + x

  mov   r0, #10
  strb  r0, [GameState, currentCell]                  // store empty cell into new position in array

  // fill in new location
  ldr   r2, =EmptyBlock                                    // move the object address into r2
  mov   r0, marioX
  mov   r1, newY
  bl    DrawObject

  mov   r0, #10                           // return #10 (empty block to the jump)

  b     doneCoinblk

drawCoin:                                 // draws a coin above the coin block, waits, then deletes it - coin block hit animation
  strb   coinCount, [r3]                    // store new counter value

  sub     newY, newY, #1
  ldr     r2, =Coin
  mov     r0, marioX
  mov     r1, newY
  bl      DrawObject

  mov   r0, #1
  lsl   r0, #15
  bl    wait

  ldr     r2, =Empty
  mov     r0, marioX
  mov     r1, newY
  bl      DrawObject

doneCoinblk:
    .unreq  marioX
    .unreq  marioY
    .unreq  currentCell
    .unreq  newY
    .unreq  coincount
    .unreq  GameState

  pop     {r4-r9, pc}



// ===================== trying to make the move methods more modular ====================== //

/*
* This method checks which game state mario is currently in and returns the gamestate address
* Args:
*   None
* Return:
*   r0 - address of current game state
*/
.globl GetCurrentGameState
GetCurrentGameState:
  push {lr}

  ldr   r3, =CurrentGameState
  ldrb  r3, [r3]                // get the value for which game state we are in
  cmp   r3, #2                      //check which game state we are in and updates the correct one
  ldrlt r0, =GameState1Copy         // Load the address of the Game State 1 array
  ldreq r0, =GameState2Copy         // Load the address of the Game State 2 array
  ldrgt r0, =GameState3Copy         // Load the address of the Game State 3 array

    pop {pc}


/*
* Draws an empty cell at mario''s current position on screen and replaces mario with empty cell value in the array
* Args:
*   r0 - mario X coord
*   r1 - mario Y coord
*   r2 - gamestate address
* Return:
*   None
*/
.globl ReplaceMarioInCurrent
 ReplaceMarioInCurrent:
  marioX    .req  r4
  marioY    .req    r5
  gamestate   .req    r6
  arrayPos    .req    r7

  push  {r4-r7, lr}
  
  mov   marioX, r0
  mov   marioY, r1
  mov   gamestate, r2

  ldr   r2, =Emtpy            // erases mario on screen 
  bl    DrawObject

  mov   r2, #24
    mla   arrayPos, marioY, r2, marioX      // Mario position in array

  mov   r2, #9              // value of empty to store into array
  strb  r2, [gamestate, arrayPos]     // replace mario position in array with an empty cell 

  .unreq  mariox
  .unreq  marioY
  .unreq  gamestate
  .unreq  arrayPos

  pop   {r4-r7, pc}


/*
* Draws mario in his new position on screen and updates mario''s position in the array
* Args:
*   r0 - mario X coord
*   r1 - mario Y coord
*   r2 - gamestate
* Return:
*   None
*/
.globl MoveMarioToNewCell
MoveMarioToNewCell:
  marioX    .req  r4
  marioY    .req    r5
  gamestate   .req    r6
  arrayPos    .req    r7

  push  {r4-r7, lr}
  
  mov   marioX, r0
  mov   marioY, r1
  mov   gamestate, r2

  ldr   r2, =Mario
  bl    DrawObject              // draw mario on screen in new position

  mov   r2, #24
    mla   arrayPos, marioY, r2, marioX        // Mario position in array

  mov   r2, #0                // value for mario in array
  strb  r2, [gamestate, arrayPos]       // store mario in his new position

  .unreq  mariox
  .unreq  marioY
  .unreq  gamestate
  .unreq  arrayPos

  pop   {r4-r7, pc}


/*
* Resets mario global position and changes the global gamestate value and draws the next stage
* Args:
*   r0 - new mario x coord
* r1 - new mario y coord
* r2 - new gamestate value 
* Return:
*   None
*/
.globl SetupNextStage
SetupNextStage:
  x       .req r4
  y       .req r5
  GSValue   .req r6

  push  {r4-r6, lr}

  mov   x, r0
  mov   y, r1
  mov   GSValue, r2

  ldr   r3, =CurrentGameState       // updating the game state value
  strb  GSValue, [r3]         // storing the new value

  ldr   r3, =MarioPosition        // updating Mario global coordinates
  strb  x, [r3]             // store new x value
  strb  r2, [r3, #1]          // store new y value

  bl    clearScreen           // clear the game screen
  
  bl    GetCurrentGameState       // gets the address of the new game state to draw

  bl    DrawGameScreen          // draws the new game stage
  bl    drawScoreBoard          // draws the scoreboard 
  
  .unreq  x
  .unreq  y
  .unreq  gamestate

  pop   {r4-r6, pc}



/*
* when mario loses a loseLife reset his position to the start of the stage, change the life count, and reload the stage
* Args:
*   None
* Return:
*   None
*/
.globl loseLife
loseLife:
    gameStateAddr     .req r4
    gameStateVal    .req r5

    push  {r4-r10,lr}

    bl    lostLife              // calculate the lost life

    bl      GetCurrentGameState
    mov     gameStateAddr, r0         // save the game state address

    ldr   r3, =CurrentGameState
    ldrb  gameStateVal, [r3]          // get value of current game state

  // reset mario global coordinates
    cmp   gameStateVal, #1        // check which game state we are in
    moveq   r0, #1              // if in GS 1 then mario starts at x coord = 1
    movne   r0, #0              // else mario starts at x coord = 0
    
    mov     r1, #17                           // new mario y pos
    ldr     r3, =MarioPosition
    strb    r0, [r3]                          // store x coord
    strb    r1, [r3, #1]                      // store y coord

    bl clearScreen

    mov   r0, gameStateAddr         // address of game state to redraw
    bl    DrawGameScreen
    bl    drawScoreBoard

    pop   {r4-r10, pc}
