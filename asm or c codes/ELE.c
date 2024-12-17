
#include <REG51.H>
#include <stdio.h>
int p,q,r;
q=10; //for every motor freezing count
r=10; //rotation of the motor 0 min 32000 max
delay(c)
{
int i,j;
if(c==0)
{
for(i=0;i<500;i++)
{
for(j=0;j<r;j++);
}
}
return c;
}
// elevator going up
up(b)
{
int i,j;
for (i=1;i<=b;i++)
{
for (j=0;j<=10;j++)
{
P3=1;
delay(0);
P3=2;
delay(0);
P3=4;
delay(0);
P3=8;
delay(0);
P3=16;
delay(0);
}
P2=p+i;
}
p=p+b;
return b;
}
// elevator going down
down(b)
{
int i,j;
for (i=1;i<=b;i++)
{
for (j=0;j<=q;j++)
{
P3=16;
delay(0);
P3=8;
P3=4;
delay(0);
P3=2;
delay(0);
P3=1;
delay(0);
}
P2=p-i;
}
p=p-b;
return b;
}
control(a)
{
int difference;
if(a>p)
{
difference=a-p;
up(difference);
}
if(a<p)
{
difference=p-a;
down(difference);
}
return a;
}
main()
{
int p1;
p=0;
P2=p;
while(1)
{
if(P0==2)
{
p1=1;
control(1);
}
if(P0==4)
{
p1=2;
control(2);
}
if(P0==8)
{
p1=3;
control(3);
}
if(P0==16)
{
p1=4;
delay(0);
control(4);
}
if(P0==32)
{
p1=5;
control(5);
}
if(P0==1)
{
p1=0;
control(0);
}
}
}