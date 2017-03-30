.section .text

/* Draw Pixel * Code taken from tutorial notes *
 *  r0 - x
 *  r1 - y
 *  r2 - color
 */
.globl DrawPixel
DrawPixel:
	push	{r4-r10}


	offset	.req	r4

	// offset = (y * 1024) + x = x + (y << 10)
	add		offset,	r0, r1, lsl #10

	// offset *= 2 (for 16 bits per pixel = 2 bytes per pixel)
	lsl		offset, #1

	// store the colour (half word) at framebuffer pointer + offset
	ldr	r0, =FrameBufferPointer
	ldr	r0, [r0]
	strh	r2, [r0, offset]

	pop		{r4-r10}
	bx		lr


/* Draws a 32x32 pixel cell
* Args:
* r0 - x as a coordinate of the game screen
* r1 - y as a coordinate of the game screen
* r2 - object address
*/
.globl DrawObject
DrawObject:
		white 	.req 		r3     // store the value of whilt
		initX   .req    r4     // Left most posiiton of cell
    initY   .req    r5     // Top postion of cell
		finalX	.req    r6	   // Final position of x
		finalY	.req 		r7 	   // Final postion of y
		object  .req    r8     // address of object to be drawn
    px      .req    r9     // x coord of pixel relative to cell
    py      .req    r10    // y coord of pixel relative to cell


    push    {r3 - r10, lr}

		mov 		r11, #128 			 					// store temp value in r3
    add     initX, r11, r0, lsl #5 	// Calculate inital pos of x = (x * 32) + 128 = 128 + (x << 5)
		mov 		r11, #64
    add   	initY, r11, r1, lsl #5    	// Calculate inital pos of y = (y * 32) + 64
		add 		finalX, initX, #31 		// Calculate final pos of x for cell
		add 		finalY, initY, #32 		// Calculate final pos of y for cell
    mov     object, r2    				// saves address of the object
    mov     px, initX        			// initialize x coord of object
    mov     py, initY        			// initialize y coord of object
		ldr 		white, =white
		ldrh 		white, [white]

  CellLoop:

    mov     r0, px        			// move pixel value of x to r0
    mov     r1, py        			// move pixel value of y to r1
    ldrh    r2, [object], #2    // load object colour and increment to next colour
    cmp 		r2, white 					// if colour is white..
    beq 		nextpixel						// skip drawing and go to next pixel

    bl      DrawPixel     			// draw pixel at (px, py) with object in r2

nextpixel:
	// go one pixel to right
	cmp 		px, finalX 					// check if pixel at the edge of cell
	addne 		px, #1 							// increment px by 1 if not
	addeq   	py, #1 							// go to next line if equal
	moveq   	px, initX 					// mov x back to far left of cell
	cmp 		py, finalY 					// check if y is at the bottom of cell
	blt 		CellLoop 						// keep drawing

    .unreq      initX
    .unreq      initY
	.unreq 		finalX
	.unreq 		finalY
    .unreq      object
    .unreq      px
    .unreq      py

    pop     {r3-r10, pc}

/*Checks what the object is
* Args
* r0: value of object
* Return
* r0: address of object to draw
*/
.globl CheckObject1
CheckObject1:
	push {r1-r2, lr}

	cmp 	r0, #0
	beq 	drawMario

	cmp 	r0, #1
	beq 	drawGroundBrick

	cmp 	r0, #2
	beq 	drawWallBrick

	cmp 	r0, #3
	beq 	drawFloatingBrick

	cmp 	r0, #4
	beq 	drawQuestionBlock

	cmp 	r0, #5
	beq 	drawPipeUp

	cmp 	r0, #6
	beq 	drawCoin

	cmp 	r0, #7
	beq 	drawGoomba

	cmp 	r0, #8
	beq 	drawKoopa

	cmp 	r0, #9
	beq 	drawEmpty

	cmp 	r0, #10
	beq 	drawPipe

	cmp 	r0, #11
	beq 	drawPipeBody

/*For each draw function...
* value of x and y are from the CheckObject function above
* r2 is loaded with the address of the .ascii data of the object
* drawObject is then called using these arguments
*/
drawMario:
	ldr 	r0, =Mario
	b			done

drawGroundBrick:
	ldr 	r0, =GroundBrick
	b			done

drawWallBrick:
	ldr 	r0, =GroundBrick // need to get ascii for wall
	b			done
drawFloatingBrick:

drawQuestionBlock:
	ldr 	r0, =QuestionBlock
	b			done
drawPipeUp:
	ldr 	r0, =PipeUp
	b			done

drawCoin:
	  ldr 	r0, =Coin 	// Coin background needs to be white
	b			done
drawGoomba:
	ldr 	r0, =Goomba 	// need new goomba code - background needs to be white
	b			done
drawKoopa:

drawEmpty:
	ldr 	r0, =Empty
	b			done

drawPipe:

drawPipeBody:

done:
	pop {r1-r2, pc}

/*Draws only the cells for moving
*Args:
* r0: int location in array
* r1: object to draw
*/
.globl drawMove
DrawMove:
		white 	.req 		r3     // store the value of whilt
		initX   .req    r4     // Left most posiiton of cell
    initY   .req    r5     // Top postion of cell
		finalX	.req    r6	   // Final position of x
		finalY	.req 		r7 	   // Final postion of y
		object  .req    r8     // address of object to be drawn
    px      .req    r9     // x coord of pixel relative to cell
    py      .req    r10    // y coord of pixel relative to cell


    push    {r3 - r10, lr}

		mov 		r11, #128 			 					// store temp value in r3
    add     initX, r11, r0, lsl #5 	// Calculate inital pos of x = (x * 32) + 128 = 128 + (x << 5)
		mov 		r11, #64
    add   	initY, r11, r1, lsl #5    	// Calculate inital pos of y = (y * 32) + 64
		add 		finalX, initX, #31 		// Calculate final pos of x for cell
		add 		finalY, initY, #32 		// Calculate final pos of y for cell
    mov     object, r2    				// saves address of the object
    mov     px, initX        			// initialize x coord of object
    mov     py, initY        			// initialize y coord of object
		ldr 		white, =white
		ldrh 		white, [white]

MoveLoop:

    mov     r0, px        			// move pixel value of x to r0
    mov     r1, py        			// move pixel value of y to r1
    ldrh    r2, [object], #2    // load object colour and increment to next colour
    cmp 		r2, white 					// if colour is white..
    beq 		nextpix						// skip drawing and go to next pixel

    bl      DrawPixel     			// draw pixel at (px, py) with object in r2

nextpix:
	// go one pixel to right
	cmp 		  px, finalX 					// check if pixel at the edge of cell
	addne 		px, #1 							// increment px by 1 if not
	addeq   	py, #1 							// go to next line if equal
	moveq   	px, initX 					// mov x back to far left of cell
	cmp 		  py, finalY 					// check if y is at the bottom of cell
	blt 		  MoveLoop 						// keep drawing

    .unreq      initX
    .unreq      initY
		.unreq 		finalX
		.unreq 		finalY
    .unreq      object
    .unreq      px
    .unreq      py

    pop     {r3-r10, pc}

/* r0 = x location to starting
 * r1 = y location for writing to starting
 * r2 = color of text
 * r3 = Address of text in asciz
 This is effectively the DrawChar Method but looped such that it will draw each char from the given address of text. Draws the text using the draw char method then increments a preset amount
 then also shifts to the next char stored in the address of the text in asciz.
*/

.globl DrawSentance
DrawSentance:
				address 		.req	r4
				px			.req  r5
				py 			.req	r6
				color 	.req  r7
				tmpChar	.req  r8
				counter .req  r9
				push {r4-r9, lr}

				mov  px,		r0
				mov  py,  	r1
				mov  color, r2
				mov  address,   r3

				mov  counter, #0
				ldrb	tmpChar, [address]
DrawLoop:
				mov  r3, tmpChar
				mov  r0, px
				mov  r1, py
				mov  r2, color
				bl   DrawChars
				add  counter, #1
				add  px, #10

				ldrb tmpChar, [address, counter]
				cmp  tmpChar, #0
				bne  DrawLoop

				.unreq address
				.unreq px
				.unreq py
				.unreq color
				.unreq tmpChar
				.unreq counter
				pop			{r4-r9, pc}


/*
	r0 = starting x
	r1 = starying y
	r2 = color of text
	r3 = character drawn
	from tutorial
*/

.globl DrawChars
DrawChars:

							chAdr		.req	r4
							px			.req	r5
							py			.req	r6
							row			.req	r7
							mask		.req	r8
							pxinit 	.req 	r9
							color   .req  r10
							push	{r4-r10, lr}

							ldr		chAdr,	=font		// load the address of the font map
							add		chAdr,	r3, lsl #4	// char address = font base + (char * 16)

							mov   color, 	r2
							mov   py,   	r1
							mov   pxinit, r0

charLoop$:
							mov		px,		pxinit			// init the X coordinate
							mov		mask,	#0x01		// set the bitmask to 1 in the LSB
							ldrb	row,	[chAdr], #1	// load the row byte, post increment chAdr
rowLoop$:
							tst		row,	mask		// test row byte against the bitmask
							beq		noPixel$

							mov		r0,		px
							mov		r1,		py
							mov   r2,   color
							bl		DrawPixel			// draw red pixel at (px, py)

noPixel$:
							add		px,		#1			// increment x coordinate by 1
							lsl		mask,	#1			// shift bitmask left by 1

							tst		mask,	#0x100		// test if the bitmask has shifted 8 times (test 9th bit)
							beq		rowLoop$

							add		py,		#1			// increment y coordinate by 1

							tst		chAdr,	#0xF
							bne		charLoop$			// loop back to charLoop$, unless address evenly divisibly by 16 (ie: at the next char)

							.unreq	chAdr
							.unreq	px
							.unreq	py
							.unreq	row
							.unreq	mask
							.unreq  pxinit
							.unreq  color

							pop		{r4-r10, pc}


.globl clearScreen
clearScreen:
            px                .req r4
            py                 .req r5
            push            {r4-r5, lr}

            mov           px, #0
            mov       		py, #0
clearScreenLoop:
            mov             r0, px
            mov             r1, py
            ldr             r2, =Empty
             bl        DrawObject

            add             py, #1
            cmp       py, #20
            blo                clearScreenLoop
            beq       nextLoop

nextLoop:
            add       px, #1
            cmp       px, #24
            mov       py, #0
            blo          clearScreenLoop
            beq                end1

end1:
            .unreq         px
            .unreq        py
            pop             {r4-r5, pc}



.section .data
.align 4

font: 	.incbin "font.bin"
white:	.hword 	0xffff
