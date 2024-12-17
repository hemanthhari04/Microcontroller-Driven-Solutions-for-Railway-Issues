#include<reg51.h>
#include<string.h>
#include<stdio.h>
#define LCDPORT P1

sbit rs=P1^0;
sbit rw=P1^1;
sbit en=P1^2;
sbit Motor1=P2^4;
sbit Motor2=P2^3;
sbit Speaker=P2^6;
char i,rx_data[50];
char rfid[13],ch=0;
int counter1, counter2, counter3;
unsigned char result[1];

 void delay(int itime)
{
    int i,j;
    for(i=0;i<itime;i++)
    for(j=0;j<1275;j++);
}

void daten()
{
    rs=1;
    rw=0;
    en=1;
    delay(5);
    en=0;
}

void lcddata(unsigned char ch)
{
    LCDPORT=ch & 0xf0;
    daten();
    LCDPORT=(ch<<4) & 0xf0;
    daten();
}

void cmden(void)
{
    rs=0;
    en=1;
    delay(5);
    en=0;
}

void lcdcmd(unsigned char ch)
{
    LCDPORT=ch & 0xf0;
    cmden();
    LCDPORT=(ch<<4) & 0xf0;
    cmden();
}

void lcdstring(char *str)
{
    while(*str)
    {
        lcddata(*str);
        str++;
    }
}

void lcd_init(void)
{
    lcdcmd(0x02);
    lcdcmd(0x28);
    lcdcmd(0x0e);
    lcdcmd(0x01);
}

void uart_init()
{
 TMOD=0x20;
 SCON=0x50;
 TH1=0xfd;
 TR1=1;
}
char rxdata()
{
  while(!RI);
    ch=SBUF;    
    RI=0;
    return ch;
}

void main()
{
    Speaker=1;
    uart_init();
    lcd_init();
    lcdstring("12345 ADITYA EXP");
    lcdcmd(0xc0);
    lcdstring("RJY-VSP"); 
    delay(500);
  	lcd_init();
    lcdstring("PNR BASED");
    lcdcmd(0xc0);
	  lcdstring("PSG VERIFICATION"); 
    delay(400);
    while(1)
    {
        lcdcmd(1);
			  lcdstring("ENTER PNR NO:");
        lcdcmd(0xc0);
        i=0;
        for(i=0;i<12;i++)
        rfid[i]=rxdata();
        rfid[i]='\0';
        lcdcmd(1);
			lcdstring("YOUR PNR NO. is:");
        lcdcmd(0xc0);
        for(i=0;i<12;i++)
        lcddata(rfid[i]);
        delay(100);
        if(strncmp(rfid,"22A91A04H002",12)==0)
        {
            counter1++;
            lcdcmd(1);             
            lcdstring(" Atttended");
            delay(200);
            lcdcmd(1);
            lcdstring("P.SAI DURGA");
            lcdcmd(0xc0);
            lcdstring("Attnd. No.: ");
            sprintf(result, "%d", counter1);
            lcdstring(result);
            
            Motor1=1;
            Motor2=0;
            delay(300);
            Motor1=0;
            Motor2=0;
            delay(200);
            Motor1=0;
            Motor2=1;
        }
        
        else if(strncmp(rfid,"23A95A042504",12)==0)
            {
            counter2++;
            lcdcmd(1);
            lcdstring(" Attended");
            delay(200);
            lcdcmd(1);
            lcdstring("HARI HEMANTH");
            lcdcmd(0xc0);
            lcdstring("Attnd. No.: ");
            sprintf(result, "%d", counter2);
            lcdstring(result);
            
            Motor1=1;
            Motor2=0;
            delay(300);
            Motor1=0;
            Motor2=0;
            delay(200);
            Motor1=0;
            Motor2=1;
            delay(300);
            Motor1=0;
            Motor2=0;
      }
            
                else if(strncmp(rfid,"23A95A040501",12)==0)
            {
                counter3++;
            lcdcmd(1);
            lcdstring(" Attended");
            delay(200);
            lcdcmd(1);
            lcdstring("R.AJAY KIRAN");
            lcdcmd(0xc0);
            lcdstring("Attnd. No.: ");
            sprintf(result, "%d", counter3);
            lcdstring(result);
            
            Motor1=1;
            Motor2=0;
            delay(300);
            Motor1=0;
            Motor2=0;
            delay(200);
            Motor1=0;
            Motor2=1;
            delay(300);
            Motor1=0;
            Motor2=0;

            }
						else if(strncmp(rfid,"22P31A040901",12)==0)
            {
                counter3++;
            lcdcmd(1);
            lcdstring(" Attended");
            delay(200);
            lcdcmd(1);
            lcdstring("ABHISHEK");
            lcdcmd(0xc0);
            lcdstring("Attnd. No.: ");
            sprintf(result, "%d", counter3);
            lcdstring(result);
            
            Motor1=1;
            Motor2=0;
            delay(300);
            Motor1=0;
            Motor2=0;
            delay(200);
            Motor1=0;
            Motor2=1;
            delay(300);
            Motor1=0;
            Motor2=0;

            }
						else if(strncmp(rfid,"22P31A042901",12)==0)
            {
                counter3++;
            lcdcmd(1);
            lcdstring(" Attended");
            delay(200);
            lcdcmd(1);
            lcdstring("N.PRIYANKA");
            lcdcmd(0xc0);
            lcdstring("Attnd. No.: ");
            sprintf(result, "%d", counter3);
            lcdstring(result);
            
            Motor1=1;
            Motor2=0;
            delay(300);
            Motor1=0;
            Motor2=0;
            delay(200);
            Motor1=0;
            Motor2=1;
            delay(300);
            Motor1=0;
            Motor2=0;

            }
						else if(strncmp(rfid,"22P31A041301",12)==0)
            {
                counter3++;
            lcdcmd(1);
            lcdstring(" Attended");
            delay(200);
            lcdcmd(1);
            lcdstring("G.NIHARIKA");
            lcdcmd(0xc0);
            lcdstring("Attnd. No.: ");
            sprintf(result, "%d", counter3);
            lcdstring(result);
            
            Motor1=1;
            Motor2=0;
            delay(300);
            Motor1=0;
            Motor2=0;
            delay(200);
            Motor1=0;
            Motor2=1;
            delay(300);
            Motor1=0;
            Motor2=0;

            }
						else if(strncmp(rfid,"22P31A044601",12)==0)
            {
                counter3++;
            lcdcmd(1);
            lcdstring(" Attended");
            delay(200);
            lcdcmd(1);
            lcdstring("T.ARJUN");
            lcdcmd(0xc0);
            lcdstring("Attnd. No.: ");
            sprintf(result, "%d", counter3);
            lcdstring(result);
            
            Motor1=1;
            Motor2=0;
            delay(300);
            Motor1=0;
            Motor2=0;
            delay(200);
            Motor1=0;
            Motor2=1;
            delay(300);
            Motor1=0;
            Motor2=0;

            }
						else if(strncmp(rfid,"22P31A042101",12)==0)
            {
                counter3++;
            lcdcmd(1);
            lcdstring(" Attended");
            delay(200);
            lcdcmd(1);
            lcdstring("K.SURYA");
            lcdcmd(0xc0);
            lcdstring("Attnd. No.: ");
            sprintf(result, "%d", counter3);
            lcdstring(result);
            
            Motor1=1;
            Motor2=0;
            delay(300);
            Motor1=0;
            Motor2=0;
            delay(200);
            Motor1=0;
            Motor2=1;
            delay(300);
            Motor1=0;
            Motor2=0;

            }

        else 
        {
           lcdcmd(1);
           lcdstring("PNR NOT MATCHED");
					 lcdcmd(0xc0);
           lcdstring("REACH TO R/Y DEPT");
           Speaker=0;
           delay(300);
           Speaker=1;
        }
  }
}
