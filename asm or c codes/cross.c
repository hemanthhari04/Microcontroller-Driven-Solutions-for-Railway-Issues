#include <reg51.h>
#include <stdio.h>

sbit rs = P2^0;
sbit rw = P2^1;
sbit en = P2^2;

// buzzer inputs
sbit platform1 = P3^0;
sbit platform2 = P3^1;
sbit platform3 = P3^2;
sbit platform4 = P3^3;

// question launcher
sbit question = P3^7;

// LED pins
sbit ledt1 = P2^4;
sbit ledt2 = P2^5;
sbit ledt3 = P2^6;
sbit ledt4 = P2^7;

void init_lcd();
void delay(int count);
void lcd_comm(unsigned char v1);
void lcd_data(unsigned char v2);
void lcd_msg(unsigned char *ch);

void main() {
    unsigned char a = 0x80;
    P0 = 0x00;
    P2 = 0x00;
    P3 = 0x00;

    while (1) {
        for (a = 0x8F; a > 0x80; a--) {
            init_lcd();
            lcd_comm(a);
            lcd_msg("vzy to rjy platform");
            delay(50);
        }

        if (question == 1) {
            for (a = 0x8F; a >= 0x80; a--) {
                init_lcd();
                lcd_comm(a);
                lcd_msg("cross detector");
                delay(50);
            }

            delay(100);

            HHH:
            if (platform1 == 1) {
                ledt1 = 1;
                for (a = 0x8F; a >= 0x80; a--) {
                    init_lcd();
                    lcd_comm(a);
                    lcd_msg("platform1");
                    delay(200);
                }

                delay(300);
                ledt1 = 0;
            } else if (platform2 == 1) {
                ledt2 = 1;
                for (a = 0x8F; a >= 0x80; a--) {
                    init_lcd();
                    lcd_comm(a);
                    lcd_msg("platform2");
                    delay(200);
                }

                delay(300);
                ledt2 = 0;
            } else if (platform3 == 1) {
                ledt3 = 1;
                for (a = 0x8F; a >= 0x80; a--) {
                    init_lcd();
                    lcd_comm(a);
                    lcd_msg("platform3");
                    delay(200);
                }

                delay(300);
                ledt3 = 0;
            } else if (platform4 == 1) {
                ledt4 = 1;
                for (a = 0x8F; a >= 0x80; a--) {
                    init_lcd();
                    lcd_comm(a);
                    lcd_msg("platform4");
                    delay(200);
                }

                delay(300);
                ledt4 = 0;
            } else {
                goto HHH;
            }
        }
    }
}

void init_lcd() {
    lcd_comm(0x38);
    lcd_comm(0x0E);
    lcd_comm(0x01);
    lcd_comm(0x06);
    lcd_comm(0x80);
}

void lcd_comm(unsigned char v1) {
    P0 = v1;
    rs = 0;
    rw = 0;
    en = 1;
    delay(1);
    en = 0;
}

void lcd_data(unsigned char v2) {
    P0 = v2;
    rs = 1;
    rw = 0;
    en = 1;
    delay(1);
    en = 0;
}

void lcd_msg(unsigned char *ch) {
    while (*ch != 0) {
        lcd_data(*ch);
        ch++;
    }
}

void delay(int count) {
    int i, j;
    for (i = 0; i < count; i++)
        for (j = 0; j < 113; j++);
}
