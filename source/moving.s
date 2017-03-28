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

.section .text



/* Moves Mario right if he is allowed
 * 0 - none; 1 - right; 2 - left; 3 - up; 4 - down
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
  valueOfOldCell .req  r8       	// What is in the cell (ex. wall)
  oldCellValue .req r9
  GameState   .req  r10          	// Holds address of the GameState array

  push        {r4-r10,lr}

  ldr   r3, =CurrentGameState
  ldrb  r3, [r3]        			             // get the value for which game state we are in
  cmp 	r3, #2                             //check which game state we are in and updates the correct one
  ldrlt GameState, =GameState1Copy         // Load the address of the Game State 1 array
  ldreq GameState, =GameState2Copy         // Load the address of the Game State 2 array
  ldrgt GameState, =GameState3Copy         // Load the address of the Game State 3 array

  ldr   r1, =MarioPosition      	         // Load address for location of character
  ldrb  marioX, [r1]                       // loading x coord of mario
  ldrb  marioY, [r1, #1]                   // loadking y coord of marioY
  add   newX, marioX, #1                   // Find x value of cell to the right (int)

  /*
   * Check if mario is going to the next stage
  */
  cmp    newX, #24                         //check if mario is going to move off screen
  blt    contR                             // if still in screen continue check if he can move

 // draw in cell mario is currently at
  mov   r0, #9                            // mov valueOfOldCell into r0 to be passed as an arg
  bl    CheckObject1                      // check what the object is
  mov   r2, r0                            // move the object address into r2
  mov   r0, marioX
  mov   r1, marioY
  bl    DrawObject

  mov   r2, #3                             // new game state value
  ldr   r3, =CurrentGameState
  strb  r2, [r3]                           // save change to game state

  mov   r0, #0                             // new mario x pos for next stage
  mov   r1, #17                            // new mario y pos for next stage
  ldr   r3, =MarioPosition
  strb  r0, [r3]                           // store x coord
  strb  r1, [r3, #1]                       // store y coord

  bl    clearScreen                       // clear the screen

  ldr   r0, =GameState3Copy
  bl    DrawGameScreen

  mov   r0, #9                             // empty block value
  ldr   r3, =OldCellObject                 // value to fill mario location with
  strb  r0, [r3]                           // reset the fill value to empty cell


  b     doneR

/*
* continue to check if mario can move right
*/

contR:
  mov   r2, #24
  mla   currentCell, marioY, r2, newX      // check if move valid by checking object to the right of mario. currentCell = (y * width) + Newx
  ldrb  r0, [GameState, currentCell]
  mov   r1, #1                             // pass in direction
  mov   r2, currentCell
  bl    CheckMove

  cmp   r0, #0                             // if r0 is 0
  beq   doneR                              // then cant move

  // if able to move...
  ldr   r1, =MarioPosition      	         // Load address for location of character
  strb   newX, [r1]                        // Update Mario postion

  mov   r2, #24
  mla   currentCell, marioY, r2, marioX    // Mario position in array. currentCell = (y * width) + x

  ldr   r2, =OldCellObject
  ldrb  valueOfOldCell, [r2]     	                    // get value for cell to replace mario
  strb  valueOfOldCell, [GameState, currentCell]      // replace cell where mario is moving away from in array

  // draw in cell mario is currently in
  mov   r0, valueOfOldCell            // mov valueOfOldCell into r0 to be passed as an arg
  bl    CheckObject1                  // check what the object is
  mov   r2, r0                        // move the object address into r2
  mov   r0, marioX
  mov   r1, marioY
  bl    DrawObject

  //    Find position to the right of where mario was in array and replace
  mov   r2, #24
  mla   currentCell, marioY, r2, newX                 // Calculate index in array. currentCell = (y * width) + x

  ldrb  valueOfOldCell, [GameState, currentCell]  		// Load the value stored to right of Mario
  ldr   r2, =OldCellObject
  strb  valueOfOldCell, [r2]			                    // store value in OldCellObject

  mov   r0, #0
  strb  r0, [GameState, currentCell]                  // store Mario into new position in array

  // draw mario in new location
  bl    CheckObject1
  mov   r2, r0                                        // move the object address into r2
  mov   r0, newX
  mov   r1, marioY
  bl    DrawObject

  // Get object below mario
  add   marioY, marioY, #1                             // position below marios new position
  mov   r2, #24
  mla   currentCell, marioY, r2, newX                  // Find position below where mario was in array and replace
  ldrb  r0, [GameState, currentCell]

doneR:
  .unreq  marioX
  .unreq  marioY
  .unreq  currentCell
  .unreq  newX
  .unreq  valueOfOldCell
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
subs   newX, marioX, #1                 // Find x value of cell to the right (int)

/*
* check if mario is moving to the far left edge
*/
cmp    newX, #0                         //check if mario is going to move off screen
bge    contL                             // if still in screen continue check if he can move

mov   r0, #9                            // mov empty cell 
bl    CheckObject1                      // get address of empty cell
mov   r2, r0                            // move the object address into r2
mov   r0, marioX
mov   r1, marioY
bl    DrawObject                        // delete mario current location

mov   r2, #1                             // moving to state 1
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

mov   r0, #9                             // empty block value
ldr   r3, =OldCellObject
strb  r0, [r3]                           // reset the fill value to empty cell

b     doneL                              // finished moving, wait for next input

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

// Go here if able to move
ldr   r1, =MarioPosition      	       // Load address for location of character
strb   newX, [r1]                      // Update Marios postion

mov   r2, #24
mla   currentCell, marioY, r2, marioX   // Calculate index in array. currentCell = (y * width) + x

ldr   r2, =OldCellObject
ldrb  valueOfOldCell, [r2]     	                    // get value for cell to replace mario
strb  valueOfOldCell, [GameState, currentCell]      // replace cell where mario is moving away from in array

// draw in cell mario is currently in
mov   r0, valueOfOldCell            // mov valueOfOldCell into r0 to be passed as an arg
bl    CheckObject1                  // check what the object is
mov   r2, r0                        // move the object address into r2
mov   r0, marioX
mov   r1, marioY
bl    DrawObject

//    Find position to the right of where mario was in array and replace
mov   r2, #24
mla   currentCell, marioY, r2, newX                 // Calculate index in array. currentCell = (y * width) + x

ldrb  valueOfOldCell, [GameState, currentCell]  		// Load the value stored to right of Mario
ldr   r2, =OldCellObject
strb  valueOfOldCell, [r2]			                    // store value in OldCellObject

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
.unreq  valueOfOldCell
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
sub   newY, marioY, #1                 // Find x value of cell to the right (int)

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

ldr   r2, =OldCellObject
ldrb  valueOfOldCell, [r2]     	                    // get value for cell to replace mario
strb  valueOfOldCell, [GameState, currentCell]      // replace cell where mario is moving away from in array

// draw in cell mario is currently in
mov   r0, valueOfOldCell            // mov valueOfOldCell into r0 to be passed as an arg
bl    CheckObject1                  // check what the object is

mov   r2, r0                        // move the object address into r2
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
 * 
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
  valueOfOldCell .req r8       	          // What is in the cell (ex. wall)
  GameState   .req    r9          	      // Holds address of the GameState array

  push        {r4-r9,lr}


  ldr   r3, =CurrentGameState
  ldrb  r3, [r3]        			           // get the value for which game state we are in
  cmp 	r3, #4                           //check which game state we are in and updates the correct one
  ldrlt GameState, =GameState1Copy       // Load the address of the Game State 1 array
  ldreq GameState, =GameState2Copy       // Load the address of the Game State 2 array
  ldrgt GameState, =GameState3Copy       // Load the address of the Game State 3 array

  ldr   r1, =MarioPosition      	       // Load address for location of character
  ldrb  marioX, [r1]                     // loading x coord of mario
  ldrb  marioY, [r1, #1]                 // loadking y coord of marioY
  add   newY, marioY, #1                 // Find x value of cell to the right (int)


  mov   r2, #24
  mla   currentCell, newY, r2, marioX                  // Find position below where mario was in array and replace

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

  ldr   r2, =OldCellObject
  ldrb  valueOfOldCell, [r2]     	                    // get value for cell to replace mario
  strb  valueOfOldCell, [GameState, currentCell]      // replace cell where mario is moving away from in array

  // draw in cell mario is currently in
  mov   r0, valueOfOldCell                            // mov valueOfOldCell into r0 to be passed as an arg
  bl    CheckObject1                                  // check what the object is
  mov   r2, r0                                        // move the object address into r2
  mov   r0, marioX
  mov   r1, marioY
  bl    DrawObject

  //    Find position below of where mario was in array and replace
  mov   r2, #24
  mla   currentCell, newY, r2, marioX                 // Calculate index in array. currentCell = (y * width) + x

  ldrb  valueOfOldCell, [GameState, currentCell]  		// Load the value stored below of Mario
  ldr   r2, =OldCellObject
  strb  valueOfOldCell, [r2]			                    // store value in OldCellObject

  mov   r0, #0
  strb  r0, [GameState, currentCell]                  // store Mario into new position in array

  // draw mario in new location
  bl    CheckObject1
  mov   r2, r0                                        // move the object address into r2
  mov   r0, marioX
  mov   r1, newY
  bl    DrawObject

  // Get object below mario
  add   newY, newY, #1                                 // position below marios new position
  cmp   newY, #20                                      // check if mario is at the edge of the screen
  blt   nextD                                          // check if he keeps falling

  bl    dead                                           // else mario died

  b     doneD
nextD:
  mov   r2, #24
  mla   currentCell, newY, r2, marioX                  // Find position below where mario was in array and replace
  ldrb  r0, [GameState, currentCell]

doneD:
.unreq  marioX
.unreq  marioY
.unreq  currentCell
.unreq  newY
.unreq  valueOfOldCell
.unreq  GameState



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

ldr   r2, =OldCellObject
ldrb  valueOfOldCell, [r2]     	                    // get value for cell to replace mario
strb  valueOfOldCell, [GameState, currentCell]      // replace cell where mario is moving away from in array

// draw in cell mario is currently in
mov   r0, valueOfOldCell            // mov valueOfOldCell into r0 to be passed as an arg
bl    CheckObject1                  // check what the object is

mov   r2, r0                        // move the object address into r2
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

  ldr   r2, =OldCellObject
  ldrb  valueOfOldCell, [r2]     	                    // get value for cell to replace mario
  strb  valueOfOldCell, [GameState, currentCell]      // replace cell where mario is moving away from in array

  // draw in cell mario is currently in
  mov   r0, valueOfOldCell            // mov valueOfOldCell into r0 to be passed as an arg
  bl    CheckObject1                  // check what the object is

  mov   r2, r0                        // move the object address into r2
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

  ldr   r2, =OldCellObject
  ldrb  valueOfOldCell, [r2]     	                    // get value for cell to replace mario
  strb  valueOfOldCell, [GameState, currentCell]      // replace cell where mario is moving away from in array

  // draw in cell mario is currently in
  mov   r0, valueOfOldCell            // mov valueOfOldCell into r0 to be passed as an arg
  bl    CheckObject1                  // check what the object is

  mov   r2, r0                        // move the object address into r2
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

      ldr   r2, =OldCellObject
      ldrb  valueOfOldCell, [r2]     	                    // get value for cell to replace mario
      strb  valueOfOldCell, [GameState, currentCell]      // replace cell where mario is moving away from in array

      // draw in cell mario is currently in
      mov   r0, valueOfOldCell            // mov valueOfOldCell into r0 to be passed as an arg
      bl    CheckObject1                  // check what the object is

      mov   r2, r0                        // move the object address into r2
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
  cmp   r3, #1                           //check which game state we are in and updates the correct one
  bne   doneDP                           // if equal then check if on standing on pipe, else do nothing
  
  ldr GameState, =GameState1Copy         // Load the address of the Game State 1 array
 
  ldr   r1, =MarioPosition               // Load address for location of character
  ldrb  marioX, [r1]                     // loading x coord of mario
  ldrb  marioY, [r1, #1]                 // loadking y coord of marioY
  add   newY, marioY, #1                 // Find x value of cell to the right (int)

  mov   r2, #24
  mla   currentCell, newY, r2, marioX    // Find position below where mario was in array and replace

  // check if mario is standing on a pipe
  ldrb  r0, [GameState, currentCell]     // get cell value
  cmp   r0, #5                           // if cell value is not a pipe
  bne   doneDP                           // dont move

  // else go to under pipe stage
  mov   r0, #2
  ldr   r3, =CurrentGameState
  strb  r0, [r3]                          // change the current game state to 2

 // draw in cell mario is currently in
  mov   r0, valueOfOldCell            // mov valueOfOldCell into r0 to be passed as an arg
  bl    CheckObject1                  // check what the object is

  mov   r2, r0                        // move the object address into r2
  mov   r0, marioX                    // mario current x coord
  mov   r1, marioY                    // mario current y coord
  bl    DrawObject

  mov   r0, #1                            // new mario x pos
  mov   r1, #0                            // new mario y pos
  ldr   r3, =MarioPosition
  strb  r0, [r3]                          // store x coord
  strb  r1, [r3, #1]                      // store y coord

  bl    clearScreen                       // clear the screen

  ldr   r0, =GameState2Copy
  bl    DrawGameScreen                    // draw next stage

  mov   r0, #9                            // empty block value
  ldr   r3, =OldCellObject
  strb  r0, [r3]                          // reset the fill value to empty cell

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
* 0 - none; 1 - right; 2 - left; 3 - up; 4 - down
* Args:
* r0 - direction
* r1 - object
* r2 - object cell #
*
*/
.globl CheckMove
CheckMove:
    object      .req r0
    direction   .req r1
    cellNum     .req r2
    marioStatus .req r3

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

    cmp object, #9        // empty - always move
    mov r0, #1

    b   doneMove

WallBlockMove:
    cmp r1, #3            // see if mario is moving up
    bne NoMove            // if not moving up then dont move
    mov r0, #1            // else he can break the block
    b   doneMove

QuestionBlockMove:
    cmp r1, #3             // check if mario is moving up
    bne NoMove             // if not then dont move
    // if he is then replce QuestionBlock with empty block and draw item aboe the block

PipUpMove:
    cmpeq r1, #5          // check if down was pressed
    bne NoMove
    mov r0, #1
    b   doneMove

CoinMove:

    //bl  CoinEvent          // collect and increment score
    mov r0, #0                // move to coin space
    b   doneMove


GoombaMove:

KoopaMove:

NoMove:
    mov r0, #0

doneMove:

    pop {pc}
