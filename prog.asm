##считаю координаты
##кидаю 1 в нужный ряд
##записываю координаты cell_x (о, они вроде уже есть)
##ставлю какой-нибудь флаг на 1 (set будет норм)



asect 0x00

ldi r0, 0b00000111
ldi r1, cell_x
st r1, r0
# ldi r1, cell_y
# st r1, r0   

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
    ldi r1, cell_y
    ld r1,r1
    if
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

        ldi r0, set ## имитирую нажатие кнопки
        ld r0, r3
        clr r3
        st r0, r3
        st r2, r3 ## 

        ldi r0, change ## зануляю change обратно
        st r0, r3
        ldi r3, old_row
        st r3, r1

        
    fi



    clr r0 ## на всякий случай очищаю регистры перед следующей итерацией
    clr r1
    clr r2
    clr r3
    pop r0
wend

halt

changeOn: 
    ldi r0, change
    ld r0, r1
    inc r1
    st r0, r1
    rts


asect 0x21   
joystick: 

asect 0x22     
set:    

asect 0x23           
change:

asect 0x24       
old_row:

asect 0x25        
cell_x:

asect 0x26          
cell_y:

asect 0x27           
row0:

asect 0x28
row1:

asect 0x29
row2:

asect 0x2a
row3:

asect 0x2b
row4:

asect 0x2c
row5:

asect 0x2d
row6:

asect 0x2e
row7:

asect 0x2f
row8:

asect 0x30
row9:

asect 0x31
row10:

asect 0x32
row11:

asect 0x33
row12:

asect 0x34
row13:

asect 0x35
row14:

asect 0x36
row15:

end
