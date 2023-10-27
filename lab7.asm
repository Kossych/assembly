global _start
section .data
X dd 1, 1, 1, 1, 1, 1, 2 ;Массив
T dd 1
k dd 0
i dd 0
mend dd 0
res dd 0
s dd ' '
f dd 'Массив пустой'
countX dd 7 ;Размер массива X
countT dd 8 ;Размер массива T
section .text
_start:
    mov esi, X;Указатель на массив
    mov eax, 0;Счетчик X
    mov ebx, -1;Счетчик T
    
    
    main:
    inc ebx
    cmp ebx, [countT]
    je end
    mov eax, -1
    
    main1:
    inc eax
    cmp eax, [countX]
    jge main
    mov ecx, X[4*eax]
    mov edx, T[4*ebx]
    cmp ecx, edx
    jne main1
    call offset
    jmp main1
    

    end:
    mov esi, X
    mov edi, 0
    end1:
    cmp edi, [countX]
    je end2
    mov eax,[esi]
    call Print
    add esi, 4
    inc edi
    jmp end1
    end2:
    mov ecx, [countX]
    cmp ecx, 0
    jne end3
        mov eax, 4
        mov ebx, 1
        mov ecx, f
        mov edx, 25
        int 0x80
    end3:
    mov eax, 1
    int 0x80
    
    offset:
        mov edx, eax
        inc edx
        @2:
        cmp edx, [countX]
        je @1
        mov ecx, [esi+4*edx]	; Тут происходит
        mov [esi+4*edx-4], ecx		; смещение
        inc edx
        jmp @2
        @1:
        xor edx, edx
        mov esi, X
        mov ecx, [countX]
        dec ecx
        mov [countX], ecx
        dec eax
    ret
    
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
        jle endPr
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
        endPr:;вывод пробела и выход из вывода
        mov eax, 4
        mov ebx, 1
        mov ecx, s
        mov edx, 1
        int 0x80
        xor eax, eax
        xor ebx, ebx
        xor edx, edx
        xor ecx, ecx
    ret