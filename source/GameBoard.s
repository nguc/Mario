.section .data
.align 4

xRes: .int 1023
yRes: .int 767

/*
* Layout: 24 x 20 cell grid for the game screen
* 0 = mario; 1 = GroundBrick; 2 = WallBrick; 3 = floatingBrick; 4 = questionBlock;
* 5 = pipeUp; 6 = coin; 7 = Goomba; 8 = Koopa; 9 = empty; `10 - emptyBlock;`
*/

.globl GameState1
GameState1:		// Starting state of first screen
.byte 2,9,9,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
.byte 2,9,9,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,6,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,4,2,2,2,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,5,9,9
.byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
.byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1


.globl GameState1Copy
GameState1Copy:		// This board used to update game state
.byte 2,0,9,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
.byte 2,9,9,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
.byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1

/*
* Load this screen when mario tries to go to the square that is out of the game screen if GameState1
*/
.globl GameState2Copy
GameState2Copy:

.byte 2,9,9,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
.byte 2,9,9,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,5,5,5,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
.byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1

.globl GameState3Copy
GameState3Copy:
.byte 2,9,9,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
.byte 2,9,9,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 2,0,9,9,9,9,9,9,9,9,7,7,9,9,9,9,9,9,9,9,9,9,9,9
.byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
.byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1

.globl BlackScreen
BlackScreen:
.byte 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
.byte 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9

.section .text
.align 4

.globl GameReset
GameReset:
	orgState 	.req	r4	// Address of the original state
	copyState 	.req	r5	// Address of the copy state
	counter		.req	r6	// Counter

	push	{r4-r6, lr}

	ldr		orgState, =GameState1				// Load address of original array
	ldr		copyState, =GameState1Copy			// Load address of new array

	// repeat for states 2 and 3

	mov 	counter, #0 						// set counter to 0

CopyState:
	ldrb 	r1, [orgState, counter]				// load value from original state
	strb 	r1, [copyState, counter] 			// store value from original state
	add 	counter, #1 						// increment counter

	cmp 	counter, #480 						// check if all cells were written to
	blt 	CopyState							// keep branching until all cells copied

	.unreq 	orgState
	.unreq	copyState
	.unreq	counter

	pop		{r4-r6, pc}


/* Draws the first stage of the game
* Args
* r0 - x coord of game screen origin (top)
* r1 - y coord of game screen origin (left)
* r2 - game state addr
*/
.globl DrawGameScreen
DrawGameScreen:
		initX	 		.req   r4			// x origin
    initY	 		.req   r5			// y origin
    state 	 	.req	r6			// Game state used
    counter  	.req	r7
    x		 			.req	r8			// x value for the object to be drawn
    y		 			.req	r9			// y value for the object to be drawn
    tmp		 		.req	r10			// temporary value used for checking row

	push	 {r3-r10,lr}

	mov 	 initX, r0 			// Set intial X
	mov 	 initY, r1 			// Set intial Y
	mov 	 x, initX 			// initialize x coord of object
	mov 	 y, initY 			// initialize y coord of object
	mov 	 state, r2 			// copy address of state used
	mov 	 counter, #0 		// initialize counter to 0

CheckObject:
	mov 	r0, x 				// set x coordinate for object to be drawn
	mov 	r1, y 				// set y coordinate for object to be drawn
	ldrb 	r3, [state, counter] // Load value stored in array

	cmp 	r3, #0
	beq 	drawMario

	cmp 	r3, #1
	beq 	drawGroundBrick

	cmp 	r3, #2
	beq 	drawWallBrick

	cmp 	r3, #3
	beq 	drawFloatingBrick

	cmp 	r3, #4
	beq 	drawQuestionBlock

	cmp 	r3, #5
	beq 	drawPipeUp

	cmp 	r3, #6
	beq 	drawCoin

	cmp 	r3, #7
	beq 	drawGoomba

	cmp 	r3, #8
	beq 	drawKoopa

	cmp 	r3, #9
	beq 	drawEmpty

	cmp 	r3, #10
	beq 	drawPipe

	cmp 	r3, #11
	beq 	drawPipeBody

/*For each draw function...
* value of x and y are from the CheckObject function above
* r2 is loaded with the address of the .ascii data of the object
* drawObject is then called using these arguments
*/
drawMario:
	ldr 	r2, =Mario
	bl 		DrawObject
	b 		CheckLoop

drawGroundBrick:
	ldr 	r2, =GroundBrick
	bl 		DrawObject
	b 		CheckLoop

drawWallBrick:
	ldr 	r2, =WallBlock // need to get ascii for wall
	bl 		DrawObject
	b 		CheckLoop
drawFloatingBrick:

drawQuestionBlock:
	ldr 	r2, =QuestionBlock
	bl 		DrawObject
	b 		CheckLoop
drawPipeUp:
	ldr 	r2, =PipeUp
	bl 		DrawObject
	b 		CheckLoop

drawCoin:
	  ldr 	r2, =Coin 	// Coin background needs to be white
		bl 		DrawObject
		b 		CheckLoop
drawGoomba:
	ldr 	r2, =Goomba 	// need new goomba code - background needs to be white
	bl 		DrawObject
	b 		CheckLoop
drawKoopa:

drawEmpty:
	ldr 	r2, =Empty
	bl 		DrawObject
	b 		CheckLoop

drawPipe:

drawPipeBody:

CheckLoop:
	 add 		counter, #1
	 cmp 		counter, #480		// check if all objects drawn
	 bge 		done 						// if all objects drawn go to done

	 cmp 		x, #23
	 addne 	x, #1
	 addeq	y, #1
	 moveq 	x, initX

	 cmp 		y, #20
	 blt		CheckObject

done:
	.unreq      initX
  .unreq      initY
	.unreq 		state
	.unreq 		counter
  .unreq      x
  .unreq      y
	.unreq 			tmp

	pop	 {r3-r10, pc}
