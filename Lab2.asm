section .text

global _start

_start:

    mov eax, 3
    mov ebx, 0
    mov edx, 255 
    mov ecx, input  
    int 0x80
    
    xor esi, esi
    xor edi, edi
    xor eax, eax
    xor ebx, ebx
    mov esi, input
    
inpX:;В этой задаче не считываем число, а только проверяем на то, отрицательное ли оно и корректно ли записано
    mov al, [esi]
    cmp al, 45;если текущий символ - минус, значит число отрицательное
    jne _negX
    cmp edx, 1;если встречаем второй минус - ввод некорректный
    je pp
    mov edx, 1;отмечаем отрицательность числа
    inc esi
    jmp inpX
_negX:
    cmp al, 10;если текущий символ - перевод строки, значит считали число
    je endX ;проверяем, является ли символ цифрой
    cmp al, 48
    jl pp
    cmp al, 57
    jg pp
    inc esi
    jmp inpX
    
endX:
    inc esi
    
inpY:
    mov al, [esi]
    cmp al, 45
    jne _negY
    cmp ebx, 1
    je pp
    mov ebx, 1
    inc esi
    jmp inpY
_negY:
    cmp al, 10
    je endY 
    cmp al, 48
    jl pp
    cmp al, 57
    jg pp
    inc esi
    jmp inpY
    
endY:
    
    
    ;теперь зная каковы X и Y (положительные или отрицательные), находим нужную четверть
    
    cmp edx, 1 ; если edx (ось X) равна 1, значит X отрицательный (если 0, то положительный)
    je negX
    cmp ebx, 1 ; если ebx (ось Y) равна 1, значит Y отрицательный (если 0, то положительный)
    je negY
    mov ecx, 1
    jmp res
negY:
    mov ecx, 4
    jmp res
negX:
    cmp ebx, 1
    je negY2
    mov ecx, 2
    jmp res
negY2:
    mov ecx, 3
    
res:
    
    add ecx, 48
    mov [k], ecx
    
    mov eax, 4
    mov ebx, 1
    mov ecx, k
    mov edx, 1
    int 0x80
    
    jmp end

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
    p dd 'Некорректный ввод'
    k dd 0

segment .bss

    input resb 1
