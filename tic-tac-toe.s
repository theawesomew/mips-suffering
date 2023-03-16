# A tic-tac-toe game with an AI opponent made entirely in MIPS-32

main:

main__loop:
	li $a1, 2
	la $a0, state
	
	push $ra
	jal has_won
	pop $ra 

    beq $v0, 1, main__exit

    push $ra
    jal is_board_full
    pop $ra

    beq $v0, 1, main__exit

    push $ra
    jal render_board
    pop $ra

	j main__loop
	
main__exit:
	li $v0, 0
	jr $ra

render_board:
# $a0 - the current board state
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

has_won:
# $a1 -> the player we're checking if they have won
# $a0 -> the current board state

# 001010100 -> 84
# 100010001 -> 273 
# 100100100 -> 293
# 010010010 -> 146
# 001001001 -> 73 
# 111000000 -> 448
# 000111000 -> 56
# 000000111 -> 7

has_won__prologue:
    # $t0 -> the current index
    # $t1 -> the bitstate of the board
    li $t0, 0
    li $t1, 0
    li $t3, 1

has_won__body:
    
has_won__create_bitstate:
    beq $t0, 9, has_won__evaluate

    push $a0

    add $a0, $a0, $t0
    lb $a0, 0($a0)

    beq $a0, $a1, has_won__add_value_to_bitstate 

    pop $a0

    add $t0, $t0, 1

    j has_won__create_bitstate

has_won__add_value_to_bitstate:
    sllv $t4, $t3, $t0
    add $t1, $t1, $t4
    add $t0, $t0, 1
    pop $a0
    j has_won__create_bitstate

has_won__evaluate:
    andi $t4, $t1, 7
    beq $t4, 7, has_won__true

    andi $t4, $t1, 56
    beq $t4, 56, has_won__true

    andi $t4, $t1, 73
    beq $t4, 73, has_won__true

    andi $t4, $t1, 84
    beq $t4, 84, has_won__true

    andi $t4, $t1, 146
    beq $t4, 146, has_won__true 

    andi $t4, $t1, 273
    beq $t4, 273, has_won__true

    andi $t4, $t1, 293
    beq $t4, 293, has_won__true

    andi $t4, $t1, 446
    beq $t4, 446, has_won__true    

has_won__false:
    li $v0, 0
    jr $ra

has_won__true:
    li $v0, 1
    jr $ra

is_board_full:
    # $a0 -> current board state

    is_board_full__prologue:
        li $t0, 0

    is_board_full__body:
    
    is_board_full__loop:
        beq $t0, 9, is_board_full__true

        push $a0

        add $a0, $a0, $t0
        lb $t1, 0($a0)

        beq $t1, 0, is_board_full__false

        pop $a0

        add $t0, $t0, 1

        j is_board_full__loop

    is_board_full__true:
        li $v0, 1
        jr $ra

    is_board_full__false:
        li $v0, 0
        jr $ra

make_move:
# $a0 -> index which needs to be changed
# $a1 -> the current board state
# $a2 -> the value which the board state needs to be changed to
make_move__prologue:

make_move__body:
    blt $a0, 0, make_move__fail
    bgt $a0, 8, make_move__fail

    add $t0, $a1, $a0
    lb $t0, 0($t0)

    bne $t0, 0, make_move__fail

    add $t0, $a1, $a0
    sb $a2, 0($t0)

make_move__success:
    li $v0, 1
    j make_move__epilogue

make_move__fail:
    li $v0, 0

make_move__epilogue:
    jr $ra

.data
	state: .byte 0, 0, 0, 0, 0, 0, 0, 0, 0
