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
;Считывание числа Z
inpZ:
    mov al, [esi]
    cmp al, 10;если текущий символ - перевод строки, значит считали число
    je endZ
    mov eax, [Z]
    mov ecx, 10
    mul ecx;с каждой последующей цифрой увеличиваем разряд (умножаем на 10)
    mov [Z], eax 
    mov al, [esi];костыль для записи в 4 байтный регистр
    mov [q], al
    mov eax, [q]
    cmp eax, 48;Проверка символа (цифры находятся в промежутке 48-57)
    jl pp
    cmp eax, 57
    jg pp
    sub eax, 48; преобразование в цифру
    add [Z], eax
    jo pp;проверка на переполнение
    inc esi;идем на след символ в строке
    jmp inpZ
endZ:

    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx
    xor esi, esi
    mov esi, -1

a: ;основной цикл, в нем увеличивается первый счетчик (первое число в паре). Если его квадрат больше Z, выход из цикла
    xor edi, edi ;обнуляем второй счетчик (второе число в паре). После того как обнаружили нужную пару, необходимо обнулить второй счетчик.
    inc esi
    mov eax, esi
    mul esi;находим квадрат первого числа в паре
    cmp eax, [Z]
    jg end
    mov ecx, eax; в ecx складываем сумму квадратов чисел.
b:;вложенный цикл, в нем увеличиваем второй счетчик (второе число в паре). Если нашли пару/получившаяся сумма больше Z, выходим обратно в основной цикл.
    mov eax, edi
    mul edi
    add ecx, eax;находим сумму квадратов
    cmp ecx, [Z]
    jne b1
        mov eax, esi
        call Print;выводим первое число
        mov eax, edi
        call Print;выводим второе число
        call nn;переход на следующую строку
        jmp a;конец
b1:
    cmp ecx, [Z]
    jg a
    sub ecx, eax;возвращаем значение ecx, чтобы в след итерации найти новую сумму.
    inc edi
    jmp b

    
    
Print:
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

        
    stack1: ; вывод числа из стека, и вывод его на экран
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

    nn:;вывод коцна строки
        mov eax, 4
        mov ebx, 1
        mov ecx, n
        mov edx, 1
        int 0x80
        xor eax, eax
        xor ebx, ebx
        xor ecx, ecx
        xor edx, edx
    ret
    
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
    Z dd 0
    res dd 0
    i dd 0
    Y dd 0
    q dd 0
    p dd 'Переполнение или неверные значения'
    s dd ' '
    n dd 10
    
segment .bss

    input resb 1
    

