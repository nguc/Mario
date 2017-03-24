/*
* Calculates and draws mario "moving"
*/
.section .data

.globl MarioPosition
MarioPos: .int 409         	// initial position of mario - will change when mario moves

.globl OldCellObject
OldCellValue:	.byte 9     // Save value in cell that mario will move to so we can redraw when mario moves away


.globl CurrentGameState
CurrentGameState:	.byte 1 				// keeps track of which game screen we are in


.section .text

/* Moves Mario right if he is allowed
 * Args:
 *  none
 * Return:
 *  none
 */
.globl MoveRight
MoveRight:

  currentCell .req  r4      		// The cell number you are moving from
  rightCell   .req  r5          	// The cell number to the left of crnt position
  valueOfOldCell .req  r6       	// What is in the cell (ex. wall)
  oldCellValue .req r7
  GameState   .req  r8          	// Holds address of the GameState array
 

  push        {r4-r8,lr}

  ldr   r1, =MarioPosition      	// Load address for location of character
  ldr  currentCell, [r0]        	// Load cell location of mario (int)

  ldr   r2, =OldCellObject
  ldrb  valueOfOldCell, [r1]     	// get value for cell to replace mario

  add   rightCell, currentCell, #1  // Find value of cell to the right

  ldr   r3, =CurrentGameState
  ldrb  r3, [r3]        			// get the value for which game state we are in


  /* check which game state we are in and updates the correct one */
  cmp 	r3, #2
  ldrlt GameState, =GameState1Copy       // Load the address of the Game State 1 array
  ldreq GameState, =GameState2Copy       // Load the address of the Game State 2 array
  ldrgt GameState, =GameState3Copy       // Load the address of the Game State 3 array

  strb  valueOfOldCell, [GameState, currentCell]        // replace cell where mario is moving away from
  ldrb  valueOfOldCell, [GameState, rightCell]  		// Load the value stored to right of Mario

  strb  valueOfOldCell, [r2]			  // store value in OldCellObject

  mov   r3, #0                            // value for mario
  strb  r3, [GameState, rightCell]        // store Mario into new position


/*
  mov   r0, oldCell         // Move old cell number to r0
  mov   r1, rightCell       // Move new cell number to r1
  mov   r2, GameState       // Move address of the array to r2
  mov   r3, cell            // Move value of cell to r3

  bl    MoveCheckLR           // Check if you can move, and then move if possible
  */

  mov r0, #0
  mov r1, #0
  mov r2, GameState

  bl DrawGameScreen


  .unreq  currentCell
  .unreq  rightCell
  .unreq  valueOfOldCell
  .unreq  oldCellValue
  .unreq  GameState

  pop   {r4-r8,pc}


/* Moves Mario left if he is allowed
 * Args:
 *  none
 * Return:
 *  none
 */
.globl MoveLeft
MoveLeft:

  currentCell .req  r4      		// The cell number you are moving from
  leftCell   .req  r5          		// The cell number to the left of crnt position
  valueOfOldCell .req  r6       	// What is in the cell (ex. wall)
  oldCellValue .req r7
  GameState   .req  r8          	// Holds address of the GameState array
 

  push        {r4-r8,lr}

  ldr   r1, =MarioPosition      	// Load address for location of character
  ldr  currentCell, [r0]        	// Load cell location of mario (int)

  ldr   r2, =OldCellObject
  ldrb  valueOfOldCell, [r1]     	// get value for cell to replace mario

  sub   leftCell, currentCell, #1   // Find value of cell to the right

  ldr   r3, =CurrentGameState
  ldrb  r3, [r3]        			// get the value for which game state we are in


  /* check which game state we are in and updates the correct one */
  cmp 	r3, #2
  ldrlt GameState, =GameState1Copy       // Load the address of the Game State 1 array
  ldreq GameState, =GameState2Copy       // Load the address of the Game State 2 array
  ldrgt GameState, =GameState3Copy       // Load the address of the Game State 3 array

  strb  valueOfOldCell, [GameState, currentCell]        // replace cell where mario is moving away from
  ldrb  valueOfOldCell, [GameState, leftCell]  			// Load the value stored to right of Mario

  strb  valueOfOldCell, [r2]			  // store value in OldCellObject

  mov   r3, #0                            // value for mario
  strb  r3, [GameState, leftCell]        // store Mario into new position


/*
  mov   r0, oldCell         // Move old cell number to r0
  mov   r1, leftCell       // Move new cell number to r1
  mov   r2, GameState       // Move address of the array to r2
  mov   r3, cell            // Move value of cell to r3

  bl    MoveCheckLR           // Check if you can move, and then move if possible
  */

  mov r0, #0
  mov r1, #0
  mov r2, GameState

  bl DrawGameScreen


  .unreq  currentCell
  .unreq  leftCell
  .unreq  valueOfOldCell
  .unreq  oldCellValue
  .unreq  GameState

  pop   {r4-r8,pc}


/* Moves Mario up if he is allowed
 * Args:
 *  none
 * Return:
 *  none
 */
.globl MoveUp
MoveUp:

  currentCell .req  r4      		// The cell number you are moving from
  UpCell   .req  r5          		// The cell number to the left of crnt position
  valueOfOldCell .req  r6       	// What is in the cell (ex. wall)
  oldCellValue .req r7
  GameState   .req  r8          	// Holds address of the GameState array
 
  push        {r4-r8,lr}

  ldr   r1, =MarioPosition      	// Load address for location of character
  ldr  currentCell, [r0]        	// Load cell location of mario (int)

  ldr   r2, =OldCellObject
  ldrb  valueOfOldCell, [r1]     	// get value for cell to replace mario

  sub   upCell, currentCell, #24  // Find value of cell above

  ldr   r3, =CurrentGameState
  ldrb  r3, [r3]        			// get the value for which game state we are in


  /* check which game state we are in and updates the correct one */
  cmp 	r3, #2
  ldrlt GameState, =GameState1Copy       // Load the address of the Game State 1 array
  ldreq GameState, =GameState2Copy       // Load the address of the Game State 2 array
  ldrgt GameState, =GameState3Copy       // Load the address of the Game State 3 array

  strb  valueOfOldCell, [GameState, currentCell]        // replace cell where mario is moving away from
  ldrb  valueOfOldCell, [GameState, upCell]  			// Load the value stored to right of Mario

  strb  valueOfOldCell, [r2]			  // store value in OldCellObject

  mov   r3, #0                            // value for mario
  strb  r3, [GameState, upCell]        // store Mario into new position


/*
  mov   r0, oldCell         // Move old cell number to r0
  mov   r1, upCell       // Move new cell number to r1
  mov   r2, GameState       // Move address of the array to r2
  mov   r3, cell            // Move value of cell to r3

  bl    MoveCheckLR           // Check if you can move, and then move if possible
*/

  mov r0, #0
  mov r1, #0
  mov r2, GameState

  bl DrawGameScreen

  .unreq  currentCell
  .unreq  upCell
  .unreq  valueOfOldCell
  .unreq  oldCellValue
  .unreq  GameState

  pop   {r4-r8,pc}


/* Moves Mario down if he is allowed
 * Args:
 *  none
 * Return:
 *  none
 */
.globl MoveDown
MoveDown:

  currentCell .req  r4      		// The cell number you are moving from
  DownCell   .req  r5          		// The cell number to the left of crnt position
  valueOfOldCell .req  r6       	// What is in the cell (ex. wall)
  oldCellValue .req r7
  GameState   .req  r8          	// Holds address of the GameState array
 
  push        {r4-r8,lr}

  ldr   r1, =MarioPosition      	// Load address for location of character
  ldr  currentCell, [r0]        	// Load cell location of mario (int)

  ldr   r2, =OldCellObject
  ldrb  valueOfOldCell, [r1]     	// get value for cell to replace mario

  add   DownCell, currentCell, #24    // Find value of cell above (add width)

  ldr   r3, =CurrentGameState
  ldrb  r3, [r3]        			// get the value for which game state we are in


  /* check which game state we are in and updates the correct one */
  cmp 	r3, #2
  ldrlt GameState, =GameState1Copy       // Load the address of the Game State 1 array
  ldreq GameState, =GameState2Copy       // Load the address of the Game State 2 array
  ldrgt GameState, =GameState3Copy       // Load the address of the Game State 3 array

  strb  valueOfOldCell, [GameState, currentCell]        // replace cell where mario is moving away from
  ldrb  valueOfOldCell, [GameState, DownCell]  			// Load the value stored to right of Mario

  strb  valueOfOldCell, [r2]			  // store value in OldCellObject

  mov   r3, #0                            // value for mario
  strb  r3, [GameState, DownCell]        // store Mario into new position


/*
  mov   r0, oldCell         // Move old cell number to r0
  mov   r1, DownCell       // Move new cell number to r1
  mov   r2, GameState       // Move address of the array to r2
  mov   r3, cell            // Move value of cell to r3

  bl    MoveCheckLR           // Check if you can move, and then move if possible
*/

  mov r0, #0
  mov r1, #0
  mov r2, GameState

  bl DrawGameScreen

  .unreq  currentCell
  .unreq  DownCell
  .unreq  valueOfOldCell
  .unreq  oldCellValue
  .unreq  GameState

  pop   {r4-r8,pc}


// ================================================================================================= //
