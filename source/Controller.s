
.section .text

// initialize the GPIO lines of Latch, clock, and data as either ouput or input lines
.globl Init_GPIO
Init_GPIO:
    push {lr}
    		//set GPIO pin 9 to output (LATCH)
    		ldr		r3, =0x3F200000				// setfunc sel 0 address
    		ldr		r0, [r3]					// get value of funcsel 0
    		mov		r1, #7						// b0111
    		lsl		r1, #27						// prepare to clear bits 27-29
    		bic		r0, r1						// clear bits
    		mov		r2, #1						// output code (001)
    		lsl		r2, #27						// shift r2 to line 9 (GPIO 9)
    		orr		r0, r2						// set line 9 to output
    		str		r0, [r3]					// write back to func sel 0


    		//set GPIO pin 11 to output (CLOCK)
    		ldr		r3, =0x3F200004				// set funcsel 1 address
    		ldr		r0, [r3]					// get value of funcsel 1
    		mov		r1, #7						// b0111
    		lsl		r1, #3						// prepare to clear bits 3-5
    		bic		r0, r1						// clear bits
    		mov		r2, #1						// output code (001)
    		lsl		r2, #3						// shift r2 to line 1 (GPIO 11)
    		orr		r0, r2						// set line 1 to output
    		str		r0, [r3]					// write back to func sel 1


    		//set GPIO pin 10 to input (DATA)
        ldr   r3, =0x3F200004
    		ldr		r0, [r3]					// get value of funcsel 1
    		mov		r1, #7						// b0111
    		bic		r0, r1						// clear bits for line 1, input (000)
    		str		r0, [r3]					// write back to func sel 1

    pop {pc}


// wrties a bit to the latch line
// args: r0 = 1 or 0 to write
write_latch:
        push {r3, lr}

        ldr r3, =0x3F200000 				// get address for function select registers

        mov r1, #1							// set up mask
        lsl r1, #9 							// align to pin 9

        teq r0, #0 							// check if arg passed is 0
        streq r1, [r3, #40] 				// write 1 to GPSCLR0 if r0 is 0
        strne r1, [r3, #28] 					// write 1 to GPSET0 if r0 is 1

      pop {r3, pc}


// writes a bit to the clock line
// args: r0 = 1 or 0 to write
write_clock:
        push {r3, lr}

        ldr 	r3, =0x3F200000				// get address of function select register

        mov 	r1, #1						// set up mask
        lsl 	r1, #11 					// align to pin 11

        teq 	r0, #0 						// check if the arg passed in is 0
        streq 	r1, [r3, #40] 				// write 1 to GPSCLR0 if r0 is 0
        strne 	r1, [r3, #28] 				// write 1 to GPSET0 if r0 is 1

      pop {r3, pc}



// Read data line to see if pin is a 0 or 1
// return: r0 contains 0 or 1 depending on pin
read_data:
        push {r3, lr}
        ldr r3, =0x3F200000 					// get base address of Function Select register
        ldr r2, [r3, #52] 						// get value from level register 0

        mov r1, #1								// data is in pin #10
        lsl r1, #10 							// align to pin 10

        tst r2, r1 								// AND mask the line
        moveq r0, #0    						// return 0 if bit read is 0
        movne r0, #1   						 	// return 1 if bit read is 1

        pop {r3, pc}


// Tells system to wait for a specified amount of time in microseconds
// args: r0 holds number of microseconds to wait
.globl wait
wait:
        push {r1-r3, lr}

        ldr r1, =0x3F003004 					// address of CLO
        ldr r2, [r1]							// load value of CLO
        add r2, r0        						// current time + delay = when we want program to continue running again

waitLoop:
        ldr r3, [r1] 							// load current value of CLO
        cmp r2, r3 								// compare current time to delay time
        bhi waitLoop      				// stop when CLO = r2

        pop {r1-r3, pc}


// get info from the controller on which buttons were pressed
// return: r0, a string of 16 bits where 0 = button pressed
.globl read_SNES
read_SNES:
        push {r8,r10, lr }

        mov r8, #0      							// r8 is buttons register is initialized to 0

        mov r0, #1									// pass arg = 1
        bl write_clock								// write 1 to clock line

        mov r0, #1									// pass arg = 1
        bl write_latch								// write 1 to latch line

        mov r0, #12 								// pass arg = 12
        bl wait 									// wait 12 microseconds

        mov r0, #0 									// pass arg = 0
        bl write_latch 								// write 0 to latch line

        mov r10, #0 								// initialize i = 0

pulseLoop:
        mov r0, #6 									// pass arg = 6
        bl wait 									// wait 6 microseconds

        mov r0, #0 									// pass arg = 0
        bl write_clock 								// write 0

        mov r0, #6 									// arg = 6
        bl wait 									// wait 6 microseconds

        bl read_data 								// read data line, return value in r0

        lsl r0, r10 								// align return bit with the proper button
        orr r8, r8, r0 							// add new bit to the button register

        mov r0, #1 									// pass arg = 1
        bl write_clock 								// write 1 to clock

        add r10, #1 								// i++
        cmp r10, #16 								// check if i >= 16
        blt pulseLoop 								// if i < 16 keep looping

        mov r0, r8 									// return buttons pressed

        pop {r8, r10, pc}



/*
// Main function //
.globl InitController
InitController:                     // initialize SNES controller
        push  {lr}

        mov   r0, #9
        mov   r1, #1
        bl 		Init_GPIO

        mov   r0, #10
        mov   r1, #0
        bl 		Init_GPIO

        mov   r0, #11
        mov   r1, #1
        bl 		Init_GPIO

        pop  {pc}
*/
/*
.globl ListenToController
ListenToController:
        //push {r0-r8,lr}

        mov 	r0, #1
        lsl 	r0, #18
        bl 		wait                       			// make a delay so button input isnt read so fast

check:
        bl 		read_SNES								// get info from controller, return in r0

        // read output from controller to check if a button was pressed
    	  ldr 	r1, =0xffff 						// value if no buttons pressed
        teq		r8, r1 								  // test if no buttons were pressed
        beq   check                 // keep checkin the controller
*/
/*
* r3 bit that checks which button is being pressed
*/
/*
ButtonPress:
        // B is being pressed
        mov   r3, #1
        and   r7, r8, r3
        teq   r7, #0
        bne 	checkY

checkY:
        lsl   r3, #1
        and   r7, r8, r3
        teq   r7, #0
        bne 	checkSelect
        //ldr 	r0, =Ymsg


checkSelect:
        lsl   r3, #1
        and   r7, r8, r3
        teq   r7, #0
        bne 	checkStart
        //ldr 	r0, =Selmsg


checkStart:		/// go to terminate  ///
        lsl   r3, #1
        and   r7, r8, r3
        teq   r7, #0
       	//beq		haltLoop$

checkUp:
        lsl   r3, #1
        and   r7, r8, r3
        teq   r7, #0
        bne 	checkDown
        //ldr 	r0, =Upmsg


checkDown:
        lsl   r3, #1
        and   r7, r8, r3
        teq   r7, #0
   		  bne 	checkLeft
        //ldr 	r0, =Downmsg


checkLeft:
          lsl   r3, #1
          and   r7, r8, r3
          teq   r7, #0
          bne 	checkRight     // check next button if Left not pressed
          /*
          Get position of mario
          draw saved object at mario's potion
          save data of square to the left of mario
          draw mario in this square
          */

/*
checkRight:
        lsl   r3, #1
        and   r7, r8, r3
        teq   r7, #0
        bne 	checkA
        //bl    MoveRight


checkA:
        lsl   r3, #1
        and   r7, r8, r3
        teq   r7, #0
        bne 	checkX



checkX:
        lsl   r3, #1
        and   r7, r8, r3
        teq   r7, #0							// test
        bne 	checkLTrig



checkLTrig:
        lsl   r3, #1
        and   r7, r8, r3
        teq   r7, #0
        bne 	checkRTrig


checkRTrig:
        lsl   r3, #1
        and   r7, r8, r3
        teq   r7, #0
        bne   ListenToController

        b ListenToController

        //pop {r0-r8, lr}
*/
.section .data
