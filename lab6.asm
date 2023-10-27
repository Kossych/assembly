global _start
section .data
mas dd 2,-2,2,-1,2 ;Массив
p dd 'Successed'
k dd 0
mend dd 0
count dd 5 ;Размер массива
section .text
_start:
    mov esi, mas;Указатель на массив
    mov edi, 0;Счетчик, с помощью которого проходим по массиву
    mov ecx, [count];Размер массива (позиция конца памяти)
    
    mov eax, [esi+4*edi]
    cmp eax, 0
    jl main2
    jmp main1
    
    main1:;Ответвление для положительного знака
    inc edi;Переход на следующий элемент
    cmp edi,[count];Проверка на пределы массива
    je end
    mov eax, [esi+4*edi]
    cmp eax, 0;Узнаем знак элемента
    jl main2;Если знаки чередуются, переход на другую ветку
    jmp out;Обнаружено совпадение знаков
    
    main2:;Ответвление для отрицательного знака
    inc edi
    cmp edi,[count]
    je end
    mov eax, [esi+4*edi]
    cmp eax, 0
    jge main1
    jmp out
    
    
    out:
    mov eax, 4
    mov ebx, 1
    mov ecx, p
    mov edx, 9
    int 0x80

    
    
    end:
    mov eax, 1
    int 0x80