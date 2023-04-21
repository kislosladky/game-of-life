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
    ldi r1, set ## в r1 лежит адрес входа от кнопки set
    ld r1, r2
    clr r3
    
    if
        tst r2
    is nz ## если set не 0, значит включен выбор состояния клетки
        push r2 ## кидаю в стек состояние

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

            ldi r0, changed
            ldi r1, 1
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
                ldi r0, changed
                ldi r1, 1
                st r0, r1

            fi
        fi


        ##двигаем вправо или влево
        ##левый бит - влево, правый бит - вправо

        ldi r0, 0b00000010 ## смотрю сдвиг влево
        and r2, r0
        if 
            tst r2
        is nz
            ldi r0, cell_x
            ld r0, r1
            dec r1 ## уменьшаем, чтобы сдвинуть клетку влево
            st r0, r1

            ldi r0, changed
            ldi r1, 1
            st r0, r1
        else
            ldi r0, 0b00000001 
            and r2, r0
            if
                tst r0
            is nz
                ldi r0, cell_x
                ld r0, r1
                inc r1 ## увеличиваем, чтобы сдвинуть клетку вправо
                st r0, r1

                ldi r0, changed
                ldi r1, 1
                st r0, r1
            fi
        fi


        pop r2 ## возращаю состояние set

    else
        ldi r3, changed
        ld r3,r3
        if
            tst r3
        is nz
            ldi r0, 0
            ldi r3, changed
            st r3, r0 ## занулил changed, чтобы заново не менять клетку


            ldi r0, cell_x
            ld r0,r0
            ldi r1, cell_y
            ld r1,r1
            shl r0
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

            ldi r0, addr
            st r0, r1
        fi
        # ldi r2, 
        ## надо аппаратно менять значение на противоположное, когда получаю новый адрес на выходе
    


        ## потом надо бы сюда присобачить bcd вывод координат выбранной ячейки
    fi

    clr r0
    clr r1
    clr r2
    clr r3
    pop r0
wend

halt

# asect 0x80## мб стоит поменять потом

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
