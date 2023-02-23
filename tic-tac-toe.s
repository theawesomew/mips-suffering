# A tic-tac-toe game with an AI opponent made entirely in MIPS-32

main:
	la $a0, state

	push $ra

	jal render_board

	pop $ra

	li $v0, 0
	jr $ra

render_board:
# $a0 -> the current board state
# - - -   
# - - -
# - - -

render_board__prologue:
	li $t0, 0
	
render_board__body:

render_board__loop_row:
	beq $t0, 3, render_board__epilogue

	li $t1, 0

	j render_board__loop_col
	
render_board__loop_col:
	beq $t1, 3, render_board__loop_col_end

	mul $t2, $t0, 3
	add $t2, $t2, $t1

	push $a0

	add $a0, $a0, $t2

	lb $a0, 0($a0)

	push $ra
	jal render_piece
	pop $ra

	pop $a0

    add $t1, $t1, 1

	j render_board__loop_col

render_board__loop_col_end:
    push $a0

	li $v0, 11
	li $a0, '\n'
	syscall

	pop $a0

    add $t0, $t0, 1

    j render_board__loop_row

render_board__epilogue:
	jr $ra

render_piece:

render_piece__prologue:

render_piece__body:
	beq $a0, 0, render_piece__blank
	beq $a0, 1, render_piece__cross
	beq $a0, 2, render_piece__nought

render_piece__blank:

	li $v0, 11
	li $a0, ' '
	syscall

	li $v0, 11
	li $a0, '-'
	syscall

	j render_piece__epilogue


render_piece__cross:
	li $v0, 11
	li $a0, ' '
	syscall

	li $v0, 11
	li $a0, 'X'
	syscall

	j render_piece__epilogue

render_piece__nought:
	li $v0, 11
	li $a0, ' '
	syscall

	li $v0, 11
	li $a0, 'O'
	syscall

	j render_piece__epilogue

render_piece__epilogue:
	jr $ra

.data
	state: .byte 0, 0, 0, 0, 0, 0, 0, 0, 0
    test: .asciiz "GOT HERE!"