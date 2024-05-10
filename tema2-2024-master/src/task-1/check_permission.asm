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

    mov edx, eax           
    shr edx, 24            
    mov ecx, edx           

    mov edx, eax           
    and edx, 0xFFFFFF

    mov edi, dword [ant_permissions + 4 * ecx]

    and edi, edx          
    cmp edi, edx           
    je .end             

    mov dword [ebx], 0 
    jmp end_check_permission

.end:
    mov dword [ebx], 1    

end_check_permission:
    ;; Your code ends here
    
    ;; DO NOT MODIFY

    popa
    leave
    ret
    
    ;; DO NOT MODIFY