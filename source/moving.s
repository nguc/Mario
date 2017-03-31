/*
* Calculates and draws mario "moving"
*/
.section .data
.align 2

.globl MarioPosition
MarioPosition: .byte  1, 17        	// Starting x and y coord of Mario - will change when mario moves

.globl OldCellObject
OldCellObject:	.byte 9     // Save value in cell that mario will move to so we can redraw when mario moves away

.globl CurrentGameState
CurrentGameState:	.byte 1 				// keeps track of which game screen we are in

.globl CoinBlockCounter
CoinBlockCounter: .byte 5

.section .text



/* Moves Mario right if he is allowed
 * Args:
 *  none
 * Return:
 *  none
 */
.globl MoveRight
MoveRight:

  marioX      .req  r4
  marioY      .req r5
  currentCell .req  r6      		// The cell number you are moving from
  newX        .req  r7          	// The cell number to the left of crnt position
  marioStartPos .req  r8       	// What is in the cell (ex. wall)
  oldCellValue .req r9
  GameState   .req  r10          	// Holds address of the GameState array

  push        {r4-r10,lr}

<<<<<<< HEAD
=======
/*  mov   r2, #1
  ldr   r3, =MoveDirection
  strb  r2, [r3]                           // store the direction
*/
>>>>>>> origin/master
  ldr   r3, =CurrentGameState
  ldrb  r3, [r3]        			             // get the value for which game state we are in
  cmp 	r3, #2                             //check which game state we are in and updates the correct one
  ldrlt GameState, =GameState1Copy         // Load the address of the Game State 1 array
  ldreq GameState, =GameState2Copy         // Load the address of the Game State 2 array
  ldrgt GameState, =GameState3Copy         // Load the address of the Game State 3 array
<<<<<<< HEAD

  ldr   r1, =MarioPosition      	         // Load address for location of character
  ldrb  marioX, [r1]                       // loading x coord of mario
  ldrb  marioY, [r1, #1]                   // loadking y coord of marioY
  add   newX, marioX, #1                   // Find x value of cell to the right (int)

  /*
   * Check if mario is going to the next stage
  */
  cmp    newX, #24                         //check if mario is going to move off screen
  blt    contR                             // if still in screen continue check if he can move

  mov  r2, #9   	                        // value for cell to replace mario (empty)
  strb  r2, [GameState, currentCell]      // replace cell where mario is moving away from in array

  // draw in cell mario is currently in
  mov   r0, #9            // mov valueOfOldCell into r0 to be passed as an arg
  bl    CheckObject1                  // check what the object is
  mov   r2, r0                        // move the object address into r2
  mov   r0, marioX
  mov   r1, marioY
  bl    DrawObject

  // replace mario in array with empty cell
  mov   r2, #24
  mla   currentCell, marioY, r2, marioX    // Mario position in array
  mov   r2, #9
  strb  r2, [GameState, currentCell]

  mov   r2, #3                             // new game state value
  ldr   r3, =CurrentGameState
  strb  r2, [r3]                           // save change to game state

  mov   r0, #1                             // new mario x pos
  mov   r1, #17                            // new mario y pos
  ldr   r3, =MarioPosition
  strb  r0, [r3]                           // store x coord
  strb  r1, [r3, #1]                       // store y coord

  bl    clearScreen                       // clear the screen

  ldr   r0, =GameState3Copy
  bl    DrawGameScreen
  bl    drawScoreBoard

  mov   r0, #9                             // empty block value
  ldr   r3, =OldCellObject
  strb  r0, [r3]                           // reset the fill value to empty cell


  b     doneR


contR:
  mov   r2, #24
=======

  ldr   r1, =MarioPosition      	         // Load address for location of character
  ldrb  marioX, [r1]                       // loading x coord of mario
  ldrb  marioY, [r1, #1]                   // loadking y coord of marioY
  add   newX, marioX, #1                   // Find x value of cell to the right (int)


  /*
   * Check if mario is going to the next stage
  */
  cmp    newX, #24                         //check if mario is going to move off screen
  blt    contR                             // if still in screen continue check if he can move 

  mov   r2, #3                             // new game state value
  ldr   r3, =CurrentGameState
  strb  r2, [r3]                           // save change to game state

  mov   r0, #1                             // new mario x pos
  mov   r1, #17                            // new mario y pos
  ldr   r3, =MarioPosition
  strb  r0, [r3]                           // store x coord
  strb  r1, [r3, #1]                       // store y coord

  mov   r0, #9                             // empty block value
  ldr   r3, =OldCellObject
  strb  r0, [r3]                           // reset the fill value to empty cell

  ldr   r0, =GameState3
  bl    DrawGameScreen

  b     doneR


contR:
  mov   r2, #24
>>>>>>> origin/master
  mla   currentCell, marioY, r2, newX      // check if move valid by checking object to the right of mario. currentCell = (y * width) + Newx
  ldrb  r0, [GameState, currentCell]
  mov   r1, #1                             // pass in direction
  mov   r2, currentCell
  bl    CheckMove

  cmp   r0, #0                             // if r0 is 0
  beq   doneR                              // then cant move
<<<<<<< HEAD
  cmp   r0, #2                             // check if mario loses life
  bne   contR2                             // if not, then move right

=======

  // Go here if able to move
  ldr   r1, =MarioPosition      	         // Load address for location of character
  strb   newX, [r1]                        // Update Mario postion
>>>>>>> origin/master

// ===== set up mario losing a loseLife ===== //


  // replace mario current position with empty cell in the array
  mov   r2, #24
<<<<<<< HEAD
  mla   marioStartPos, marioY, r2, marioX    // Mario current position in array
  mov   r2, #9
  strb  r2, [GameState, currentCell]
=======
  mla   currentCell, marioY, r2, marioX    // Mario position in array. currentCell = (y * width) + x
>>>>>>> origin/master

  // put mario in his starting position in array
  mov   r2, #24
  mov   marioX, #0
  mov   marioY, #17
  mla   marioStartPos, marioY, r2, marioX
  mov   r2, #0
  strb  r2, [GameState, marioStartPos]

  mov   r0, marioStartPos
  mov   r1, currentCell
  mov   r3, GameState                      // pass in game state as arg
  bl    loseLife                           // else do the loseLife sequence

  b     doneR                              // finish with the move


contR2:
  // if able to move...
  ldr   r1, =MarioPosition      	         // Load address for location of character
  strb   newX, [r1]                        // Update Mario postion

  mov   r2, #24
  mla   currentCell, marioY, r2, marioX    // Mario position in array. currentCell = (y * width) + x

  mov   r2, #9
  strb  r2, [GameState, currentCell]

  ldr    r2, =Empty
  mov   r0, marioX
  mov   r1, marioY
  bl    DrawObject

  //    Find position to the right of where mario was in array and replace
  mov   r2, #24
  mla   currentCell, marioY, r2, newX                 // Calculate index in array. currentCell = (y * width) + x

  mov   r0, #0
  strb  r0, [GameState, currentCell]                  // store Mario into new position in array

  // draw mario in new location
  bl    CheckObject1
  mov   r2, r0                        // move the object address into r2
  mov   r0, newX
  mov   r1, marioY
  bl    DrawObject

  // Get object below mario
  add   marioY, marioY, #1                                 // position below marios new position
  mov   r2, #24
  mla   currentCell, marioY, r2, newX                  // Find position below where mario was in array and replace
  ldrb  r0, [GameState, currentCell]

doneR:
  .unreq  marioX
  .unreq  marioY
  .unreq  currentCell
  .unreq  newX
  .unreq  marioStartPos
  .unreq  oldCellValue
  .unreq  GameState

  pop   {r4-r10,pc}

// ============================================================================================================= //

/* Moves Mario left if he is allowed
 * Args:
 *  none
 * Return:
 *  none
 */
.globl MoveLeft
MoveLeft:

marioX      .req  r4
marioY      .req r5
currentCell .req  r6      		// The cell number you are moving from
newX        .req  r7          	// The cell number to the left of crnt position
marioStartPos .req  r8       	// What is in the cell (ex. wall)
oldCellValue .req r9
GameState   .req  r10          	// Holds address of the GameState array

push        {r4-r10,lr}

ldr   r3, =CurrentGameState
ldrb  r3, [r3]        			           // get the value for which game state we are in
cmp 	r3, #2                           //check which game state we are in and updates the correct one
ldrlt GameState, =GameState1Copy       // Load the address of the Game State 1 array
ldreq GameState, =GameState2Copy       // Load the address of the Game State 2 array
ldrgt GameState, =GameState3Copy       // Load the address of the Game State 3 array

ldr   r1, =MarioPosition      	       // Load address for location of character
ldrb  marioX, [r1]                     // loading x coord of mario
ldrb  marioY, [r1, #1]                 // loadking y coord of marioY
subs   newX, marioX, #1                 // Find x value of cell to the right (int)

/*
* check if mario is moving to the far left edge
*/
cmp    newX, #0                         //check if mario is going to move off screen
bge    contL                             // if still in screen continue check if he can move

mov   r2, #1                             // new game state value
ldr   r3, =CurrentGameState
strb  r2, [r3]                           // save change to game state

mov   r0, #19                            // new mario x pos
mov   r1, #17                            // new mario y pos
ldr   r3, =MarioPosition
strb  r0, [r3]                           // store x coord
strb  r1, [r3, #1]                       // store y coord

bl    clearScreen                       // clear the screen

ldr   r0, =GameState1Copy
bl    DrawGameScreen
bl    drawScoreBoard

mov   r0, #9                             // empty block value
ldr   r3, =OldCellObject
strb  r0, [r3]                           // reset the fill value to empty cell

b     doneL

contL:

// checking if move is valid by checking object to the right of mario
mov   r2, #24
mla   currentCell, marioY, r2, newX     // Calculate cell to the right of mario. currentCell = (y * width) + Newx
ldrb  r0, [GameState, currentCell]
mov   r1, #2                            // pass in direction
mov   r2, currentCell
bl    CheckMove

cmp   r0, #0                            // if r0 is 0
beq   doneL                             // then cant move
cmp   r0, #2                             // check if mario loses life
bne   contL2                             // if not, then move right

//=============================//

// replace mario current position with empty cell in the array
mov   r2, #24
mla   marioStartPos, marioY, r2, marioX    // Mario current position in array
mov   r2, #9
strb  r2, [GameState, currentCell]

// put mario in his starting position in array
mov   r2, #24
mov   marioX, #0
mov   marioY, #17
mla   marioStartPos, marioY, r2, marioX
mov   r2, #0
strb  r2, [GameState, marioStartPos]

mov   r0, marioStartPos
mov   r1, currentCell
mov   r3, GameState                      // pass in game state as arg
bl    loseLife                           // else do the loseLife sequence

b     doneL                              // finish with the move


contL2:
// Go here if able to move
ldr   r1, =MarioPosition      	       // Load address for location of character
strb   newX, [r1]                      // Update Marios postion

mov   r2, #24
mla   currentCell, marioY, r2, marioX   // Calculate index in array. currentCell = (y * width) + x

mov   r2, #9
strb  r2, [GameState, currentCell]

ldr    r2, =Empty
mov   r0, marioX
mov   r1, marioY
bl    DrawObject

//    Find position to the right of where mario was in array and replace
mov   r2, #24
mla   currentCell, marioY, r2, newX                 // Calculate index in array. currentCell = (y * width) + x


mov   r0, #0
strb  r0, [GameState, currentCell]                  // store Mario into new position in array

// draw mario in new location
bl    CheckObject1
mov   r2, r0                        // move the object address into r2
mov   r0, newX
mov   r1, marioY
bl    DrawObject

// Get object below mario
add   marioY, marioY, #1                                 // position below marios new position
mov   r2, #24
mla   currentCell, marioY, r2, newX                  // Find position below where mario was in array and replace
ldrb  r0, [GameState, currentCell]

doneL:
.unreq  marioX
.unreq  marioY
.unreq  currentCell
.unreq  newX
.unreq  marioStartPos
.unreq  oldCellValue
.unreq  GameState


pop   {r4-r10,pc}

// ============================================================================================================= //

/* Moves Mario up if he is allowed
 * Args:
 *  none
 * Return:
 *  none
 */
.globl MoveUp
MoveUp:
marioX      .req  r4
marioY      .req r5
currentCell .req  r6      		// The cell number you are moving from
newY        .req  r7          	// The cell number to the left of crnt position
valueOfOldCell .req  r8       	// What is in the cell (ex. wall)
oldCellValue .req r9
GameState   .req  r10          	// Holds address of the GameState array

push        {r4-r10,lr}

ldr   r3, =CurrentGameState
ldrb  r3, [r3]        			           // get the value for which game state we are in
cmp 	r3, #2                           //check which game state we are in and updates the correct one
ldrlt GameState, =GameState1Copy       // Load the address of the Game State 1 array
ldreq GameState, =GameState2Copy       // Load the address of the Game State 2 array
ldrgt GameState, =GameState3Copy       // Load the address of the Game State 3 array

ldr   r1, =MarioPosition      	       // Load address for location of character
ldrb  marioX, [r1]                     // loading x coord of mario
ldrb  marioY, [r1, #1]                 // loadking y coord of marioY
sub   newY, marioY, #1                 // Find x value of cell to the above (int)

mov   r2, #24
mla   currentCell, newY, r2, marioX    // Find position above where mario was in array and replace
ldrb  r0, [GameState, currentCell]
mov   r1, #3                           // pass in direction
mov   r2, currentCell
bl    CheckMove

cmp   r0, #0                            // if r0 is 0
beq   doneU                             // then cant move

// Go here if able to move
ldr   r1, =MarioPosition      	       // Load address for location of character
strb  newY, [r1, #1]                   // Update Marios postion

mov   r2, #24
mla   currentCell, marioY, r2, marioX   // Mario index in array. currentCell = (y * width) + x

// update array and draw cell in with an empty cell at mario current location
mov   r2, #9
strb  r2, [GameState, currentCell]

ldr    r2, =Empty
mov   r0, marioX                    // mario current x coord
mov   r1, marioY                    // mario current y coord
bl    DrawObject

//    Find position above where mario was in array and replace
mov   r2, #24
mla   currentCell, newY, r2, marioX                 // Calculate index in array. currentCell = (y * width) + x

mov   r0, #0
strb  r0, [GameState, currentCell]  // store Mario into new position in array

// draw mario in new location
bl    CheckObject1
mov   r2, r0                        // move the object address into r2
mov   r0, marioX
mov   r1, newY
bl    DrawObject

// Get object above mario
sub   newY, newY, #1
mov   r2, #24
mla   currentCell, newY, r2, marioX    // Find position above where mario was in array and replace
ldrb  r0, [GameState, currentCell]


doneU:
.unreq  marioX
.unreq  marioY
.unreq  currentCell
.unreq  newY
.unreq  valueOfOldCell
.unreq  oldCellValue
.unreq  GameState


  pop   {r4-r10,pc}

// ============================================================================================================= //

/* Moves Mario down if he is allowed
 * * 0 - none; 1 - right; 2 - left; 3 - up; 4 - down
 * Args:
 *  r0 - button pushed or not
 * Return:
 *  r0 - object below mario value
 */
.globl MoveDown
MoveDown:

  marioX      .req    r4
  marioY      .req    r5
  currentCell .req    r6      		        // The cell number you are moving from
  newY        .req    r7          	      // The cell number to the left of crnt position
  marioStartPos .req r8       	          // What is in the cell (ex. wall)
  GameState   .req    r9          	      // Holds address of the GameState array

  push        {r4-r9,lr}


  ldr   r3, =CurrentGameState
  ldrb  r3, [r3]        			           // get the value for which game state we are in
  cmp 	r3, #2                           //check which game state we are in and updates the correct one
  ldrlt GameState, =GameState1Copy       // Load the address of the Game State 1 array
  ldreq GameState, =GameState2Copy       // Load the address of the Game State 2 array
  ldrgt GameState, =GameState3Copy       // Load the address of the Game State 3 array

  ldr   r1, =MarioPosition      	       // Load address for location of character
  ldrb  marioX, [r1]                     // loading x coord of mario
  ldrb  marioY, [r1, #1]                 // loadking y coord of marioY
  add   newY, marioY, #1                 // Find x value of cell to the right (int)



  cmp   newY, #20
  blt   contD2
  // replace mario current position with empty cell in the array
  mov   r2, #24
  mla   marioStartPos, marioY, r2, marioX    // Mario current position in array
  mov   r2, #9
  strb  r2, [GameState, currentCell]

  // put mario in his starting position in array
  mov   r2, #24
  mov   marioX, #0
  mov   marioY, #17
  mla   marioStartPos, marioY, r2, marioX
  mov   r2, #0
  strb  r2, [GameState, marioStartPos]

  mov   r0, marioStartPos
  mov   r1, currentCell
  mov   r3, GameState                      // pass in game state as arg
  bl     loseLife
  b     doneD

  contD2:
  mov   r2, #24
  mla   currentCell, newY, r2, marioX                  // Find position below where mario was in array and replace
<<<<<<< HEAD

=======
  
>>>>>>> origin/master
  ldrb  r0, [GameState, currentCell]
  mov   r1, #4                                         // pass in direction
  mov   r2, currentCell
  bl    CheckMove

  cmp   r0, #0                                         // if r0 is 0
  beq   doneD                                          // then cant move

  // Go here if able to move
  ldr   r1, =MarioPosition      	                    // Load address for location of character
  strb  newY, [r1, #1]                                // Update Marios postion

  mov   r2, #24
  mla   currentCell, marioY, r2, marioX               // Calculate index in array. currentCell = (y * width) + x

  mov   r2, #9
  strb  r2, [GameState, currentCell]

ldr    r2, =Empty
  mov   r0, marioX
  mov   r1, marioY
  bl    DrawObject

  //    Find position below of where mario was in array and replace
  mov   r2, #24
  mla   currentCell, newY, r2, marioX                 // Calculate index in array. currentCell = (y * width) + x

  mov   r0, #0
  strb  r0, [GameState, currentCell]                  // store Mario into new position in array

  // draw mario in new location
  ldr   r2, =Mario                                        // move the object address into r2
  mov   r0, marioX
  mov   r1, newY
  bl    DrawObject

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
.unreq  marioStartPos
.unreq  GameState

<<<<<<< HEAD
=======


>>>>>>> origin/master
  pop   {r4-r9,pc}

// ================================================================================================= //
.globl MoveRU
MoveRU:         // moves diagonally up and right
marioX      .req     r4
marioY      .req     r5
currentCell .req     r6      		       // The cell number you are moving from
newX        .req     r7
newY        .req     r8                // The cell number to the left of crnt position
valueOfOldCell .req  r9       	       // What is in the cell (ex. wall)
GameState   .req     r10          	   // Holds address of the GameState array

push        {r4-r10,lr}

ldr   r3, =CurrentGameState
ldrb  r3, [r3]        			           // get the value for which game state we are in
cmp 	r3, #2                           //check which game state we are in and updates the correct one
ldrlt GameState, =GameState1Copy       // Load the address of the Game State 1 array
ldreq GameState, =GameState2Copy       // Load the address of the Game State 2 array
ldrgt GameState, =GameState3Copy       // Load the address of the Game State 3 array

ldr   r1, =MarioPosition      	       // Load address for location of character
ldrb  marioX, [r1]                     // loading x coord of mario
ldrb  marioY, [r1, #1]                 // loadking y coord of marioY
add   newX, marioX, #1                 // find x value of cell to the right (int)
sub   newY, marioY, #1                 // Find y value of cell above (int)


mov   r2, #24
mla   currentCell, newY, r2, newX    // Find position above where mario was in array and replace
ldrb  r0, [GameState, currentCell]
mov   r1, #3                           // pass in direction
mov   r2, currentCell
bl    CheckMove

cmp   r0, #0                            // if r0 is 0
beq   doneU                             // then cant move

// Go here if able to move
ldr   r1, =MarioPosition      	       // Load address for location of character
strb  newX, [r1]
strb  newY, [r1, #1]                   // Update Marios postion

mov   r2, #24
mla   currentCell, marioY, r2, marioX  // Mario index in array. currentCell = (y * width) + x

mov   r2, #9
strb  r2, [GameState, currentCell]

ldr    r2, =Empty
mov   r0, marioX                    // mario current x coord
mov   r1, marioY                    // mario current y coord
bl    DrawObject


mov   r2, #24
mla   currentCell, newY, r2, newX    // Find position above and to the right where mario was in array and replace

mov   r0, #0
strb  r0, [GameState, currentCell]  // store Mario into new position in array

// draw mario in new location
bl    CheckObject1
mov   r2, r0                        // move the object address into r2
mov   r0, newX
mov   r1, newY
bl    DrawObject

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
.unreq  valueOfOldCell
.unreq  newX
.unreq  GameState


  pop   {r4-r10,pc}

// ================================================================================================= //
.globl MoveRD
MoveRD:// moves diagonally down and right
  marioX      .req     r4
  marioY      .req     r5
  currentCell .req     r6      		       // The cell number you are moving from
  newX        .req     r7
  newY        .req     r8                // The cell number to the left of crnt position
  valueOfOldCell .req  r9       	       // What is in the cell (ex. wall)
  GameState   .req     r10          	   // Holds address of the GameState array

  push        {r4-r10,lr}

  ldr   r3, =CurrentGameState
  ldrb  r3, [r3]        			           // get the value for which game state we are in
  cmp 	r3, #2                           //check which game state we are in and updates the correct one
  ldrlt GameState, =GameState1Copy       // Load the address of the Game State 1 array
  ldreq GameState, =GameState2Copy       // Load the address of the Game State 2 array
  ldrgt GameState, =GameState3Copy       // Load the address of the Game State 3 array

  ldr   r1, =MarioPosition      	       // Load address for location of character
  ldrb  marioX, [r1]                     // loading x coord of mario
  ldrb  marioY, [r1, #1]                 // loadking y coord of marioY
  add   newX, marioX, #1                 // find x value of cell to the right (int)
  add   newY, marioY, #1                 // Find y value of cell above (int)

  mov   r2, #24
  mla   currentCell, newY, r2, newX      // Find position above where mario was in array and replace
  ldrb  r0, [GameState, currentCell]

  mov   r1, #4                           // pass in direction
  mov   r2, currentCell
  bl    CheckMove

  cmp   r0, #0                            // if r0 is 0
  beq   doneU                             // then cant move

  // Go here if able to move
  ldr   r1, =MarioPosition      	       // Load address for location of character
  strb  newX, [r1]
  strb  newY, [r1, #1]                   // Update Marios postion

  mov   r2, #24
  mla   currentCell, marioY, r2, marioX   // Mario index in array. currentCell = (y * width) + x

  mov   r2, #9
  strb  r2, [GameState, currentCell]

ldr    r2, =Empty
  mov   r0, marioX                    // mario current x coord
  mov   r1, marioY                    // mario current y coord
  bl    DrawObject

  mov   r2, #24
  mla   currentCell, newY, r2, newX        // Find position below diagonally where mario was in array and replace
  mov   r0, #0
  strb  r0, [GameState, currentCell]  // store Mario into new position in array

  // draw mario in new location
  bl    CheckObject1
  mov   r2, r0                        // move the object address into r2
  mov   r0, newX
  mov   r1, newY
  bl    DrawObject

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
  .unreq  valueOfOldCell
  .unreq  newX
  .unreq  GameState


    pop   {r4-r10,pc}

// ================================================================================================= //

.globl MoveLU
MoveLU:// moves diagonally down and right
  marioX      .req     r4
  marioY      .req     r5
  currentCell .req     r6      		       // The cell number you are moving from
  newX        .req     r7
  newY        .req     r8                // The cell number to the left of crnt position
  valueOfOldCell .req  r9       	       // What is in the cell (ex. wall)
  GameState   .req     r10          	   // Holds address of the GameState array

  push        {r4-r10,lr}

  ldr   r3, =CurrentGameState
  ldrb  r3, [r3]        			           // get the value for which game state we are in
  cmp 	r3, #2                           //check which game state we are in and updates the correct one
  ldrlt GameState, =GameState1Copy       // Load the address of the Game State 1 array
  ldreq GameState, =GameState2Copy       // Load the address of the Game State 2 array
  ldrgt GameState, =GameState3Copy       // Load the address of the Game State 3 array

  ldr   r1, =MarioPosition      	       // Load address for location of character
  ldrb  marioX, [r1]                     // loading x coord of mario
  ldrb  marioY, [r1, #1]                 // loadking y coord of marioY
  sub   newX, marioX, #1                 // find x value of cell to the right (int)
  sub   newY, marioY, #1                 // Find y value of cell above (int)

  mov   r2, #24
  mla   currentCell, newY, r2, newX      // Find position above where mario was in array and replace
  ldrb  r0, [GameState, currentCell]

  mov   r1, #4                           // pass in direction
  mov   r2, currentCell
  bl    CheckMove

  cmp   r0, #0                            // if r0 is 0
  beq   doneLU                             // then cant move

  // Go here if able to move
  ldr   r1, =MarioPosition      	       // Load address for location of character
  strb  newX, [r1]
  strb  newY, [r1, #1]                   // Update Marios postion

  mov   r2, #24
  mla   currentCell, marioY, r2, marioX   // Mario index in array. currentCell = (y * width) + x

  mov   r2, #9
  strb  r2, [GameState, currentCell]

ldr    r2, =Empty
  mov   r0, marioX                    // mario current x coord
  mov   r1, marioY                    // mario current y coord
  bl    DrawObject

  mov   r2, #24
  mla   currentCell, newY, r2, newX        // Find position below diagonally where mario was in array and replace
  mov   r0, #0
  strb  r0, [GameState, currentCell]  // store Mario into new position in array

  // draw mario in new location
  bl    CheckObject1
  mov   r2, r0                        // move the object address into r2
  mov   r0, newX
  mov   r1, newY
  bl    DrawObject

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


    pop   {r4-r10,pc}


    // ================================================================================================= //

    .globl MoveLD
    MoveLD:// moves diagonally down and right
      marioX      .req     r4
      marioY      .req     r5
      currentCell .req     r6      		       // The cell number you are moving from
      newX        .req     r7
      newY        .req     r8                // The cell number to the left of crnt position
      valueOfOldCell .req  r9       	       // What is in the cell (ex. wall)
      GameState   .req     r10          	   // Holds address of the GameState array

      push        {r4-r10,lr}

      ldr   r3, =CurrentGameState
      ldrb  r3, [r3]        			           // get the value for which game state we are in
      cmp 	r3, #2                           //check which game state we are in and updates the correct one
      ldrlt GameState, =GameState1Copy       // Load the address of the Game State 1 array
      ldreq GameState, =GameState2Copy       // Load the address of the Game State 2 array
      ldrgt GameState, =GameState3Copy       // Load the address of the Game State 3 array

      ldr   r1, =MarioPosition      	       // Load address for location of character
      ldrb  marioX, [r1]                     // loading x coord of mario
      ldrb  marioY, [r1, #1]                 // loadking y coord of marioY
      sub   newX, marioX, #1                 // find x value of cell to the right (int)
      add   newY, marioY, #1                 // Find y value of cell above (int)

      mov   r2, #24
      mla   currentCell, newY, r2, newX      // Find position above where mario was in array and replace
      ldrb  r0, [GameState, currentCell]

      mov   r1, #4                           // pass in direction
      mov   r2, currentCell
      bl    CheckMove

      cmp   r0, #0                            // if r0 is 0
      beq   doneLD                             // then cant move

      // Go here if able to move
      ldr   r1, =MarioPosition      	       // Load address for location of character
      strb  newX, [r1]
      strb  newY, [r1, #1]                   // Update Marios postion

      mov   r2, #24
      mla   currentCell, marioY, r2, marioX   // Mario index in array. currentCell = (y * width) + x

      mov   r2, #9
      strb  r2, [GameState, currentCell]

    ldr    r2, =Empty
      mov   r0, marioX                    // mario current x coord
      mov   r1, marioY                    // mario current y coord
      bl    DrawObject

      mov   r2, #24
      mla   currentCell, newY, r2, newX        // Find position below diagonally where mario was in array and replace
      mov   r0, #0
      strb  r0, [GameState, currentCell]  // store Mario into new position in array

      // draw mario in new location
      bl    CheckObject1
      mov   r2, r0                        // move the object address into r2
      mov   r0, newX
      mov   r1, newY
      bl    DrawObject

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
      .unreq  valueOfOldCell
      .unreq  newX
      .unreq  GameState


        pop   {r4-r10,pc}

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

  ldr   r3, =CurrentGameState
  ldrb  r3, [r3]                         // get the value for which game state we are in
  cmp   r3, #4                           //check which game state we are in and updates the correct one
  ldrlt GameState, =GameState1Copy       // Load the address of the Game State 1 array
  ldreq GameState, =GameState2Copy       // Load the address of the Game State 2 array
  ldrgt GameState, =GameState3Copy       // Load the address of the Game State 3 array

  ldr   r1, =MarioPosition               // Load address for location of character
  ldrb  marioX, [r1]                     // loading x coord of mario
  ldrb  marioY, [r1, #1]                 // loadking y coord of marioY
  add   newY, marioY, #1                 // Find x value of cell to the right (int)


  mov   r2, #24
<<<<<<< HEAD
  mla   currentCell, newY, r2, marioX    // Find position below where mario was in array and replace

  // check if mario is standing on a pipe
  ldrb  r0, [GameState, currentCell]     // get cell value
  cmp   r0, #5                           // if cell value != 5...
  bne   doneDP                           // dont move
=======
  mla   currentCell, newY, r2, marioX                  // Find position below where mario was in array and replace
  
  ldrb  r0, [GameState, currentCell]                   // get cell value 
  cmp   r0, #5                                         // if cell value != 5...
  bne   doneDP                                         // dont move
>>>>>>> origin/master

  // else go to under pipe stage
  mov   r0, #2
  ldr   r3, =CurrentGameState
  strb  r0, [r3]                          // change the current game state to 2

  mov   r0, #1                            // new mario x pos
  mov   r1, #0                            // new mario y pos
  ldr   r3, =MarioPosition
  strb  r0, [r3]                          // store x coord
  strb  r1, [r3, #1]                      // store y coord

<<<<<<< HEAD
  bl    clearScreen                       // clear the screen


  ldr   r0, =GameState2Copy
  bl    GameReset

  bl    DrawGameScreen                    // draw next stage
  bl    drawScoreBoard

=======
>>>>>>> origin/master
  mov   r0, #9                            // empty block value
  ldr   r3, =OldCellObject
  strb  r0, [r3]                          // reset the fill value to empty cell

<<<<<<< HEAD

=======
>>>>>>> origin/master
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
* directions:
* 0 - none; 1 - right; 2 - left; 3 - up; 4 - down; 5 - downpress
* Args:
* r0 - object
* r1 - direction
* r2 - stage number
*Return:
* r0z; 0 - can't move; 1 - can move; 2 - lose life
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

    cmp object, #10
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


.globl GoombaKill
GoombaKill:
marioX      .req  r4
marioY      .req r5
currentCell .req  r6      		// The cell number you are moving from
newY        .req  r7          	// The cell number to the left of crnt position
valueOfOldCell .req  r8       	// What is in the cell (ex. wall)
oldCellValue .req r9
GameState   .req  r10          	// Holds address of the GameState array

push {r4-r10, lr}

  ldr   r3, =CurrentGameState
  ldrb  r3, [r3]        			           // get the value for which game state we are in
  cmp 	r3, #2                           //check which game state we are in and updates the correct one
  ldrlt GameState, =GameState1Copy       // Load the address of the Game State 1 array
  ldreq GameState, =GameState2Copy       // Load the address of the Game State 2 array
  ldrgt GameState, =GameState3Copy       // Load the address of the Game State 3 array

  ldr   r1, =MarioPosition      	       // Load address for location of character
  ldrb  marioX, [r1]                     // loading x coord of mario
  ldrb  marioY, [r1, #1]                 // loadking y coord of marioY
  add   newY, marioY, #1                 // Find x value of cell to the right (int)

  //    Find position below of where mario was in array and replace with empty cell
  mov   r2, #24
  mla   currentCell, newY, r2, marioX                 // Calculate index in array. currentCell = (y * width) + x

  mov   r0, #9
  strb  r0, [GameState, currentCell]                  // store empty cell into new position in array

  // draw mario in new location
  ldr   r2, =Empty                                    // move the object address into r2
  mov   r0, marioX
  mov   r1, newY
  bl    DrawObject

  .unreq  marioX
  .unreq  marioY
  .unreq  currentCell
  .unreq  newY
  .unreq  valueOfOldCell
  .unreq  oldCellValue
  .unreq  GameState

pop   {r4-r10,pc}


.globl BlockBreak
BlockBreak:
marioX      .req  r4
marioY      .req r5
currentCell .req  r6      		// The cell number you are moving from
newY        .req  r7          	// The cell number to the left of crnt position
valueOfOldCell .req  r8       	// What is in the cell (ex. wall)
oldCellValue .req r9
GameState   .req  r10          	// Holds address of the GameState array

push {r4-r10, lr}

  ldr   r3, =CurrentGameState
  ldrb  r3, [r3]        			           // get the value for which game state we are in
  cmp 	r3, #2                           //check which game state we are in and updates the correct one
  ldrlt GameState, =GameState1Copy       // Load the address of the Game State 1 array
  ldreq GameState, =GameState2Copy       // Load the address of the Game State 2 array
  ldrgt GameState, =GameState3Copy       // Load the address of the Game State 3 array

  ldr   r1, =MarioPosition      	       // Load address for location of character
  ldrb  marioX, [r1]                     // loading x coord of mario
  ldrb  marioY, [r1, #1]                 // loadking y coord of marioY
  sub   newY, marioY, #1                 // Find y value of cell above mario (int)

  //    Find position above of where mario was in array and replace with empty cell
  mov   r2, #24
  mla   currentCell, newY, r2, marioX                 // Calculate index in array. currentCell = (y * width) + x

  mov   r0, #9
  strb  r0, [GameState, currentCell]                  // store empty cell into new position in array

  // fill in new location
  ldr   r2, =Empty                                    // move the object address into r2
  mov   r0, marioX
  mov   r1, newY
  bl    DrawObject

  .unreq  marioX
  .unreq  marioY
  .unreq  currentCell
  .unreq  newY
  .unreq  valueOfOldCell
  .unreq  oldCellValue
  .unreq  GameState

pop   {r4-r10,pc}

.globl UpdateCoinBlock
UpdateCoinBlock:
  push    {r4-r10, lr}

  marioX      .req  r4
  marioY      .req r5
  currentCell .req  r6      		         // The cell number you are moving from
  newY        .req  r7          	       // The cell number to the left of crnt position
  coinCount .req  r8       	       // What is in the cell (ex. wall)
  oldCellValue .req r9
  GameState   .req  r10          	       // Holds address of the GameState array

  // else replace coin block with an empty block
  ldr   r3, =CurrentGameState
  ldrb  r3, [r3]        			           // get the value for which game state we are in
  cmp 	r3, #2                           //check which game state we are in and updates the correct one
  ldrlt GameState, =GameState1Copy       // Load the address of the Game State 1 array
  ldreq GameState, =GameState2Copy       // Load the address of the Game State 2 array
  ldrgt GameState, =GameState3Copy       // Load the address of the Game State 3 array

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
    .unreq  oldCellValue
    .unreq  GameState

  pop     {r4-r10, pc}


/*
* Events that happen when mario loses a loseLife
* Args:
* r0 - marioStartPos
* r1 - mario Current position
* r2 - current game state
*/
.globl loseLife
loseLife:
    state       .req  r4
    startPos    .req r5
    currentPos  .req r6

    push {r4-r10,lr}

    mov   state, r3                         // save the gamestate mario is in

    bl    lostLife

    // reload to the beginning of the current stage mario is in

    // reset mario saved coordinates
    mov   r0, #0                            // new mario x pos
    mov   r1, #17                            // new mario y pos
    ldr   r3, =MarioPosition
    strb  r0, [r3]                          // store x coord
    strb  r1, [r3, #1]                      // store y coord

    // clear screen
    bl clearScreen

    // redraw level
    ldr r0, =GameState1CopyDEATH
    ldr r1, =GameState1Copy
    bl  GameReset

    ldr r0, =GameState2
    ldr r1, =GameState2Copy
    bl  GameReset

    ldr r0, =GameState3
    ldr r1, =GameState3Copy
    bl  GameReset

    mov   r0, state
    bl    DrawGameScreen
    bl    drawScoreBoard

    pop   {r4-r10, pc}
