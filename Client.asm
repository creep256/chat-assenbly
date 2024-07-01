section .data
    server_ip       db '127.0.0.1', 0    
    server_port     dw 8080               
    buffer_size     equ 1024

section .bss
    client_sock     resb 4                
    server_addr     resb 16               
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

    mov     word [server_addr], 2       
    mov     word [server_addr + 2], bx  
    mov     eax, 0x0100007F             
    mov     dword [server_addr + 4], eax
    mov     qword [server_addr + 8], 0  

    mov     rax, 42                   
    mov     rdi, ebx                 
    lea     rsi, [server_addr]         
    mov     rdx, 16                    
    syscall

send_loop:
    mov     rax, 0                     
    mov     rdi, 0                     
    lea     rsi, [buffer]              
    mov     rdx, buffer_size           
    syscall

    ; message server
    mov     rax, 64                   
    mov     rdi, ebx                   
    lea     rsi, [buffer]             
    mov     rdx, buffer_size           
    mov     r10, 0                     
    syscall

    ; Repeat send 
    jmp     send_loop
