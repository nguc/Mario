.section .data
.align 4

/*
completely new class that is later used to handl the entire menu stuff for the game
*/
.globl MainMenu
MainMenu:
      .asciz "Main Menu"

.globl StartGame
StartGame:
      .asciz "Start Game"

.globl QuitGame
QuitGame:
      .asciz "Quit Game"

.globl GameName
GameName:
      .asciz "Mario SNES"

.globl RestartGame
RestartGame:
      .asciz "Restart Game"

.globl Credits
Credits:
      .asciz "By Chi and Abel"

.globl loseCondition
loseCondition:
      .asciz "YOU LOSE, HOW IS THAT POSSIBLE?"
.globl loseCondition2
loseCondition2:
      .asciz "THE ENEMIES DON'T EVEN MOVE"

.globl winCondition
winCondition:
      .asciz "YOU WIN, HOW IS THAT NOT POSSIBLE?"

.globl winCondition2
winCondition2:
      .asciz "THE ENEMIES DON'T EVEN MOVE"

.globl Score
Score:
      .asciz "Score: "

.globl Life
Life:
      .asciz "Life: "

.globl Coins
Coins:
      .asciz "Coins: "

.globl ScoreINT
ScoreINT:
      .byte 48,48,48,48,0             // 0 at the stops the drawing

.globl CoinINT
CoinINT:
      .byte 48, 48, 0

.globl LifeCount
LifeCount:
      .byte 51,0



/*
This entire segment of code prints out the Main menu stuff at preset PIXEL locations, not the set gameboard stuff. This is probably why everytime when I use the tmpClear function
At the end of this method, the screen is frozen on black. But anyways, the way the function works is by loading the hardcoated pixel locations, the hardcoated color, and the memory address
containng the asciz sentence. These then are all passed as methods to the DrawSentance method in Drawing.s which is effectively the DrawChar method that the TA gave us from the demo but looped.

*/
.section .text
.globl DrawMenu
DrawMenu:
      push {lr}
      //Draw StartGame
      mov    r0, #500
      mov    r1, #300
      ldr    r2, =0xAFA0
      ldr    r3, =StartGame
      bl     DrawSentance

      //Draw our names
      mov    r0, #500
      mov    r1, #600
      ldr    r2, =0xAFA0
      ldr    r3, =Credits
      bl     DrawSentance

      //Draw QuitGame
      mov    r0, #500
      mov    r1, #400
      ldr    r2, =0xAFA0
      ldr    r3, =QuitGame
      bl     DrawSentance

      pop {pc}


.globl startGameSelect
startGameSelect:
        push {lr}
        ldr  r0, =300
        ldr  r1, =300
        ldr  r2, =0xAFA0
        ldr  r3, =15
        bl   starIndicator

        ldr  r0, =300
        ldr  r1, =400
        ldr  r2, =0x0000
        ldr  r3, =15
        bl   starIndicator
        pop {pc}


.globl quitGameSelect
quitGameSelect:
        push {lr}
        ldr  r0, =300
        ldr  r1, =400
        ldr  r2, =0xAFA0
        ldr  r3, =15
        bl   starIndicator

        ldr  r0, =300
        ldr  r1, =300
        ldr  r2, =0x0000
        ldr  r3, =15
        bl   starIndicator
        pop  {pc}

.globl  restartGameSelect
restartGameSelect:
        push {lr}
        ldr  r0, =300
        ldr  r1, =300
        ldr  r2, =0xAFA0
        ldr  r3, =15
        bl   starIndicator

        ldr  r0, =300
        ldr  r1, =400
        ldr  r2, =0x0000
        ldr  r3, =15
        bl   starIndicator
        pop {pc}


.globl drawScoreBoard
drawScoreBoard:
        push {lr}
        mov    r0, #200
        mov    r1, #64
        ldr    r2, =0xFFFF
        ldr    r3, =Score
        bl     DrawSentance
        bl    drawUpdatedScore


        mov    r0, #400
        mov    r1, #64
        ldr    r2, =0xFFFF
        ldr    r3, =Coins
        bl     DrawSentance
        bl    drawUpdatedCoins


        mov    r0, #600
        mov    r1, #64
        ldr    r2, =0xFFFF
        ldr    r3, =Life
        bl     DrawSentance
        bl     drawUpdatedLives

        pop {pc}


.globl mainMenuControlRead
mainMenuControlRead:
              updown    .req  r4
              push {r4,lr}
              mov  updown, #0               // initialize at startGame
readLoop:

              bl  read_SNES
              ldr r1, =0xffff     //Test if anything has been pressed
              teq r0, r1          //if they are equal, it means nothing is pressed
              beq readLoop

              mov   r2, #1
              lsl   r2, #8                  // align bit to [8]
              and   r3, r0, r2              // test if "A" was presed
              teq   r3, #0
              beq  mainMenuAPress

              mov   r2, #1
              lsl   r2, #4                  // align bit to [4]
              and   r3, r0, r2              // test if "up" was presed
              teq   r3, #0                  //up
              beq  up

              mov   r2, #1
              lsl   r2, #5                  // align bit to [5]
              and   r3, r0, r2              // test if "down" was presed
              teq   r3, #0
              beq  down                     //down

      up:
              mov     updown, #0
              bl      startGameSelect
              b       readLoop
      down:
              mov     updown, #1
              bl      quitGameSelect
              b       readLoop


mainMenuAPress:
              cmp  updown, #0               // if updown = 0 then start game else quit game
              bne  mainMenuQuitGame

              mov  r0, #0
              b    mainMenuDone

mainMenuQuitGame:
              mov r0, #1
              b   mainMenuDone

mainMenuDone:
              .unreq updown
              pop   {r4,pc}


        /*
        Used to show the indicator of what is selected, start game or quit game.
        */
        .globl starIndicator
        starIndicator:
        		    px     .req  r4
        		    py     .req  r5
        		    color  .req  r6
        		    size  .req  r7
        		    push {r4-r7, lr}

        		    mov   px, r0
        		    mov   py, r1
        		    mov   color, r2
        		    mov   size, r3

        		    ldr   r3, = '*'
        		    mov   r0, px
        		    mov   r1, py
        		    mov   r2, color
        		    bl    DrawChars

        		    .unreq px
        		    .unreq py
        		    .unreq color
        		    .unreq size
        		    pop {r4-r7,pc}
/*==========================================================================
Everything Below this is for the INGAME Menu.
*/

.globl DrawInGAMEMenu
DrawInGAMEMenu:
      push {lr}
      //Draw RestartGame
      mov    r0, #500
      mov    r1, #300
      ldr    r2, =0xAFA0
      ldr    r3, =RestartGame
      bl     DrawSentance

      //Draw QuitGame
      mov    r0, #500
      mov    r1, #400
      ldr    r2, =0xAFA0
      ldr    r3, =QuitGame
      bl     DrawSentance

      pop {pc}

.globl inGameMenuControlRead
inGameMenuControlRead:
      updown1    .req  r4
      push {r4,lr}
      mov  updown1, #0               // initialize at RestartGame

readLoop1:
      mov 	r0, #1
      lsl 	r0, #18
      bl 		wait                    // make a delay so user doesnt double click

      bl  read_SNES
      ldr r1, =0xffff     //Test if anything has been pressed
      teq r0, r1          //if they are equal, it means nothing is pressed
      beq readLoop1

      mov   r2, #1                  //align bit to [3]
      lsl   r2, #3                  // test if "Start" was pressed
      and   r3, r0, r2
      teq   r3, #0
      beq   continueGame

      mov   r2, #1
      lsl   r2, #8                  // align bit to [8]
      and   r3, r0, r2              // test if "A" was pressed
      teq   r3, #0
      beq   inGameMenuA

      mov   r2, #1
      lsl   r2, #4                  // align bit to [4]
      and   r3, r0, r2              // test if "up" was presed
      teq   r3, #0                  //up
      beq   inGameup

      mov   r2, #1
      lsl   r2, #5                  // align bit to [5]
      and   r3, r0, r2              // test if "down" was presed
      teq   r3, #0
      beq   inGamedown                     //down

      b     readLoop1

inGameup:
      mov     updown1, #0
      bl      restartGameSelect
      b       readLoop1

inGamedown:
      mov     updown1, #1
      bl      quitGameSelect
      b       readLoop1

inGameMenuA:
      cmp  updown1, #0               // if updown = 0 then start game else quit game
      bne  inGameMenuQuitGame

      mov  r0, #0
      b    inGameMenuDone

inGameMenuQuitGame:
      mov  r0, #1
      b    inGameMenuDone

continueGame:     // redraws the current game screen the way it was
      bl    GetCurrentGameState
      bl    DrawGameScreen
      b     startGame

inGameMenuDone:
      .unreq updown1
      pop   {r4,pc}



// updates the score when mario kills an enemy collects a coin
.globl ScoreEvent
ScoreEvent:
      push  {lr}

      mov    r0, #264
      mov    r1, #64
      ldr    r2, =0x0000
      ldr    r3, =ScoreINT
      bl     DrawSentance

      ldr r0, =ScoreINT
      ldrb r1, [r0, #1]
      ldrb r2, [r0]
      cmp  r1, #57
      moveq r1, #48
      addeq r2, #1
      addne r1, #1

      strb  r1, [r0,#1]
      strb  r2, [r0]


      bl  drawUpdatedScore
      pop {pc}

.globl CollectCoin
CollectCoin:
      push  {lr}

      mov    r0, #464
      mov    r1, #64
      ldr    r2, =0x0000
      ldr    r3, =CoinINT
      bl     DrawSentance

      ldr r0, =CoinINT
      ldrb r1, [r0, #1]
      ldrb r2, [r0]
      cmp  r1, #57
      moveq r1, #48
      addeq r2, #1
      addne r1, #1

      strb  r1, [r0,#1]
      strb  r2, [r0]

      bl  drawUpdatedCoins
      pop {pc}
/* Method to keep track of lives - need to update number of lives and draw to screen*/
.globl lostLife
lostLife:
    push  {lr}

    mov    r0, #664
    mov    r1, #64
    ldr    r2, =0x0000
    ldr    r3, =LifeCount
    bl     DrawSentance

    ldr   r3, =LifeCount
    ldrb  r1, [r3]
    cmp   r1, #48
    subgt r1, #1
    beq   GameOver
    strb  r1, [r3]

    bl    drawUpdatedLives

doneDeath:
    pop   {pc}

GameOver:
    bl clearScreen


    ldr   r0, =LifeCount
    ldrb  r1, [r0]
    mov   r1, #51
    strb  r1, [r0]

    ldr   r0, =ScoreINT
    ldrb  r1, [r0]
    ldrb  r2, [r0,#1]
    mov   r2, #48
    mov   r1, #48
    strb  r1, [r0]
    strb  r1, [r0,#1]

    mov    r0, #400
    mov    r1, #300
    ldr    r2, =0xAFA0
    ldr    r3, =loseCondition
    bl     DrawSentance

    mov    r0, #400
    mov    r1, #400
    ldr    r2, =0xAFA0
    ldr    r3, =loseCondition2
    bl     DrawSentance

    ldr    r0, =3000000
    bl     wait
    b      startingPoint


drawUpdatedLives:
    push {lr}

    // draw new score
    mov    r0, #664
    mov    r1, #64
    ldr    r2, =0xAFA0
    ldr    r3, =LifeCount
    bl     DrawSentance
    pop  {pc}

drawUpdatedScore:
      push {lr}

      // draw new score
      mov    r0, #264
      mov    r1, #64
      ldr    r2, =0xAFA0
      ldr    r3, =ScoreINT
      bl     DrawSentance
      pop  {pc}

drawUpdatedCoins:
      push {lr}

      // draw new coin collected amount
      mov    r0, #464
      mov    r1, #64
      ldr    r2, =0xAFA0
      ldr    r3, =CoinINT
      bl     DrawSentance
      pop  {pc}

.globl WinGame
WinGame:
      bl clearScreen
      mov    r0, #400
      mov    r1, #300
      ldr    r2, =0xAFA0
      ldr    r3, =winCondition
      bl     DrawSentance

      mov    r0, #400
      mov    r1, #400
      ldr    r2, =0xAFA0
      ldr    r3, =winCondition2
      bl     DrawSentance

      ldr    r0, =3000000
      bl     wait
      b      startingPoint

// checks if mario is in the right stage, then checks if he is in position to win (door)
.globl checkWinCondition
checkWinCondition:
    stage     .req r4
    x         .req r5
    y         .req r6

    push  {r4-r6, lr}

    ldr   r3, =CurrentGameState               // check if mario is in stage 3
    ldrb  stage, [r3]
    cmp   stage, #3
    bne   doneCheck

    ldr   r3, =MarioPosition                  // check if mario is at the door (21,17)
    ldrb  x, [r3]
    ldrb  y, [r3, #1]
    cmp   x, #21
    bne   doneCheck
    cmp   y, #17
    bne   doneCheck

    bl    WinGame

doneCheck:
    .unreq  stage
    .unreq  x
    .unreq  y

    pop   {r4-r6, pc}
