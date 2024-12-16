.model small
.stack 100h

.data
    array db 100 dup(?)    
    array_len db ?       
    max db ?            
    sum dw 0            
    new_line db 0Dh, 0Ah, '$' 
    msg_len db 'Enter array length: $'
    msg_num db 'Enter numbers: $'
    msg_max db 'Max value is: $'
    msg_sum db 'Sum of values is: $'
    msg_array db 'The numbers in ascending order are: $'
    msg_odd db 'Odd numbers are: $'
    msg_even db 'Even numbers are: $'

.code
main:
    ; Set up data segment
    mov ax, @data
    mov ds, ax
    mov es, ax

    ; Prompt for array length
    lea dx, msg_len
    mov ah, 09h             
    int 21h

    ; Read array length from user
    mov ah, 1               
    int 21h
    sub al, '0'
    mov array_len, al
    
    ; New line
    lea dx, new_line
    mov ah, 09h
    int 21h
    
    ; Prompt for numbers
    lea dx, msg_num
    mov ah, 09h          
    int 21h

    ; Set up counter
    mov cl, array_len      

    ; Read numbers from user
    lea si, array           ; Point to array

read_input:
    mov ah, 1               ; int 21h, function 1: read character
    int 21h
    sub al, '0'
    mov [si], al
    inc si
    dec cl
    jnz read_input

    ; Sort the array using Bubble Sort
    lea si, array
    mov ch, array_len       ; Set outer loop counter
    dec ch

bubble_sort:
    mov cl, ch              ; Set inner loop counter
    mov di, si

inner_loop:
    mov al, [di]
    mov bl, [di+1]
    cmp al, bl
    jle no_swap
    ; Swap values
    mov [di], bl
    mov [di+1], al
no_swap:
    inc di
    dec cl
    jnz inner_loop
    dec ch
    jnz bubble_sort
    
    ; New line
    lea dx, new_line
    mov ah, 09h
    int 21h
    
    ; Display the array values message
    lea dx, msg_array
    mov ah, 09h             ; int 21h, function 09h: display string
    int 21h

    ; Display the sorted array values
    lea si, array
    mov cl, array_len

print_array:
    mov al, [si]
    add al, '0'             ; Convert to ASCII
    mov ah, 2
    mov dl, al
    int 21h
    ; Print space between numbers
    mov dl, ' '
    int 21h
    inc si
    dec cl
    jnz print_array

    ; New line
    lea dx, new_line
    mov ah, 09h
    int 21h

    ; Display odd numbers message
    lea dx, msg_odd
    mov ah, 09h             ; int 21h, function 09h: display string
    int 21h

    ; Display odd numbers
    lea si, array
    mov cl, array_len

print_odd:
    mov al, [si]
    test al, 1              ; Check if the number is odd
    jz skip_odd
    add al, '0'             ; Convert to ASCII
    mov ah, 2
    mov dl, al
    int 21h
    ; Print space between numbers
    mov dl, ' '
    int 21h
skip_odd:
    inc si
    dec cl
    jnz print_odd

    ; New line
    lea dx, new_line
    mov ah, 09h
    int 21h

    ; Display even numbers message
    lea dx, msg_even
    mov ah, 09h             ; int 21h, function 09h: display string
    int 21h

    ; Display even numbers
    lea si, array
    mov cl, array_len

print_even:
    mov al, [si]
    test al, 1              ; Check if the number is even
    jnz skip_even
    add al, '0'             ; Convert to ASCII
    mov ah, 2
    mov dl, al
    int 21h
    ; Print space between numbers
    mov dl, ' '
    int 21h
skip_even:
    inc si
    dec cl
    jnz print_even

    ; New line
    lea dx, new_line
    mov ah, 09h
    int 21h

    ; Initialize sum
    xor ax, ax
    lea si, array
    mov cl, array_len

calculate_sum:
    mov al, [si]
    cbw                    ; Convert byte to word to extend sign to AX
    add sum, ax            ; Add to sum
    inc si
    dec cl
    jnz calculate_sum

    ; Find maximum
    lea si, array
    mov al, [si]
    mov max, al
    mov cl, array_len
    dec cl                  ; Start with the second element
    inc si
    
    find_max:
    mov al, [si]
    cmp al, max
    jle skip_max
    mov max, al
skip_max:
    inc si
    dec cl
    jnz find_max

    ; Display max value message
    lea dx, msg_max
    mov ah, 09h             ; int 21h, function 09h: display string
    int 21h

    ; Display the max value
    mov dl, max
    add dl, '0'
    mov ah, 2               ; int 21h, function 2: display character
    int 21h

    ; New line
    lea dx, new_line
    mov ah, 09h
    int 21h

    ; Display sum value message
    lea dx, msg_sum
    mov ah, 09h             ; int 21h, function 09h: display string
    int 21h

    ; Convert sum to ASCII and display
    mov ax, sum
    call print_number

    ; New line
    lea dx, new_line
    mov ah, 09h
    int 21h

    ; End the program
    mov ah, 4Ch             ; int 21h, function 4Ch: terminate program
    int 21h

print_number:
    ; Print number in AX
    mov bx, 10              ; Divisor for division operation
    xor cx, cx              ; Clear CX
.convert_loop:
    xor dx, dx              ; Clear DX for division
    div bx                  ; Divide AX by 10, result in AX, remainder in DX
    push dx                 ; Push remainder (digit) onto stack
    inc cx                  ; Increment digit count
    cmp ax, 0
    jne .convert_loop

.print_loop:
    pop dx                  ; Pop digit from stack
    add dl, '0'             ; Convert digit to ASCII
    mov ah, 2
    int 21h
    loop .print_loop
    ret

end main