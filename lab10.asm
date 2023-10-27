extern printf
extern scanf
SECTION .text
global main
main:

Finit
Circle:
    FLD dword [x];заносим x в вершину стека
    FLD ST0;снова заносим (в ST1 сохранится значение x)
    call exp;вычисляем значение e^x
    FXCH ST1;меняем местами ST0 и ST1, чтобы работать с x
    FCHS;получаем -x
    call exp;вычисляем значение e^-x
    FSUBP ST1, ST0;вычисляем e^x-e^-x
    FLD1;заносим 1 в вершину стека
    FADD ST0, ST0;получаем 2
    FDIVP ST1, ST0;вычисляем (e^x-e^-x)/2
    FLD ST0;заносим в вершину стека(в ST1 сохранится значение нашей функции)
    FMUL ST0, ST0;вычисляем ((e^x-e^-x)/2)^2
    FMULP ST1, ST0;Вычисляем ((e^x-e^-x)/2)^3 

    call print;выводим значение

    FLD dword [y];заносим правую границу
    FLD dword [x];и текущее значение x
    FUCOMI;сравниваем ST1 и ST(0) (x и y)
    ja ReturnCircle;Если x>y, выводим из цикла
    FADD dword [h];Прибавляем к x значение шага h
    FSTP dword [x]
    FSTP
    FSTP
    jmp Circle
ReturnCircle:

jmp end

exp:;Процедура для нахождения e^x
    FLDL2E;Заносим в вершину log2(e)
    FMUL;получаем x*log2(e) = log2(e^x)
    FLD ST0;заносим в вершину
    FRNDINT;Округляем ST0
    FSUB ST1, ST0;Получаем дробную часть
    FXCH ST1;Меняем местами ST1 и ST0, чтобы работать с дробной частью
    F2XM1;Получаем значение 2^ST0-1=e^x'-1(x' - дробная часть x)
    FLD1;заносим 1
    FADD;получаем e^x'
    FSCALE;получаем ST0=e^x'*2^log2(e^x'') (x'' - целая часть x)
    FSTP
    ret

print:;Процедура вывода
    sub esp,8
    fst qword [esp];Забираем из вершины стека нужное значение
    push message
    call printf
    add esp,12
    ret
end:
    mov eax, 1
    int 0x80

section .data
x dd -1.5;левая граница
y dd 1.5;правая граница
h dd 0.1;шаг
segment .bss
section .rodata
message: db '%f',10,0