section .data
    server_port     dw 8080         
    backlog         dd 5          
    buffer_size     equ 1024

section .bss
    server_sock     resb 4          
    client_sock     resb 4          
    client_addr     resb 16        
    buffer          resb buffer_size 

section .text
    global _start

_start:
    mov     rax, 41               
    mov     rdi, 2                 
    mov     rsi, 1                 
    mov     rdx, 0                  
    syscall
    mov     ebx, eax                

    mov     word [client_addr], 2   
    mov     word [client_addr + 2], bx 
    mov     dword [client_addr + 4], 0 
    mov     qword [client_addr + 8], 0 

    mov     rax, 49                 
    mov     rdi, ebx              
    lea     rsi, [client_addr]     
    mov     rdx, 16                 
    syscall

    mov     rax, 50                 
    mov     rdi, ebx               
    mov     rsi, [backlog]        
    syscall

accept_loop:
    mov     rax, 43                 
    mov     rdi, ebx                
    lea     rsi, [client_addr]     
    lea     rdx, [client_sock]     
    syscall


    mov     r10, 0                  
    mov     rax, 63                 
    mov     rdi, [client_sock]      
    lea     rsi, [buffer]          
    mov     rdx, buffer_size        
    syscall

    ; Print message
    mov     rax, 1                  
    mov     rdi, 1                  
    lea     rsi, [buffer]           
    mov     rdx, buffer_size        
    syscall

    ; Repeat  loop
    jmp     accept_loop
