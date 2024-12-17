ORG 0000H
SJMP MAIN

; Define Password
PASSWORD: DB '1234'
BUFFER: DS 4   ; Buffer to store entered password

; Initialize LCD Commands
LCD_INIT: DB 38H, 0EH, 01H, 06H, 80H
LCD_MSG1: DB 'Enter Password:', 0
LCD_MSG2: DB 'Access Granted', 0
LCD_MSG3: DB 'Access Denied', 0

MAIN:
    ACALL INIT_LCD           ; Initialize LCD
    ACALL DISPLAY_MSG1       ; Display "Enter Password:"
    MOV DPTR, #BUFFER        ; Initialize buffer pointer
    MOV R0, #4               ; Set password length

GET_PASSWORD:
    ACALL READ_KEYPAD        ; Read key from keypad
    MOVX @DPTR, A            ; Store key in buffer
    INC DPTR
    DJNZ R0, GET_PASSWORD    ; Repeat until full password is entered

    ACALL CHECK_PASSWORD     ; Check if the entered password is correct
    SJMP MAIN                ; Restart process

; Subroutine to Initialize LCD
INIT_LCD:
    MOV DPTR, #LCD_INIT
    MOV R1, #5
LCD_INIT_LOOP:
    CLR A
    MOVC A, @A+DPTR
    ACALL CMD_LCD
    INC DPTR
    DJNZ R1, LCD_INIT_LOOP
    RET

; Subroutine to Display Messages
DISPLAY_MSG1:
    MOV DPTR, #LCD_MSG1
    ACALL DISPLAY_STRING
    RET

DISPLAY_MSG2:
    MOV DPTR, #LCD_MSG2
    ACALL DISPLAY_STRING
    RET

DISPLAY_MSG3:
    MOV DPTR, #LCD_MSG3
    ACALL DISPLAY_STRING
    RET

DISPLAY_STRING:
    CLR A
    MOVC A, @A+DPTR
    JZ DONE
    ACALL DATA_LCD
    INC DPTR
    SJMP DISPLAY_STRING
DONE:
    RET

; Subroutine to Send Command to LCD
CMD_LCD:
    MOV P2, A
    CLR P2.0                  ; RS=0 for command
    SETB P2.1                 ; EN=1
    ACALL DELAY
    CLR P2.1                  ; EN=0
    ACALL DELAY
    RET

; Subroutine to Send Data to LCD
DATA_LCD:
    MOV P2, A
    SETB P2.0                 ; RS=1 for data
    SETB P2.1                 ; EN=1
    ACALL DELAY
    CLR P2.1                  ; EN=0
    ACALL DELAY
    RET

; Subroutine to Delay
DELAY:
    MOV R2, #200
DELAY_LOOP:
    DJNZ R2, DELAY_LOOP
    RET

; Subroutine to Read Keypad
READ_KEYPAD:
    MOV P1, #0F0H             ; Set columns as inputs
CHECK_KEYPAD:
    MOV A, P1
    ANL A, #0F0H
    CJNE A, #0F0H, KEY_PRESSED
    SJMP CHECK_KEYPAD
KEY_PRESSED:
    MOV R1, P1
    ACALL DEBOUNCE
    MOV A, P1
    ANL A, #0F0H
    CJNE A, #0F0H, KEY_PRESSED
    MOV A, R1
    ANL A, #0F0H
    CJNE A, #0F0H, KEY_PRESSED
    RET

DEBOUNCE:
    MOV R2, #20
DEBOUNCE_LOOP:
    DJNZ R2, DEBOUNCE_LOOP
    RET

; Subroutine to Check Password
CHECK_PASSWORD:
    MOV DPTR, #BUFFER
    MOV R0, #4
    MOV R1, #PASSWORD
CHECK_LOOP:
    CLR A
    MOVC A,@ A+R1
    MOVX B,@ DPTR
    CJNE A, B, WRONG_PASSWORD
    INC DPTR
    INC R1
    DJNZ R0, CHECK_LOOP
    ACALL DISPLAY_MSG2
    SETB P3.1                 ; Turn on LED
    SJMP DONE_CHECK
WRONG_PASSWORD:
    ACALL DISPLAY_MSG3
    SETB P3.0                 ; Turn on Buzzer
    SJMP DONE_CHECK
DONE_CHECK:
    RET

END