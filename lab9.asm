global _start
section .data
x dd 63;Заданный вектор
y dd 1;Маска
s dd 0;Переменная для текущего символа
maxlen dd 32;Максимальная длина строки
segment .bss
input resb 1;Заданая строка
section .text
_start:

call ScanStr

mov esi, input
mov eax, 0
mov ebx, 1

call @1

shr ebx,1
mov [y], ebx

call @2

mov eax, 1
int 0x80

@1:;Процедура для построения маски (сдвигаем 1 влево, пока не дойдем до конца строки или пока кол-во сдвигов не достигнет 32)
    mov ecx, [esi+eax]
    cmp ecx, 10;
    je end@1
    cmp eax, [maxlen]
    je end@1
    inc eax
    shl ebx, 1
    jmp @1
    end@1:
ret

@2:;Процедура, в которой мы, выполняя побитовую операцию 'and' над исходным вектором и маской, выясняем, нужно ли выводить текущий символ и после выводим его
    mov ebx, [y]
    cmp ebx, 0;Проверяем, прошли ли всю строку (в этом случае маска равна 0)
    je end@2
    and ebx, [x]
    cmp ebx, 0;Если после операции 'and' над маской и вектором не получаем ноль, значит текущий символ нужно выводить
    je np
    call Print
    np:
    mov eax, [y]
    shr eax, 1;Сдвигаем маску вправо на 1
    mov [y], eax
    inc esi;Переходим на следующий символ
    jmp @2
    end@2:
ret

ScanStr:;Процедура для считывания строки
    mov eax, 3
    mov ebx, 0
    mov edx, 255 
    mov ecx, input  
    int 0x80
ret

Print:;Процедура для вывода символа
    mov eax, [esi]
    mov [s], eax
    mov eax, 4
    mov ebx, 1
    mov ecx, s
    mov edx, 1
    int 0x80
ret
