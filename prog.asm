asect 0x00
ldi r0, 0b00000111
ldi r1, cell_x
st r1, r0
while 
    tst r0
stays pl
    push r0

    jsr key_parser

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


        jsr changeOn
        # ldi r0, change ## помечаю изменение координаты
        # ld r0, r1
        # inc r1
        # st r0, r1

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

            jsr changeOn
            # ldi r0, change
            # ld r0, r1
            # inc r1
            # st r0, r1
            
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

        jsr changeOn
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

            jsr changeOn
        fi


    fi

    # ldi r0, cell_x ## загружаю обе координаты (там уже готовое значение, делать ничего не надо)
    # ld r0,r0
    
    if
        ldi r1, cell_y
        ld r1,r1
        tst r1
    is mi
        ldi r3, 16
        add r3, r1
    fi



    
    if 
        ldi r0, change
        ld r0, r0
        tst r0
    is nz

        ldi r2, 0x27 ## адрес первого ряда
        ldi r3, old_row
        ld r3,r3
        add r2, r3
        clr r0
        st r3, r0 ## очищаю регистр предыдущего ряда



        add r1, r2 ## получаю адрес нового ряда
        ldi r3, 1
        st r2, r3 ## загружаю 1 в нужный ряд 

        # ldi r0, set ## имитирую нажатие кнопки
        # ld r0, r3
        clr r3
        # st r0, r3
        st r2, r3 ## 

        ldi r0, change ## зануляю change обратно
        st r0, r3
        ldi r3, old_row
        st r3, r1

        
    fi

    ldi r0, setButton
    ld r0, r0
    if 
        tst r0
    is nz
        jsr pressSetButton
    fi


    clr r0 ## на всякий случай очищаю регистры перед следующей итерацией
    clr r1
    clr r2
    clr r3
    pop r0
wend

halt

key_parser:
    ldi r0, keyboard ## проверяю кнопки выбора готовых фигур
    ld r0,r0
    if 
        tst r0
    is nz
        dec r0
        if 
            tst r0
        is z ## если 1, рисуем glider
            jsr glider
        else
            dec r0
            if
                tst r0
            is z ## если 2, рисуем low weight spaceship
                jsr lwss
            else
            #     # dec r0
                jsr pentomino ## иначе рисуем взрыв
            fi
        fi
    fi
    rts

changeOn: 
    ldi r0, change
    ld r0, r1
    inc r1
    st r0, r1
    rts

glider:
    pushall
    ldi r2, 0x27 ## адрес первого ряда
    ldi r3, cell_y
    ld r3,r3
    add r2, r3 ## загружаю адрес текущего ряда в r3
    
    
    ldi r0, 1
    
    st r3, r0 ## выбираю текущий ряд

    jsr pressSet
    # jsr pressSet
    dec r0 
    # st r3, r0
    
    # clr r0
    st r3, r0 ## убираю set текущего ряда
    inc r0 ## увеличиваю значение, чтобы записать 1 в следующую строку

    inc r3 ## увеличиваю адрес, чтобы сдвинуться вниз
    st r3, r0 ## выбираю следующий ряд (ниже предыдущего)

    jsr pressSet
    # jsr pressSet

    dec r0
    st r3, r0 ## зануляю предыдущую строку
    inc r3
    inc r0
    st r3, r0 ## выбираю новую строчку

    jsr pressSet
    # jsr pressSet

    ldi r0, 0x27
    sub r3, r0
    ldi r3, cell_y
    st r3, r0 ## записываю новую координату у выбранной клетки
    # jsr pressSet
    # jsr pressSet

    ldi r0, cell_x  ## сдвигаю вправо
    ld r0, r1
    inc r1
    st r0, r1
    jsr pressSet
    # jsr pressSet

    inc r1
    st r0, r1
    ldi r0, cell_y
    ld r0, r1
    ldi r0, 0x27
    add r0, r1
    clr r0
    st r1, r0
    inc r0
    dec r1
    st r1,r0

    jsr pressSet
    dec r0
    st r1, r0
    popall
    rts

lwss:
    pushall
    ## получаю координаты первого ряда
    ldi r2, 0x27 ## адрес первого ряда
    ldi r3, cell_y
    ld r3,r3
    add r2, r3 
    # inc r3
    ldi r0, 1
    st r3, r0
    jsr pressSet

    ldi r2, cell_x ## сдвигаемся влево
    ld r2, r1
    dec r1
    st r2, r1

    clr r0
    
    st r3, r0
    inc r3
    inc r0
    st r3, r0 ## сдвинулись вниз

    jsr pressSet

    dec r0
    st r3, r0
    inc r3
    inc r0
    st r3, r0
    jsr pressSet

    dec r0
    st r3, r0
    inc r3
    inc r0
    st r3, r0
    jsr pressSet

    inc r1
    st r2, r1
    jsr pressSet

    inc r1
    st r2,r1
    jsr pressSet
    
    inc r1
    st r2,r1
    jsr pressSet ## сдвинулся несколько раз вправо

    inc r1
    st r2, r1 ## сдвинулся вправо еще раз

    dec r0
    st r3, r0
    dec r3
    inc r0
    st r3, r0
    jsr pressSet ## сдвинулся вверх

    dec r0
    st r3, r0
    inc r0
    dec r3
    dec r3
    st r3, r0
    jsr pressSet
    dec r0
    st r3, r0
    
    

    popall
    rts

pentomino:
    # получаю координаты первого ряда
    pushall
    ldi r2, 0x27 ## адрес первого ряда
    ldi r3, cell_y
    ld r3,r3
    add r2, r3 
    ldi r0, 1
    st r3, r0
    jsr pressSet

    
    ldi r0, cell_x  ## сдвигаю влево 
    ld r0, r1
    dec r1
    st r0, r1
    jsr pressSet

    clr r1
    st r3, r1 ## обнулили set старой строки
    dec r3          ## cдвигаю вверх
    inc r1
    # ldi r2, cell_y
    st r3, r1 ## ставлю set новой строке
    ldi r1, cell_x
    ld r1,r2
    inc r2          ## сдвигаю вправо
    st r1, r2
    # st r0, r1
    jsr pressSet

    inc r2
    st r1, r2 ## сдвинул еще вправо
    
    ldi r0, 0
    st r3, r0
    inc r3
    inc r0
    st r3, r0 ## сдвигаю set на 1 строку вниз

    jsr pressSet

    dec r0
    st r3, r0
    inc r3
    inc r0
    st r3, r0 ## сдвигаю set на 1 строку вниз 

    dec r2
    st r1, r2

    jsr pressSet
    
    popall
    rts

pressSet: ## имитация нажатия кнопки set с сохранением предыдущих значений в регистрах r0-3
    push r0
    push r1
    push r2
    ldi r0, set ## "нажимаю" кнопку set
    ldi r2, setButton
    ldi r1, 1
    st r0, r1
    st r2, r1
    clr r1
    st r0, r1
    st r2, r1

    pop r2
    pop r1
    pop r0
    rts

pressSetButton:
    ldi r0, cell_y
    ld r0, r0
    ldi r1, row0
    add r0, r1
    ldi r0, 1
    st r1, r0
    jsr pressSet
    dec r0
    st r1, r0
    rts
asect 0x20
setButton:
asect 0x21  
# asect 0x41 
joystick: 
asect 0x22    
# asect 0x42 
set:    
asect 0x23  
# asect 0x43         
change:
asect 0x24    
# asect 0x44   
old_row:
asect 0x25      
# asect 0x45  
cell_x:
asect 0x26     
# asect 0x46     
cell_y:
asect 0x27  
# asect 0x47         
row0:
asect 0x28
# asect 0x48
row1:
asect 0x29
# asect 0x49
row2:
asect 0x2a
# asect 0x4a
row3:
asect 0x2b
# asect 0x4b
row4:
asect 0x2c
# asect 0x4c
row5:
asect 0x2d
# asect 0x4d
row6:
asect 0x2e
# asect 0x4e
row7:
asect 0x2f
# asect 0x4f
row8:
asect 0x30
# asect 0x50
row9:
asect 0x31
# asect 0x51
row10:
asect 0x32
# asect 0x52
row11:
asect 0x33
# asect 0x53
row12:
asect 0x34
# asect 0x54
row13:
asect 0x35
# asect 0x55
row14:
asect 0x36
# asect 0x56
row15:
asect 0x37
# asect 0x40
keyboard:
end
