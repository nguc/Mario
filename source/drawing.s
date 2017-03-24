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


.section .data
white:	.hword 	0xffff
