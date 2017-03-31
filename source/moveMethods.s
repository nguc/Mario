/* trying to make the move methods more modular */

/*
* This method checks which game state mario is currently in and returns the gamestate address
* Args:
* 	None
* Return:
* 	r0 - address of current game state
*/
.globl GetCurrentGameState
GetCurrentGameState:
	push {lr}

  ldr   r3, =CurrentGameState
  ldrb  r3, [r3]        		    // get the value for which game state we are in
  cmp 	r3, #2                      //check which game state we are in and updates the correct one
  ldrlt r0, =GameState1Copy         // Load the address of the Game State 1 array
  ldreq r0, =GameState2Copy         // Load the address of the Game State 2 array
  ldrgt r0, =GameState3Copy         // Load the address of the Game State 3 array

  	pop {pc}


/*
* Draws an empty cell at mario''s current position on screen and replaces mario with empty cell value in the array
* Args:
* 	r0 - mario X coord
* 	r1 - mario Y coord
* 	r2 - gamestate address
* Return:
* 	None
*/
.globl ReplaceMarioInCurrent
 ReplaceMarioInCurrent:
 	marioX 		.req 	r4
 	marioY 		.req    r5
 	gamestate   .req    r6
 	arrayPos    .req    r7

 	push 	{r4-r7, lr}
 	
 	mov 	marioX, r0
 	mov 	marioY, r1
 	mov 	gamestate, r2

 	ldr 	r2, =Emtpy 						// erases mario on screen 
 	bl 		DrawObject

 	mov   r2, #24
  	mla   arrayPos, marioY, r2, marioX    	// Mario position in array

 	mov 	r2, #9 							// value of empty to store into array
 	strb 	r2, [gamestate, arrayPos] 		// replace mario position in array with an empty cell 

 	.unreq	mariox
 	.unreq 	marioY
 	.unreq	gamestate
 	.unreq	arrayPos

 	pop 	{r4-r7, pc}


/*
* Draws mario in his new position on screen and updates mario''s position in the array
* Args:
* 	r0 - mario X coord
* 	r1 - mario Y coord
* 	r2 - gamestate
* Return:
* 	None
*/
.globl MoveMarioToNewCell
MoveMarioToNewCell:
	marioX 		.req 	r4
 	marioY 		.req    r5
 	gamestate   .req    r6
 	arrayPos    .req    r7

 	push 	{r4-r7, lr}
	
	mov 	marioX, r0
 	mov 	marioY, r1
 	mov 	gamestate, r2

 	ldr 	r2, =Mario
 	bl 		DrawObject 							// draw mario on screen in new position

 	mov   r2, #24
  	mla   arrayPos, marioY, r2, marioX    		// Mario position in array

 	mov 	r2, #0 								// value for mario in array
 	strb 	r2, [gamestate, arrayPos] 			// store mario in his new position

 	.unreq	mariox
 	.unreq 	marioY
 	.unreq	gamestate
 	.unreq	arrayPos

 	pop 	{r4-r7, pc}


/*
* Resets mario global position and changes the global gamestate value and draws the next stage
* Args:
* 	r0 - new mario x coord
*	r1 - new mario y coord
*	r2 - new gamestate value 
* Return:
* 	None
*/
.globl SetupNextStage
SetupNextStage:
	x 			.req r4
	y 			.req r5
	GSValue		.req r6

	push 	{r4-r6, lr}

	mov 	x, r0
	mov 	y, r1
	mov 	GSValue, r2

	ldr 	r3, =CurrentGameState 			// updating the game state value
	strb 	GSValue, [r3] 				// storing the new value

	ldr 	r3, =MarioPosition 				// updating Mario global coordinates
	strb 	x, [r3] 						// store new x value
	strb 	r2, [r3, #1] 					// store new y value

	bl 		clearScreen 					// clear the game screen
	
	bl 		GetCurrentGameState 			// gets the address of the new game state to draw

	bl 		DrawGameScreen 					// draws the new game stage
	bl 		drawScoreBoard 					// draws the scoreboard	
	
	.unreq 	x
	.unreq  y
	.unreq 	gamestate

	pop 	{r4-r6, pc}



/*
* when mario loses a loseLife reset his position to the start of the stage, change the life count, and reload the stage
* Args:
* 	None
* Return:
* 	None
*/
.globl loseLife
loseLife:
    gameStateAddr    	.req r4
    gameStateVal		.req r5

    push 	{r4-r10,lr}

    bl   	lostLife 					    // calculate the lost life

    bl    	GetCurrentGameState
    mov   	gameStateAddr, r0 				// save the game state address

    ldr  	r3, =CurrentGameState
    ldrb 	gameStateVal, [r3] 			    // get value of current game state

	// reset mario global coordinates
    cmp 	gameStateVal, #1 				// check which game state we are in
    moveq 	r0, #1 							// if in GS 1 then mario starts at x coord = 1
    movne 	r0, #0 							// else mario starts at x coord = 0
    
    mov   	r1, #17                           // new mario y pos
    ldr   	r3, =MarioPosition
    strb  	r0, [r3]                          // store x coord
    strb  	r1, [r3, #1]                      // store y coord

    bl clearScreen

    mov   r0, gameStateAddr 				// address of game state to redraw
    bl    DrawGameScreen
    bl    drawScoreBoard

    pop   {r4-r10, pc}
