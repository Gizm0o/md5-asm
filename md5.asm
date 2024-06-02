section .data
    msg db 'hello', 0

section .bss
    buffer resb 64
    A resd 1
    B resd 1
    C resd 1
    D resd 1
    count resd 1
    len resd 1

section .text
    global _start

_start:
    ; Initialize A, B, C, D
    mov dword [A], 0x67452301
    mov dword [B], 0xEFCDAB89
    mov dword [C], 0x98BADCFE
    mov dword [D], 0x10325476

    ; Step 1: Append Padding Bits
    mov ecx, 64
    mov esi, buffer
    mov byte [esi], 0x80  ; Append a single '1' bit
    inc esi
    dec ecx
    xor eax, eax
    rep stosb  ; Fill the rest with zeros

    ; Step 2: Append Length
    mov eax, [count]  ; Get the count of bytes
    mov dword [len], eax
    shl eax, 3  ; Convert bytes to bits
    mov dword [esi], eax  ; Append the length
    add esi, 4
    mov eax, [count+4]
    mov dword [len+4], eax
    shl eax, 3
    mov dword [esi], eax

    ; Step 3: Initialize MD Buffer
    mov ebx, 0
    mov ecx, 4
    mov esi, buffer
init_md_buffer_loop:
    mov eax, [ebx]
    mov [esi], eax
    add ebx, 4
    add esi, 4
    loop init_md_buffer_loop

    ; Step 4: Process Message in 16-Word Blocks
    mov esi, buffer
process_message_loop:
    mov edx, esi
    mov eax, [A]
    mov ebx, [B]
    mov ecx, [C]
    mov edi, [D]

    ; Round 1
    ; FF(A, B, C, D, M[0], 7, 0xd76aa478)
    mov eax, ebx
    add eax, [esi]
    add eax, 0xd76aa478
    shl eax, 7
    add eax, [A]
    mov [A], edi
    mov edi, ecx
    mov ecx, ebx
    mov ebx, eax

    ; FF(D, A, B, C, M[1], 12, 0xe8c7b756)
    mov eax, ebx
    add eax, [esi+4]
    add eax, 0xe8c7b756
    shl eax, 12
    add eax, [D]
    mov [D], edi
    mov edi, ecx
    mov ecx, ebx
    mov ebx, eax

    ; FF(C, D, A, B, M[2], 17, 0x242070db)
    mov eax, ebx
    add eax, [esi+8]
    add eax, 0x242070db
    shl eax, 17
    add eax, [C]
    mov [C], edi
    mov edi, ecx
    mov ecx, ebx
    mov ebx, eax

    ; FF(B, C, D, A, M[3], 22, 0xc1bdceee)
    mov eax, ebx
    add eax, [esi+12]
    add eax, 0xc1bdceee
    shl eax, 22
    add eax, [B]
    mov [B], edi
    mov edi, ecx
    mov ecx, ebx
    mov ebx, eax

    ; Round 2
    ; GG(A, B, C, D, M[4], 7, 0xf57c0faf)
    mov eax, ebx
    add eax, [esi+16]
    add eax, 0xf57c0faf
    shl eax, 7
    add eax, [A]
    mov [A], edi
    mov edi, ecx
    mov ecx, ebx
    mov ebx, eax

    ; GG(D, A, B, C, M[5], 12, 0x4787c62a)
    mov eax, ebx
    add eax, [esi+20]
    add eax, 0x4787c62a
    shl eax, 12
    add eax, [D]
    mov [D], edi
    mov edi, ecx
    mov ecx, ebx
    mov ebx, eax

    ; GG(C, D, A, B, M[6], 17, 0xa8304613)
    mov eax, ebx
    add eax, [esi+24]
    add eax, 0xa8304613
    shl eax, 17
    add eax, [C]
    mov [C], edi
    mov edi, ecx
    mov ecx, ebx
    mov ebx, eax

    ; GG(B, C, D, A, M[7], 22, 0xfd469501)
    mov eax, ebx
    add eax, [esi+28]
    add eax, 0xfd469501
    shl eax, 22
    add eax, [B]
    mov [B], edi
    mov edi, ecx
    mov ecx, ebx
    mov ebx, eax

    ; Round 3
    ; HH(A, B, C, D, M[8], 7, 0x698098d8)
    mov eax, ebx
    add eax, [esi+32]
    add eax, 0x698098d8
    shl eax, 7
    add eax, [A]
    mov [A], edi
    mov edi, ecx
    mov ecx, ebx
    mov ebx, eax

    ; HH(D, A, B, C, M[9], 12, 0x8b44f7af)
    mov eax, ebx
    add eax, [esi+36]
    add eax, 0x8b44f7af
    shl eax, 12
    add eax, [D]
    mov [D], edi
    mov edi, ecx
    mov ecx, ebx
    mov ebx, eax

    ; HH(C, D, A, B, M[10], 17, 0xffff5bb1)
    mov eax, ebx
    add eax, [esi+40]
    add eax, 0xffff5bb1
    shl eax, 17
    add eax, [C]
    mov [C], edi
    mov edi, ecx
    mov ecx, ebx
    mov ebx, eax

    ; HH(B, C, D, A, M[11], 22, 0x895cd7be)
    mov eax, ebx
    add eax, [esi+44]
    add eax, 0x895cd7be
    shl eax, 22
    add eax, [B]
    mov [B], edi
    mov edi, ecx
    mov ecx, ebx
    mov ebx, eax

    ; Round 4
    ; II(A, B, C, D, M[12], 7, 0x6b901122)
    mov eax, ebx
    add eax, [esi+48]
    add eax, 0x6b901122
    shl eax, 7
    add eax, [A]
    mov [A], edi
    mov edi, ecx
    mov ecx, ebx
    mov ebx, eax

    ; II(D, A, B, C, M[13], 12, 0xfd987193)
    mov eax, ebx
    add eax, [esi+52]
    add eax, 0xfd987193
    shl eax, 12
    add eax, [D]
    mov [D], edi
    mov edi, ecx
    mov ecx, ebx
    mov ebx, eax

    ; II(C, D, A, B, M[14], 17, 0xa679438e)
    mov eax, ebx
    add eax, [esi+56]
    add eax, 0xa679438e
    shl eax, 17
    add eax, [C]
    mov [C], edi
    mov edi, ecx
    mov ecx, ebx
    mov ebx, eax

    ; II(B, C, D, A, M[15], 22, 0x49b40821)
    mov eax, ebx
    add eax, [esi+60]
    add eax, 0x49b40821
    shl eax, 22
    add eax, [B]
    mov [B], edi
    mov edi, ecx
    mov ecx, ebx
    mov ebx, eax

    ; Update MD Buffer
    add [A], eax
    add [B], ebx
    add [C], ecx
    add [D], edi

    ; Check if we have processed the entire message
    add dword [count], 64
    cmp dword [count], 64
    jb process_message_loop

    ; Output the hash value
    mov eax, [A]
    mov ebx, [B]
    mov ecx, [C]
    mov edx, [D]
    ; Output the hash values in little-endian order
    ; Output A
    mov esi, msg
    mov edi, 32  ; Buffer for hex representation of hash
    call hex_str
    ; Output B
    mov esi, msg+8
    add edi, 8
    call hex_str
    ; Output C
    mov esi, msg+16
    add edi, 8
    call hex_str
    ; Output D
    mov esi, msg+24
    add edi, 8
    call hex_str
    ; Output newline
    mov esi, newline
    mov edi, 64
    call print_string

    ; Terminate the program
    mov eax, 60  ; syscall number for exit
    xor edi, edi  ; exit code 0
    syscall

hex_str:
    movzx ecx, byte [esi] ; Load byte from string
    mov dl, cl ; Copy byte
    and dl, 0xF ; Isolate low nibble
    cmp dl, 10 ; If less than 10, print directly
    jl  print_char
    add dl, 'A' - 10 ; Otherwise, add offset for letters
print_char:
    mov [edi], dl ; Store character in buffer
    inc edi ; Move buffer pointer
    shr ecx, 4 ; Move high nibble to low
    mov dl, cl ; Copy high nibble
    and dl, 0xF ; Isolate low nibble
    cmp dl, 10 ; If less than 10, print directly
    jl  print_char
    add dl, 'A' - 10 ; Otherwise, add offset for letters
    jmp print_char ; Print character

print_string:
    mov ecx, 8 ; Set loop counter
next_char:
    movzx eax, byte [esi] ; Load character from string
    mov [edi], eax ; Store character in buffer
    inc esi ; Move to next character
    inc edi ; Move buffer pointer
    loop next_char ; Repeat for all characters
    ret

section .data
    newline db 10, 0 ; Newline character and null terminator