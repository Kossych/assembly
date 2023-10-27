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
    mov al, [esi]
    cmp al, 45;Если первый символ '-', запомним, что A - отрицательное число
    jne inpA
    mov eax, 1
    mov [negA], eax
    inc esi
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
    
    mov eax, [A]
    cmp eax, 0;Если основание имеет значение 0 или 1, выводим соответствующий результат
    je A0
    cmp eax, 1
    je A0
    
;Считывание числа K
    inpK:
    mov al, [esi]
    cmp al, 10
    je endK
    mov eax, [K]
    mov ecx, 10
    mul ecx
    mov [K], eax
    mov al, [esi]
    mov [q], al
    mov eax, [q]
    cmp eax, 48
    jl pp
    cmp eax, 57
    jg pp
    sub eax, 48
    add [K], eax
    jo pp
    inc esi
    jmp inpK
    endK:
    
    mov eax, [K]
    cmp eax, 0;Если степень равна нулю, то результат равен 1
    je A1
    cmp eax, 1;Если степень равна единице, выводим основание
    je A2
    
    
    mov ebx, [A]
    mov [a], ebx;В ячейке a сохраним изначальное значение основания
    mov ebx, [K]
    
    circle2:;Цикл по значению степени (k-1 итераций)
    cmp ebx, 1 ; ebx= k, еах = a
    je next2
    xor eax, eax
    mov ecx, [A]
    mov edx, [a]
    circle1:;Вложенный цикл по изначальному значению основания (выполняется a раз). В нем складываем основание a раз, получая новое значение основания. 
    cmp edx, 0
    je next1
    add eax, ecx
    jo pp;Проверка на переполнение
    dec edx
    jmp circle1
    next1:
    mov [A], eax
    dec ebx
    jmp circle2
    next2:
    
    xor ebx, ebx
    xor eax, eax
    
    mov edx, [negA]
    cmp edx,0 ;Если основание отрицательное
    je pr
        mov eax, [K]
        mov ebx, 2
        div ebx
        cmp edx, 1;Проверяем степень, если она четная, то выводим '-'
        jne pr
            mov eax, 4
            mov ebx, 1
            mov ecx, t
            mov edx, 1
            int 0x80
    pr:
    mov eax, [A]
    jmp Print
    
A0:
    mov eax, 48
    mov [z], eax
    mov eax, 4
    mov ebx, 1
    mov ecx, z
    mov edx, 1
    int 0x80
    jmp end
    
A1:
    mov eax, 49
    mov [z], eax
    mov eax, 4
    mov ebx, 1
    mov ecx, z
    mov edx, 4
    int 0x80
    jmp end

A2:
    mov eax, [A]
    
Print:
    xor ebx, ebx
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
    cmp ebx, 0; если число, которое нужно вывести, равнялось нулю, то необходимо закинуть его в стек и увеличить счетчик на 1, так как в предыдущем цикле эта цифра не считалась.
    jne stack1
    push eax
    inc ebx
    mov [i], ebx
    stack1:
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
    a dd 0
    negA dd 0
    K dd 0
    res dd 0
    q dd 0
    n dd 0
    i dd 0
    z dd 0
    p dd 'Переполнение или неверные значения'
    t dd '-'
segment .bss

    input resb 1