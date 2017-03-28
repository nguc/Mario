.section .data
	lives: 	.byte 3
.section .text

.globl loseLife
loseLife:
	numLives 	.req r4

	push 	{r4, lr}

	ldr 	r3, =lives
	ldrb 	numLives, [r3]

	cmp 	numLives, #0
	beq 	GameOver

	sub 	numLives, #1
	strb 	numLives, [r3]

	.unreq  numLives

	pop 	{r4, pc}

.globl CollectCoin
CollectCoin:


.globl GainPoints
GainPoints:
	