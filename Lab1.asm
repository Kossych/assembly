

section .text

global _start

_start:
;Ввод строки
    mov eax, 3
    mov ebx, 0
    mov edx, 255 
    mov ecx, input  
    int 0x80
    
    xor esi, esi
    xor edi, edi
    xor eax, eax
    mov esi, input
;Считывание числа A
inpA:
    mov al, [esi]
    cmp al, 10;если текущий символ - перевод строки, значит считали число
    je endA
    mov eax, [A]
    mov ecx, 10
    mul ecx;с каждой последующей цифрой увеличиваем разряд (умножаем на 10)
    mov [A], eax 
    mov al, [esi];костыль для записи в 4 байтный регистр
    mov [q], al
    mov eax, [q]
    cmp eax, 48;Проверка символа (цифры находятся в промежутке 48-57)
    jl pp
    cmp eax, 57
    jg pp
    sub eax, 48; преобразование в цифру
    add [A], eax
    jo pp;проверка на переполнение
    inc esi;идем на след символ в строке
    jmp inpA
endA:
    inc esi
;Считывание числа B
inpB:
    mov al, [esi]
    cmp al, 10
    je endB
    mov eax, [B]
    mov ecx, 10
    mul ecx
    mov [B], eax
    mov al, [esi]
    mov [q], al
    mov eax, [q]
    cmp eax, 48
    jl pp
    cmp eax, 57
    jg pp
    sub eax, 48
    add [B], eax
    jo pp
    inc esi
    jmp inpB
endB:
    
    
    mov eax, [A]
    mov ebx, [B]
    cmp eax, ebx;число A должно быть больше B
    jl pp
    div ebx
    
    xor ebx, ebx
    xor edx, edx
    xor ecx, ecx
    
stack: ; разбиение числа на разряды и складывание в стэк
    cmp eax, 0
    jle endst
    xor edx, edx
    mov ecx, 10
    div ecx
    push edx ; младший разряд(остаток от деления) в стэк
    inc ebx ; считываем кол-во разрядов
    jmp stack
endst:
    mov [i], ebx
    
    stack1: ; вывод числа из стека, и вывод его на экран
    mov ecx, [i]
    cmp ecx, 0
    jle end
    pop edx;достаем цифру
    add edx, 48;преобразовываем в символ
    mov [res], edx
    mov eax, 4
    mov ebx, 1
    mov ecx, res
    mov edx, 1
    int 0x80
    mov eax, [i]
    dec eax
    mov [i], eax
    jmp stack1

    
pp:
    mov eax, 4
    mov ebx, 1
    mov ecx, p
    mov edx, 65
    int 0x80
    
end:
    mov eax, 1
    int 0x80
    
    
section .data
    A dd 0
    B dd 0
    res dd 0
    i dd 0
    q dd 0
    p dd 'Переполнение или неверные значения'
segment .bss

    input resb 1
    

