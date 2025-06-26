; this project is insane. lets just say that for now.

nl = 10
maxLen = 256
n = 8
m = 32

Point struct
x byte -1
y byte -1
Point ends

Snake struct
pos Point maxLen dup ({})
lenght byte 0
Snake ends

.data
    dir byte 2
    gameoverText byte "Gameover, score:%d", nl, 0
    cls byte "cls", 0
    strTest byte "%c", 0
    strInt byte "%d", nl, 0
    snake Snake {}
    grid byte n dup (m dup("#"))
    foods Point {1, 2}, {5, 2}, {1, 20}, {2, 12}, {1, 23}, {0, 15}, {4, 23}, {6, 12}, {6, 0}, {1, 0}, {4, 26}, {7, 11}, {3, 20}, {2, 18}, {4, 11}, {1, 13}, {5, 26}, {7, 31}, {7, 9}, {3, 24}, {0, 28}, {7, 28}, {3, 13}, {1, 17}, {5, 18}, {1, 18}, {5, 16}, {5, 0}, {5, 7}, {2, 25}, {2, 20}, {6, 0}, {6, 21}, {7, 29}, {7, 10}, {5, 31}, {6, 29}, {4, 26}, {2, 5}, {3, 24}
    curFood byte 0

.code
    externdef printf:proc
    externdef system:proc
    externdef Sleep:proc
    externdef getch:proc
    externdef kbhit:proc

public asmMain
asmMain proc
    sub rsp, 56

    mov snake.lenght, 1
    mov snake.pos[0].x, 5
    mov snake.pos[0].y, 5 

    ; game's main loop
    start:
    ; clear the terminal
    lea rcx, cls
    call system

    ; check if the food has been eaten
    mov r13b, snake.pos[0].x
    mov r15, 0
    mov r15b, curFood
    cmp r13b, foods[r15].x
    jne nc
    mov r13b, snake.pos[0].y
    cmp r13b, foods[r15].y
    jne nc
    ; add the snake lenght and snake part 
    mov r14b, snake.lenght
    inc r14b
    mov snake.lenght, r14b

    mov r14, 0
    mov r14b, snake.lenght
    shl r14b, 1

    begadding:
    cmp r14b, 0
    je doneadding
    mov r15b, snake.pos[r14-2].x
    mov snake.pos[r14].x, r15b
    mov r15b, snake.pos[r14-2].y
    mov snake.pos[r14].y, r15b
    dec r14b
    dec r14b
    jmp begadding

    doneadding:
    ; go to the next food position.
    mov r14b, curFood
    inc r14b
    inc r14b
    cmp r14b, 76
    jne nadd
    mov r14b, 0
    nadd:
    mov curFood, r14b
    jmp donemoving

    nc:
    ; check for input
    call kbhit
    cmp rax, 1
    jne d4

    ; get user input for movement
    call getch
    cmp rax, 'a'
    jne d1
    mov r13b, 2
    cmp r13b, dir
    je d1
    ; move left
    mov r14b, 1
    mov dir, r14b
    d1:
    cmp rax, 'd'
    jne d2
    mov r13b, 1
    cmp r13b, dir
    je d2
    ; move right
    mov r14b, 2
    mov dir, r14b
    d2:
    cmp rax, 'w'
    jne d3
    mov r13b, 4
    cmp r13b, dir
    je d3
    ; move up
    mov r14b, 3
    mov dir, r14b
    d3:
    cmp rax, 's'
    jne d4
    mov r13b, 3
    cmp r13b, dir
    je d4
    ; move down
    mov r14b, 4
    mov dir, r14b
    d4:


    ; move the snake
    ; moving the body
    mov r14, 0
    mov r14b, snake.lenght
    shl r14b, 1

    begmoving:
    cmp r14b, 0
    je donemoving
    mov r15b, snake.pos[r14-2].x
    mov snake.pos[r14].x, r15b
    mov r15b, snake.pos[r14-2].y
    mov snake.pos[r14].y, r15b
    dec r14b
    dec r14b
    jmp begmoving

    donemoving:
    ; moving the head
    mov r14b, dir
    cmp r14b, 1
    jne c1
    ; move left
    mov r13b, snake.pos[0].y
    dec r13b
    cmp r13b, -1
    jne n1
    add r13b, m
    n1:
    mov snake.pos[0].y, r13b
    c1:
    cmp r14b, 2
    jne c2
    ; move right
    mov r13b, snake.pos[0].y
    inc r13b
    cmp r13b, m
    jne n2
    sub r13b, m
    n2:
    mov snake.pos[0].y, r13b
    c2:
    cmp r14b, 3
    jne c3
    ; move up
    mov r13b, snake.pos[0].x
    dec r13b
    cmp r13b, -1
    jne n3
    add r13b, n 
    n3:
    mov snake.pos[0].x, r13b
    c3:
    cmp r14b, 4
    jne c4
    ; move down
    mov r13b, snake.pos[0].x
    inc r13b
    cmp r13b, n
    jne n4
    sub r13b, n
    n4:
    mov snake.pos[0].x, r13b
    c4:

    ; update the grid
    ; put the food
    mov r14b, 'F'
    mov r13, 0
    mov r15, 0
    mov r15b, curFood
    mov r13b, foods[r15].x
    shl r13b, 5
    add r13b, foods[r15].y
    mov grid[r13], r14b

    ; put the snake
    mov r15, 0
    mov r15b, snake.lenght
    begputsnake:
    cmp r15b, 0
    je endputsnake
    mov r14b, 'S'
    mov r13, 0
    mov r13b, snake.pos[r15*2 - 2].x
    shl r13b, 5
    add r13b, snake.pos[r15*2 - 2].y
    mov grid[r13], r14b
    dec r15b
    jmp begputsnake

    endputsnake:
    ; print the grid
    mov r14, 0
    begout:
    cmp r14, n
    je donefor

    ; inner loop
    mov r13, 0
    beg:
    cmp r13, m
    je done
    lea rcx, strTest
    mov r15, r14
    imul r15, m
    mov rdx, qword ptr grid[r13 + r15]
    call printf
    inc r13
    jmp beg

    done:
    lea rcx, strTest
    mov rdx, nl
    call printf
    inc r14
    jmp begout
    donefor:

    lea rcx, strInt
    xor rdx, rdx
    mov dl, snake.lenght
    call printf

    ; wait for a second.
    mov rcx, 200
    call Sleep

    ; check if gameover
    mov r15, 1
    beggameover:
    cmp r15b, snake.lenght
    je endgameover
    mov r14, 0
    beggameover2:
    cmp r14, r15
    je endgameover2

    mov r13b, snake.pos[r14*2].x
    cmp r13b, snake.pos[r15*2].x
    jne gonext
    mov r13b, snake.pos[r14*2].y
    cmp r13b, snake.pos[r15*2].y
    jne gonext

    jmp gameover

    gonext:
    inc r14
    jmp beggameover2
    endgameover2:
    inc r15
    jmp beggameover
    endgameover:
    ; restore the grid
    ; remove the snake
    mov r15, 0
    mov r15b, snake.lenght
    begremsnake:
    cmp r15b, 0
    je endremsnake
    mov r14b, '#'
    mov r13, 0
    mov r13b, snake.pos[r15*2 - 2].x
    shl r13b, 5
    add r13b, snake.pos[r15*2 - 2].y
    mov grid[r13], r14b
    dec r15b
    jmp begremsnake

    endremsnake:

    ; remove the food
    mov r14b, '#'
    mov r13, 0
    mov r15, 0
    mov r15b, curFood
    mov r13b, foods[r15].x
    shl r13b, 5
    add r13b, foods[r15].y
    mov grid[r13], r14b

    jmp start

    gameover:
    lea rcx, gameoverText
    xor rdx, rdx
    mov dl, snake.lenght
    call printf

    add rsp, 56
    ret
asmMain endp
end