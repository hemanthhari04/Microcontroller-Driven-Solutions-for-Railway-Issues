ORG 0000H  ; Set the program start address to 0000H
LJMP START ; Jump to the START routine

ORG 0003H  ; Set the address for the Timer 0 interrupt vector
LCALL TIMEUPDATE ; Call TIMEUPDATE routine on interrupt
RETI       ; Return from interrupt

ORG 0013H  ; Set the address for the External 0 interrupt vector
LCALL SETTIMEMODE ; Call SETTIMEMODE routine on interrupt
RETI       ; Return from interrupt

ORG 100H   ; Set the program start address for the main code
START:
  MOV R4, #00H ; Initialize hours register
  MOV R5, #00H ; Initialize minutes register
  MOV R6, #00H ; Initialize seconds register
  LCALL STARTC ; Start I2C communication
  MOV A, #11010000B ; Device address
  LCALL SEND   ; Send the address
  MOV A, #00000111B ; Control byte
  LCALL SEND   ; Send the control byte
  MOV A, #10H  ; Address of timekeeping registers
  LCALL SEND   ; Send the address
  LCALL STOP   ; Stop I2C communication
  MOV IE, #85H ; Enable external interrupt 0 and timer 0
  MOV TCON, #05H ; Configure Timer 0
  LJMP DISPLAY ; Jump to the DISPLAY routine

ORG 150H  ; Set the address for SETTIMEMODE routine
SETTIMEMODE:
  CJNE R6, #05H, OPTION ; Check if the mode is 5, otherwise jump to OPTION
  MOV R6, #00H ; Reset mode
  LCALL RTCTIMEUPDATE ; Update RTC time
  SETB EX0 ; Enable external interrupt 0
  SETB SETTIMELED ; Turn on the set time LED
  RET ; Return from subroutine

OPTION:
  JNB TOGGLE, NEXTBIT ; Check if the toggle bit is not set, jump to NEXTBIT
  CJNE R6, #01H, SETHRLSB ; Check if the mode is 1, otherwise jump to SETHRLSB
  MOV A, R4 ; Move hours register to accumulator
  ANL A, #0F0H ; Mask lower 4 bits
  ADD A, #10H ; Add 10 to the upper 4 bits
  CJNE A, #30H, SKIPHRMSBRESET ; If not equal to 30H, jump to SKIPHRMSBRESET
  MOV A, #00H ; Reset hours register
  MOV R4, A ; Store back to hours register
  RET ; Return from subroutine

SETHRLSB:
  CJNE R6, #02H, SETMINMSB ; Check if the mode is 2, otherwise jump to SETMINMSB
  MOV A, R4 ; Move hours register to accumulator
  ANL A, #0F0H ; Mask upper 4 bits
  MOV R3, A ; Store the result in R3
  MOV A, R4 ; Move hours register to accumulator
  ANL A, #0FH ; Mask lower 4 bits
  INC A ; Increment the lower 4 bits
  CJNE R3, #20H, CHKFORHRMSB2 ; Check if upper bits are not equal to 20H
  CJNE A, #04H, SKIPHRLSBRESET ; If lower bits are not equal to 4, jump to SKIPHRLSBRESET
  MOV A, #00H ; Reset lower bits
  JMP SKIPHRLSBRESET ; Jump to SKIPHRLSBRESET

CHKFORHRMSB2:
  CJNE A, #0AH, SKIPHRLSBRESET ; Check if lower bits are not equal to 0AH
  MOV A, #00H ; Reset lower bits

SKIPHRLSBRESET:
  ORL A, R3 ; Combine upper and lower bits
  MOV R4, A ; Store back to hours register
  RET ; Return from subroutine

SETMINMSB:
  CJNE R6, #03H, SETMINLSB ; Check if the mode is 3, otherwise jump to SETMINLSB
  MOV A, R5 ; Move minutes register to accumulator
  ANL A, #0FH ; Mask lower 4 bits
  MOV R3, A ; Store the result in R3
  MOV A, R5 ; Move minutes register to accumulator
  ANL A, #0F0H ; Mask upper 4 bits
  ADD A, #10H ; Add 10 to the upper 4 bits
  CJNE A, #60H, SKIPMINMSBRESET ; If not equal to 60H, jump to SKIPMINMSBRESET
  MOV A, #00H ; Reset minutes register

SKIPMINMSBRESET:
  ORL A, R3 ; Combine upper and lower bits
  MOV R5, A ; Store back to minutes register
  RET ; Return from subroutine

SETMINLSB:
  CJNE R6, #04H, RETURNMINLSB ; Check if the mode is 4, otherwise jump to RETURNMINLSB
  MOV A, R5 ; Move minutes register to accumulator
  ANL A, #0F0H ; Mask upper 4 bits
  MOV R3, A ; Store the result in R3
  MOV A, R5 ; Move minutes register to accumulator
  ANL A, #0FH ; Mask lower 4 bits
  INC A ; Increment the lower 4 bits
  CJNE A, #0AH, SKIPMINLSBRESET ; Check if lower bits are not equal to 0AH
  MOV A, #00H ; Reset lower bits

SKIPMINLSBRESET:
  ORL A, R3 ; Combine upper and lower bits
  MOV R5, A ; Store back to minutes register

RETURNMINLSB:
  RET ; Return from subroutine

NEXTBIT:
  INC R6 ; Increment the mode
  CLR EX0 ; Clear external interrupt 0 flag
  CLR SETTIMELED ; Turn off the set time LED
  RET ; Return from subroutine

ORG 260H ; Set the address for DISPLAY routine
DISPLAY:
  HOURMSB:
    MOV A, R4 ; Move hours register to accumulator
    SWAP A ; Swap nibbles
    ANL A, #03H ; Mask upper 2 bits
    ORL A, #10H ; Set display control bits
    MOV P2, A ; Move to port 2
    LCALL MICRO_DELAY ; Call micro delay
    CJNE R6, #01H, HOURLSB ; Check if the mode is not 1, otherwise jump to HOURLSB
    SJMP DISPLAY ; Jump back to DISPLAY

  HOURLSB:
    MOV A, R4 ; Move hours register to accumulator
    ANL A, #0FH ; Mask lower 4 bits
    ORL A, #20H ; Set display control bits
    MOV P2, A ; Move to port 2
    LCALL MICRO_DELAY ; Call micro delay
    CJNE R6, #02H, MINMSB ; Check if the mode is not 2, otherwise jump to MINMSB
    SJMP DISPLAY ; Jump back to DISPLAY

  MINMSB:
    MOV A, R5 ; Move minutes register to accumulator
    SWAP A ; Swap nibbles
    ANL A, #0FH ; Mask upper 4 bits
    ORL A, #40H ; Set display control bits
    MOV P2, A ; Move to port 2
    LCALL MICRO_DELAY ; Call micro delay
    CJNE R6, #03H, MINLSB ; Check if the mode is not 3, otherwise jump to MINLSB
    SJMP DISPLAY ; Jump back to DISPLAY

  MINLSB:
    MOV A, R5 ; Move minutes register to accumulator
    ANL A, #0FH ; Mask lower 4 bits
    ORL A, #80H ; Set display control bits
    MOV P2, A ; Move to port 2
    LCALL MICRO_DELAY ; Call micro delay
    SJMP DISPLAY ; Jump back to DISPLAY

ORG 2F0H ; 5us delay subroutine
MICRO_DELAY:
  MOV R2, #05H ; Load delay count
  HERE:
    DJNZ R2, HERE ; Decrement and jump if not zero
  RET ; Return from subroutine

ORG 300H ; Set the address for TIMEUPDATE routine
TIMEUPDATE:
  LCALL STARTC ; Start I2C communication
  MOV A, #11010000B ; Device address
  LCALL SEND ; Send the address
  MOV A, #01H ; Register address
  LCALL SEND ; Send the register address
  LCALL STOP ; Stop I2C communication
  LCALL STARTC ; Start I2C communication
  MOV A, #11010001B ; Device address with read bit
  LCALL SEND ; Send the address
  LCALL RECV ; Receive data
  MOV R5, A ; Store received data in minutes register
  LCALL ACK ; Acknowledge
  LCALL RECV ; Receive data
  MOV R4, A ; Store received data in hours register
  LCALL NAK ; No Acknowledge
  LCALL STOP ; Stop I2C communication
  MOV A, R1 ; Move received data to accumulator
  RET ; Return from subroutine

ORG 400H ; Set the address for RTCTIMEUPDATE routine
RTCTIMEUPDATE:
  LCALL STARTC ; Start I2C communication
  MOV A, #11010000B ; Device address
  LCALL SEND ; Send the address
  MOV A, #00000000B ; Register address
  LCALL SEND ; Send the register address
  MOV A, #00H ; Data to send
  LCALL SEND ; Send data
  MOV A, R5 ; Move minutes register to accumulator
  LCALL SEND ; Send minutes data
  MOV A, R4 ; Move hours register to accumulator
  ORL A, #80H ; Set control bit
  LCALL SEND ; Send hours data
  LCALL STOP ; Stop I2C communication
  RET ; Return from subroutine

ORG 510H ; Set the address for RSTART routine
RSTART:
  CLR SCL ; Clear clock line
  SETB SDA ; Set data line
  SETB SCL ; Set clock line
  CLR SDA ; Clear data line
  RET ; Return from subroutine

ORG 520H ; Set the address for STARTC routine
STARTC:
  SETB SCL ; Set clock line
  CLR SDA ; Clear data line
  CLR SCL ; Clear clock line
  RET ; Return from subroutine

ORG 530H ; Set the address for STOP routine
STOP:
  CLR SCL ; Clear clock line
  CLR SDA ; Clear data line
  SETB SCL ; Set clock line
  SETB SDA ; Set data line
  RET ; Return from subroutine

ORG 540H ; Set the address for SEND routine
SEND:
  MOV R1, A ; Move data to be sent to R1
  MOV R7, #08 ; Load bit count
  BACK:
    CLR SCL ; Clear clock line
    RLC A ; Rotate accumulator left through carry
    MOV SDA, C ; Move carry bit to data line
    SETB SCL ; Set clock line
    DJNZ R7, BACK ; Decrement bit count and jump if not zero
  CLR SCL ; Clear clock line
  SETB SDA ; Set data line
  SETB SCL ; Set clock line
  MOV C, SDA ; Read data line
  CLR SCL ; Clear clock line
  MOV A, R1 ; Move data back to accumulator
  RET ; Return from subroutine

ORG 600H ; Set the address for ACK routine
ACK:
  CLR SDA ; Clear data line
  SETB SCL ; Set clock line
  CLR SCL ; Clear clock line
  SETB SDA ; Set data line
  RET ; Return from subroutine

ORG 610H ; Set the address for NAK routine
NAK:
  SETB SDA ; Set data line
  SETB SCL ; Set clock line
  CLR SCL ; Clear clock line
  SETB SCL ; Set clock line
  RET ; Return from subroutine

ORG 620H ; Set the address for RECV routine
RECV:
  MOV R1, A ; Move data to be received to R1
  CALL SUBROUTINE ; Call a subroutine (assumed to be missing)
  MOV R7, #08 ; Load bit count
  BACK2:
    CLR SCL ; Clear clock line
    SETB SCL ; Set clock line
    MOV C, SDA ; Move data line to carry bit
    RLC A ; Rotate accumulator left through carry
    DJNZ R7, BACK2 ; Decrement bit count and jump if not zero
  CLR SCL ; Clear clock line
  SETB SDA ; Set data line
  RET ; Return from subroutine

END ; End of the program