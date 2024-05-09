%include "../include/io.mac"

extern ant_permissions

extern printf
global check_permission

section .text

check_permission:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     eax, [ebp + 8]  ; id and permission
    mov     ebx, [ebp + 12] ; address to return the result
    ;; DO NOT MODIFY
   
    ;; Your code starts here

    ;; Extract the ant ID and the requested permission
    mov     ecx, eax        ; Copy the argument to ecx
    shr     ecx, 24         ; Shift right by 24 bits to get the ant ID
    and     eax, 0xFFFFFF   ; Mask out the ant ID to get the requested permission bits

    ;; Load the ant permissions into a register
    mov     edx, DWORD [ant_permissions + ecx * 4]

    ;; Check if the ant has permission for each requested room
    mov     esi, 0          ; Counter for the number of allowed rooms
check_loop:
    test    eax, eax        ; Test if any permissions are left
    jz      exit_loop       ; If all permissions have been checked, exit the loop
    shr     eax, 1          ; Shift the least significant bit to the rightmost position
    jc      permission_set  ; If the bit was set, the ant has permission for this room
    jmp     continue_loop   ; Otherwise, continue to the next room

permission_set:
    test    edx, 1          ; Test if the ant has permission for this room
    jz      exit_loop       ; If not, exit the loop with result 0
    inc     esi             ; Increment the counter of allowed rooms

continue_loop:
    shr     edx, 1          ; Shift the least significant bit of ant permissions to the right
    jmp     check_loop      ; Continue checking the next room

exit_loop:
    ;; Check if the number of allowed rooms matches the requested ones
    cmp     esi, 0          ; Compare the counter of allowed rooms with 0
    jz      no_permission   ; If no rooms are allowed, jump to no_permission
    mov     DWORD [ebx], 1  ; Write 1 to the result address (permission granted)
    jmp     end_function    ; Jump to the end of the function

no_permission:
    mov     DWORD [ebx], 0  ; Write 0 to the result address (permission denied)

end_function:

    ;; Your code ends here
    
    ;; DO NOT MODIFY

    popa
    leave
    ret
    
    ;; DO NOT MODIFY
