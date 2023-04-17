asect 0x00

# ldi r0, default ## загружаю в память начальное положение клетки
ldi r0, 0b00000100
ld r0,r0
ldi r1, cell_x
st r1, r0
ldi r1, cell_y
st r1,r0

while 
    tst r0
stays pl
    push r0
    ldi r1, set ## в r1 лежит адрес входа от кнопки set
    ld r1, r2
    if
        tst r2
    is nz ## если set не 0, значит включен выбор состояния клетки
        push r2 ## кидаю в стек состояние

        ldi r2, input ## загружаю данные от джойстика
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
            push r0
            ldi r0, cell_y
            ld r0, r1
            inc r1 ## увеличиваем, чтобы сдвинуть клетку вниз
            st r0, r1
            pop r0
        else
            ldi r0, 0b00000001 
            and r2, r0
            if ## смотрю, не идем ли мы вверх
                tst r0
            is nz 
                push r0
                ldi r0, cell_y
                ld r0, r1
                dec r1 ## уменьшаем, чтобы сдвинуть клетку вверх
                st r0, r1
                pop r0
            fi
        fi


        ##двигаем вправо или влево
        ##левый бит - влево, правый бит - вправо

        ldi r0, 0b00000010 ## смотрю сдвиг влево
        and r2, r0
        if 
            tst r2
        is nz
            push r0
            ldi r0, cell_x
            ld r0, r1
            dec r1 ## уменьшаем, чтобы сдвинуть клетку влево
            st r0, r1
            pop r0
        else
            ldi r0, 0b00000001 
            and r2, r0
            if
                tst r0
            is nz
                push r0
                ldi r0, cell_x
                ld r0, r1
                inc r1 ## увеличиваем, чтобы сдвинуть клетку вправо
                st r0, r1
                pop r0
            fi
        fi


        ## теперь надо посмотреть, если нажаты всякие кнопки, чтобы загрузить новое значение в память
        ## set уже 1, остается проверить alive и засунуть его значение в память

        # ldi r0, alive
        # ld r0, r0

        # if
        #     tst r0
        # is nz
            
        # fi

        
        

        pop r2
    else

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
        # ldi r2, 
        ## надо аппаратно менять значение на противоположное, когда получаю новый адрес на выходе
        ## может, для этого нужен новый флаг?????????????


        ## потом надо бы сюда присобачить bcd вывод координат выбранной ячейки
    fi


    pop r0
wend

halt

asect 0x80## мб стоит поменять потом

# default: dc 0b00000100
# default:
asect 0x81
# input: ds 1
input: 
asect 0x82
# set: ds 1
set:
asect 0x83
# alive: ds 1
alive:
asect 0x84
output:
asect 0x85
cell_x:
asect 0x86
cell_y:
asect 0x87
addr:
end
