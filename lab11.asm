extern printf
extern scanf
extern exit
SECTION .text
global main
main:

Finit

    fld dword [x]
    call sin

    call print

	push 0x0
	call exit

print:;Процедура вывода
    sub esp,8
    fst qword [esp];Забираем из вершины стека нужное значение
    push result
    call printf
    add esp,12
    ret

sin:
    fld dword [one]    ;stack: 1, x
    fld st0    ;stack: 1, 1, x
    fld st2    ;stack: x, 1, 1, x
    fmul st0, st0    ;stack: x^2, 1, 1, x
    fchs
    fld st3    ;stack: x, -x^2, 1, 1, x
    mov ecx, 10
    circle:
        fmul st0, st1    ;stack: (-1)^i*x^(2i+3), -x^2, (2i+1)!, 2i+1, x+...+(-1)^i*x^(2i+1)/(2i+1)!
        fld dword [one]    ;stack: 1, (-1)^i*x^(2i+3), -x^2, (2i+1)!, 2i+1, x+...+(-1)^i*x^(2i+1)/(2i+1)!
        fld st0    ;stack: 1, 1, (-1)^i*x^(2i+3), -x^2, (2i+1)!, 2i+1, x+...+(-1)^i*x^(2i+1)/(2i+1)!
        fadd st5    ;stack: 2i+2, 1, (-1)^i*x^(2i+3), -x^2, (2i+1)!, 2i+1, x+...+(-1)^i*x^(2i+1)/(2i+1)!
        fmul st4, st0    ;stack: 2i+2, 1, (-1)^i*x^(2i+3), -x^2, (2i+2)!, 2i+1, x+...+(-1)^i*x^(2i+1)/(2i+1)!
        fadd st0, st1    ;stack: 2i+3, 1, (-1)^i*x^(2i+3), -x^2, (2i+2)!, 2i+1, x+...+(-1)^i*x^(2i+1)/(2i+1)!
        fmul st4, st0    ;stack: 2i+3, 1, (-1)^i*x^(2i+3), -x^2, (2i+3)!, 2i+1, x+...+(-1)^i*x^(2i+1)/(2i+1)!
        fxch st5    ;stack: 2i+1, 1, (-1)^i*x^(2i+3), -x^2, (2i+3)!, 2i+3, x+...+(-1)^i*x^(2i+1)/(2i+1)!
        fstp st0    ;stack: 1, (-1)^i*x^(2i+3), -x^2, (2i+3)!, 2i+3, x+...+(-1)^i*x^(2i+1)/(2i+1)!
        fstp st0    ;stack: (-1)^i*x^(2i+3), -x^2, (2i+3)!, 2i+3, x+...+(-1)^i*x^(2i+1)/(2i+1)!
        fld st0    ;stack: (-1)^i*x^(2i+3), (-1)^i*x^(2i+3), -x^2, (2i+3)!, 2i+3, x+...+(-1)^i*x^(2i+1)/(2i+1)!
        fdiv st3    ;stack: (-1)^i*x^(2i+3)/(2i+3)!, (-1)^i*x^(2i+3), -x^2, (2i+3)!, 2i+3, x+...+(-1)^i*x^(2i+1)/(2i+1)!
        fadd st0, st5    ;stack: x+...+(-1)^i*x^(2i+1)/(2i+1)!+(-1)^i*x^(2i+3)/(2i+3)!, (-1)^i*x^(2i+3), -x^2, (2i+3)!, 2i+3, x+...+(-1)^i*x^(2i+1)/(2i+1)!
        fxch st5    ;stack:  x+...+(-1)^i*x^(2i+1)/(2i+1)!, (-1)^i*x^(2i+3), -x^2, (2i+3)!, 2i+3, x+...+(-1)^i*x^(2i+1)/(2i+1)!+(-1)^i*x^(2i+3)/(2i+3)!
        fstp st0    ;stack:  (-1)^i*x^(2i+3), -x^2, (2i+3)!, 2i+3, x+...+(-1)^i*x^(2i+1)/(2i+1)!+(-1)^i*x^(2i+3)/(2i+3)!
    loop circle

    fstp st0    ;stack: -x^2, (2i+1)!, 2i+1, x+...+(-1)^i*x^(2i+1)/(2i+1)!
    fstp st0    ;stack: (2i+1)!, 2i+1, x+...+(-1)^i*x^(2i+1)/(2i+1)!
    fstp st0    ;stack: 2i+1, x+...+(-1)^i*x^(2i+1)/(2i+1)!
    fstp st0    ;stack: x+...+(-1)^i*x^(2i+1)/(2i+1)!
    ret



section .data
    result db 'sin(x) = %lf', 0x0a, 0
    one dd 1.0
    x dd 3.0