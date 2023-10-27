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
;Считывание числа N
inpA:
    mov al, [esi]
    cmp al, 10;если текущий символ - перевод строки, значит считали число
    je endA
    mov eax, [N]
    mov ecx, 10
    mul ecx;с каждой последующей цифрой увеличиваем разряд (умножаем на 10)
    mov [N], eax 
    mov al, [esi];костыль для записи в 4 байтный регистр
    mov [q], al
    mov eax, [q]
    cmp eax, 48;Проверка символа (цифры находятся в промежутке 48-57)
    jl pp
    cmp eax, 57
    jg pp
    sub eax, 48; преобразование в цифру
    add [N], eax
    jo pp;проверка на переполнение
    inc esi;идем на след символ в строке
    jmp inpA
endA:
    
    xor eax, eax
    xor ebx, ebx
    xor edx, edx
    xor ecx, ecx
    
    mov eax, 1;результат возведения двойки в степень (2^k)
    mov ecx, 0; степень двойки (k)
    mov edx, [N]
    
    
ch1:
    cmp eax, edx;пока 2^k<N, повышаем степень k на 1
    jge ch2
    add eax, eax; умножаем число на два (результат повышения степени на 1)
    inc ecx; повышение степени k на 1
    jmp ch1
ch2:
    cmp eax, edx; если 2^k равно N, значит k - искомое число
    je ch3
    jmp pp; иначе число N не является степенью числа два
ch3:
    
    mov eax, ecx

    
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
    N dd 0
    res dd 0
    i dd 0
    q dd 0
    p dd 'Переполнение или неверные значения'
segment .bss

input resb 1