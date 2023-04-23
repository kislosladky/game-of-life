## тут все более-менее работает, но логика странная


asect 0x00

# ldi r0, default ## загружаю в память начальное положение клетки
ldi r0, 0b00000111
# ld r0,r0
ldi r1, cell_x
st r1, r0
ldi r1, cell_y
st r1, r0   

while 
    tst r0
stays pl
    push r0
    
    ldi r2, joystick ## загружаю данные от джойстика
    ld r2, r2 
    
    shr r2 ## скидываю координату x в r3, правда, меняю местами
    shl r3
    shr r2
    shl r3
    
    ##начинаем парсить данные с джойстика и двигать ячейку

    ##двигаем вверх или вниз

    ldi r0, 0b00000010 ## смотрю, не идем ли мы вниз
    and r2, r0
    if
        tst r0
    is nz
        ldi r0, cell_y
        ld r0, r1
        inc r1 ## увеличиваем, чтобы сдвинуть клетку вниз
        st r0, r1

    else
        ldi r0, 0b00000001 
        and r2, r0
        if ## смотрю, не идем ли мы вверх
            tst r0
        is nz 
            
            ldi r0, cell_y
            ld r0, r1
            dec r1 ## уменьшаем, чтобы сдвинуть клетку вверх
            st r0, r1
            
        fi
    fi

    ##двигаем вправо или влево
    ##левый бит - влево, правый бит - вправо

    ldi r0, 0b00000010 ## смотрю сдвиг влево
    and r3, r0
    if 
        tst r0
    is nz
        ldi r0, cell_x
        ld r0, r1
        dec r1 ## уменьшаем, чтобы сдвинуть клетку влево
        st r0, r1
    else
        ldi r0, 0b00000001 
        and r3, r0
        if
            tst r0
        is nz
            ldi r0, cell_x
            ld r0, r1
            inc r1 ## увеличиваем, чтобы сдвинуть клетку вправо
            st r0, r1
        fi
    fi

    ldi r0, cell_x ## загружаю обе координаты
    ld r0,r0
    ldi r1, cell_y
    ld r1,r1
    shl r0     ##объединяю их и складываю в r1
    shl r0
    shl r0
    shl r0

    shl r0
    shl r1
    shl r0
    shl r1
    shl r0
    shl r1
    shl r0
    shl r1

    ldi r0, addr ## записываю итоговые координаты в addr
    st r0, r1


    clr r0 ## на всякий случай очищаю регистры перед следующей итерацией
    clr r1
    clr r2
    clr r3
    pop r0
wend

halt


asect 0x21           ## output
# input: ds 1
joystick: 

asect 0x22           ## output
# set: ds 1
set:    

asect 0x23           ## not used
# alive: ds 1
alive:

asect 0x24           ## is it used??
changed:

asect 0x25           ### input/output
cell_x:

asect 0x26           ### input/output
cell_y:

asect 0x27           ### output
addr:

end
