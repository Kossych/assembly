global _start
section .data
X dd 1, 1, 6, 9
  dd 1, 3, 6, 123
  dd 1, 2, 4, 10
  dd 1, 3, 5, 10
k dd 0
i dd 0
mend dd 0
res dd 0
s dd ' '
m dd 4
n dd 4
section .text
_start:
    mov eax, [n]
    mov ebx, 4
    mul ebx
    mov edi, eax;Значение для смещения на следующую строку
    
    mov esi, X;Указатель на массив Х
    mov eax, 0
    mov ebx, 0;сдвиг по элементам в строке
    mov edx, -1;сдвиг по строкам
    mov ecx, 0;кол-во особых элементов
    

    
    
    main:
    inc edx;Повышаем позицию строки, на которой находимся
    cmp edx, [m]
    je end
    call SumRow;Подсчет суммы
    call Check;Проверка на наличие "особого" элемента
    add esi, edi;Переход на след строку
    jmp main
    
    end:
    mov eax, ecx
    call Print
    mov eax, 1
    int 0x80
    
   
    
    
    SumRow:;Вычисление суммы в строке
        mov ebx, -1
        mainSR:
        inc ebx;Переход на след элемент
        cmp ebx, [n]
        je endSR
        add eax, [esi+ebx*4]
        jmp mainSR
        endSR:
    ret
    
    Check:;Проверка на наличие "особого" элемента
        mov ebx, -1
        mainС:
        inc ebx;Переход на след элемент
        cmp ebx, [n]
        je endС2
        sub eax, [esi+ebx*4];Если элемент особый, то если вычесть из суммы его значение, то элемент будет больше отсеченной суммы
        cmp eax, [esi+ebx*4];В строке может быть только один особый элемент, следовательно при его обнаружении повышаем кол-во особых элементов на 1 и выходим из процедуры
        jl endC
        add eax, [esi+ebx*4];В случае если элемент не особый, вовзвращаем значение суммы обратно
        jmp mainС
        endC:
        inc ecx
        endС2:
        xor eax, eax
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
