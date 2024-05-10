section .rodata
	global sbox
	global num_rounds
	sbox db 126, 3, 45, 32, 174, 104, 173, 250, 46, 141, 209, 96, 230, 155, 197, 56, 19, 88, 50, 137, 229, 38, 16, 76, 37, 89, 55, 51, 165, 213, 66, 225, 118, 58, 142, 184, 148, 102, 217, 119, 249, 133, 105, 99, 161, 160, 190, 208, 172, 131, 219, 181, 248, 242, 93, 18, 112, 150, 186, 90, 81, 82, 215, 83, 21, 162, 144, 24, 117, 17, 14, 10, 156, 63, 238, 54, 188, 77, 169, 49, 147, 218, 177, 239, 143, 92, 101, 187, 221, 247, 140, 108, 94, 211, 252, 36, 75, 103, 5, 65, 251, 115, 246, 200, 125, 13, 48, 62, 107, 171, 205, 124, 199, 214, 224, 22, 27, 210, 179, 132, 201, 28, 236, 41, 243, 233, 60, 39, 183, 127, 203, 153, 255, 222, 85, 35, 30, 151, 130, 78, 109, 253, 64, 34, 220, 240, 159, 170, 86, 91, 212, 52, 1, 180, 11, 228, 15, 157, 226, 84, 114, 2, 231, 106, 8, 43, 23, 68, 164, 12, 232, 204, 6, 198, 33, 152, 227, 136, 29, 4, 121, 139, 59, 31, 25, 53, 73, 175, 178, 110, 193, 216, 95, 245, 61, 97, 71, 158, 9, 72, 194, 196, 189, 195, 44, 129, 154, 168, 116, 135, 7, 69, 120, 166, 20, 244, 192, 235, 223, 128, 98, 146, 47, 134, 234, 100, 237, 74, 138, 206, 149, 26, 40, 113, 111, 79, 145, 42, 191, 87, 254, 163, 167, 207, 185, 67, 57, 202, 123, 182, 176, 70, 241, 80, 122, 0
	num_rounds dd 10

section .text
	global treyfer_crypt
	global treyfer_dcrypt

; void treyfer_crypt(char text[8], char key[8]);
treyfer_crypt:
	;; DO NOT MODIFY
	push ebp
	mov ebp, esp
	pusha

	mov esi, [ebp + 8] ; plaintext
	mov edi, [ebp + 12] ; key	
	;; DO NOT MODIFY
	;; FREESTYLE STARTS HERE
	;; TODO implement treyfer_crypt

	mov ecx, [num_rounds] ; numărul de runde

    ; Inițializăm t cu primul byte al textului de criptat
	xor ebx, ebx
    mov bl, byte [esi]

    .round_loop:
        ; Iterăm prin fiecare byte din blocul de text
        xor edx, edx  ; edx = index (indexul byte-ului curent din bloc)
        .byte_loop:
            ; Adunăm byte-ul corespunzător al cheii la t
            add bl, byte [edi + edx]

            ; Aplicăm S-box pe t
            mov bl, [sbox + ebx]

			; Obținem adresa byte-ului următor din bloc
            mov eax, edx
            inc eax
            and eax, 7 ; efectuăm operația modulo 8 (deoarece avem 8 bytes în bloc)

            ; Adunăm la t valoarea din blocul de text corespunzătoare următorului byte
            add bl, byte [esi + eax]

			; Rotăm t la stânga cu 1 bit
            rol bl, 1

            ; Actualizăm byte-ul următor din bloc
            mov byte [esi + eax], bl

            ; Incrementăm indexul
            inc edx

            ; Verificăm dacă am terminat blocul
            cmp edx, 8
            jne .byte_loop

        ; Decrementăm numărul de runde și verificăm dacă am terminat
        dec ecx
        jnz .round_loop

    	;; FREESTYLE ENDS HERE
	;; DO NOT MODIFY
	popa
	leave
	ret

; void treyfer_dcrypt(char text[8], char key[8]);
treyfer_dcrypt:
	;; DO NOT MODIFY
	push ebp
	mov ebp, esp
	pusha
	;; DO NOT MODIFY
	;; FREESTYLE STARTS HERE
	;; TODO implement treyfer_dcrypt
	mov esi, [ebp + 8] ; plaintext
	mov edi, [ebp + 12] ; key
	mov ecx, [num_rounds] ; numărul de runde

for_runde:
	; Setăm contorul la 7 pentru a începe decriptarea
	mov ebx, 7

	for_decriptare:
		; Se încarcă un byte din bloc
		mov dl, byte [esi + ebx]
		; Se adaugă un byte din cheie
		add dl, byte [edi + ebx]
		; Se aplică substituția S-box
		mov dl, byte[sbox + edx]

		; Verificăm dacă am parcurs toți cei 8 bytes
		cmp ebx, 7
		jnz decriptare

		; Pentru primul byte din bloc, se aplică operațiile suplimentare
		mov al, byte [esi]
		ror al, 1 
		sub al, dl
		mov byte [esi], al
		jmp final

		decriptare:
		; Se preia byte-ul următor din bloc
		mov al, byte [esi + ebx + 1]
		; Se rotește în dreapta cu o poziție
		ror al, 1 
		; Se scade valoarea din S-box
		sub al, dl
		; Se stochează rezultatul în bloc
		mov byte [esi + ebx + 1], al

	final: 	
	; Decrementăm contorul
	dec ebx
	; Verificăm dacă am ajuns la finalul blocului
	cmp ebx, 0
	jge for_decriptare

	; Decrementăm contorul de runde
	dec ecx
	; Verificăm dacă mai sunt runde de procesat
	jnz for_runde


	;; FREESTYLE ENDS HERE
	;; DO NOT MODIFY
	popa
	leave
	ret

