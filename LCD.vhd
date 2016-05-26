library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity lcddriver is
generic(clk_divider:integer :=50000);
port (clk,rst:in STD_LOGIC;
rs,rw:out STD_LOGIC;
E: buffer STD_LOGIC;
d1, d2, d3, d4, d5, d6, d7, d8 : in UNSIGNED(7 downto 0);
X1,X2,X3,X4,X5,X6,X7,X8,Y1,Y2,Y3,Y4,Y5,Y6,Y7,Y8 : in UNSIGNED(7 downto 0);
db :out Unsigned(7 downto 0);
lcd_on, lcd_blon : out STD_LOGIC);
end lcddriver;
architecture behavioral of lcddriver is
type state is( FunctionSet1,FunctionSet2,FunctionSet3,FunctionSet4,ClearDisplay,DisplayControl,EntryMode,WriteData1,WriteData2,WriteData3,WriteData4,WriteData5,WriteData6, WriteData7, WriteData8,
				WriteData9, WriteData10, WriteData11, WriteData12,WriteData13, WriteData14,WriteData15,WriteData16, WriteData17, WriteData18,
				WriteData19,WriteData20,WriteData21,WriteData22,WriteData23,WriteData24,WriteData25,WriteData26, WriteData27, WriteData28,
				WriteData29,WriteData30,WriteData31,WriteData32, ReturnHome,Nextline);
signal pr_state,nx_state:state;
begin

 process (clk)
variable count :integer range 0 to clk_divider;
begin
if(clk'event and clk='1')then					 -------clock divider for 50Hz
count :=count +1;
if(count=clk_divider)then						
 E<=not E;										
count:=0;
end if;
end if;
end process ;

 process(E)
begin
if(E'event and E='1') then
if(rst='0') then
pr_state<=FunctionSet1;
else
pr_state<=nx_state;
end if;
end if;
end process ;

 process(pr_state)
begin								-------Initialization code 1
case pr_state is
when FunctionSet1 =>			
lcd_on<='1';
lcd_blon<='1';
rs<='0';
rw<='0';
db<="00111000";
nx_state<= FunctionSet2;

when FunctionSet2 =>						-------Initialization code 2
lcd_on <='1';
lcd_blon <='1';
rs <='0';
rw <='0';
db<="00111000";
nx_state <= FunctionSet3;

when FunctionSet3 =>						-------Initialization code 3
lcd_on <='1';
lcd_blon <='1';
rs <='0';
rw <='0';
db <="00111000";
nx_state <= FunctionSet4;

when FunctionSet4 =>						-------Initialization code 4
lcd_on <='1';
lcd_blon <='1';
rs <='0';
rw <='0';
db <="00111000";
nx_state <= ClearDisplay;

when ClearDisplay =>						-------Clear Display Data
lcd_on <='1';
lcd_blon <='1';
rs <='0';
rw <='0';
db <="00000001";
nx_state <= DisplayControl;

when displayControl =>						-------Display On
lcd_on <='1';
lcd_blon <='1';
rs <='0';
rw <='0';
db <="00001100";
nx_state <=EntryMode;

when EntryMode =>						-------Set the cursor moving direction
lcd_on <='1';
lcd_blon <='1';
rs <='0';
rw <='0';
db <="00000110";
nx_state <= WriteData1;

when WriteData1 =>						-------Write data
lcd_on <='1';
lcd_blon <='1';
rs <='1';
rw <='0';
db <=X"52";							
nx_state <= WriteData2;				

when WriteData2 =>						-------Write data
lcd_on <='1';
lcd_blon <='1';
rs <='1';
rw <='0';
db <=X"65";							
nx_state <= WriteData3;

when WriteData3 =>						-------Write data
lcd_on <='1';
lcd_blon <='1';
rs <='1';
rw <='0';
db <=X"67";							
nx_state <= WriteData4;

when WriteData4 =>						-------Write data
lcd_on <='1';
lcd_blon <='1';
rs <='1';
rw <='0';
db <=X"20";							
nx_state <= WriteData5;

when WriteData5 =>						-------Write data
lcd_on <='1';
lcd_blon <='1';
rs <='1';
rw <='0';
db <=x8;							
nx_state <= WriteData6;

when WriteData6 =>						-------Write data
lcd_on <='1';
lcd_blon <='1';
rs <='1';
rw <='0';
db <=x7;							
nx_state <= WriteData7;

when WriteData7 =>						-------Write data
lcd_on <='1';
lcd_blon <='1';
rs <='1';
rw <='0';
db <=x6;							
nx_state <= WriteData8;

when WriteData8 =>						-------Write data
lcd_on <='1';
lcd_blon <='1';
rs <='1';
rw <='0';
db <=x5;							
nx_state <= Writedata9;

when WriteData9 =>						-------Write data
lcd_on <='1';
lcd_blon <='1';
rs <='1';
rw <='0';
db <=X4;							
nx_state <= Writedata10;

when WriteData10 =>						-------Write data
lcd_on <='1';
lcd_blon <='1';
rs <='1';
rw <='0';
db <=X3;							
nx_state <= Writedata11;

when WriteData11 =>						-------Write data
lcd_on <='1';
lcd_blon <='1';
rs <='1';
rw <='0';
db <=x2;							
nx_state <= Writedata12;

when WriteData12 =>						-------Write data
lcd_on <='1';
lcd_blon <='1';
rs <='1';
rw <='0';
db <=x1;							
nx_state <= Writedata13;

when WriteData13 =>						-------Write data
lcd_on <='1';
lcd_blon <='1';
rs <='1';
rw <='0';
db <=X"20";							
nx_state <= Writedata14;

when WriteData14 =>						-------Write data
lcd_on <='1';
lcd_blon <='1';
rs <='1';
rw <='0';
db <=X"4d";							
nx_state <= Writedata15;

when WriteData15 =>						-------Write data
lcd_on <='1';
lcd_blon <='1';
rs <='1';
rw <='0';
db <=X"65";							
nx_state <= Writedata16;

when WriteData16 =>						-------Write data
lcd_on <='1';
lcd_blon <='1';
rs <='1';
rw <='0';
db <=X"6d";							
nx_state <= Nextline;

when Nextline =>
lcd_on <='1';
lcd_blon <='1';
rs <='0';
rw <='0';
db <=X"C0";	
nx_state <= Writedata17;

when WriteData17 =>						-------Write data
lcd_on <='1';
lcd_blon <='1';
rs <='1';
rw <='0';
db <=y8;							
nx_state <= Writedata18;

when WriteData18 =>						-------Write data
lcd_on <='1';
lcd_blon <='1';
rs <='1';
rw <='0';
db <=y7;							
nx_state <= Writedata19;

when WriteData19 =>						-------Write data
lcd_on <='1';
lcd_blon <='1';
rs <='1';
rw <='0';
db <=y6;							
nx_state <= Writedata20;

when WriteData20 =>						-------Write data
lcd_on <='1';
lcd_blon <='1';
rs <='1';
rw <='0';
db <=y5;							
nx_state <= Writedata21;

when WriteData21 =>						-------Write data
lcd_on <='1';
lcd_blon <='1';
rs <='1';
rw <='0';
db <=y4;							
nx_state <= Writedata22;

when WriteData22 =>						-------Write data
lcd_on <='1';
lcd_blon <='1';
rs <='1';
rw <='0';
db <=y3;							
nx_state <= Writedata23;

when WriteData23 =>						-------Write data
lcd_on <='1';
lcd_blon <='1';
rs <='1';
rw <='0';
db <=y2;							
nx_state <= Writedata24;

when WriteData24 =>						-------Write data
lcd_on <='1';
lcd_blon <='1';
rs <='1';
rw <='0';
db <=y1;							
nx_state <= Writedata25;

when WriteData25 =>						-------Write data
lcd_on <='1';
lcd_blon <='1';
rs <='1';
rw <='0';
db <=d8;							
nx_state <= Writedata26;

when WriteData26 =>						-------Write data
lcd_on <='1';
lcd_blon <='1';
rs <='1';
rw <='0';
db <=d7;							
nx_state <= Writedata27;

when WriteData27 =>						-------Write data
lcd_on <='1';
lcd_blon <='1';
rs <='1';
rw <='0';
db <=d6;							
nx_state <= Writedata28;

when WriteData28 =>						-------Write data
lcd_on <='1';
lcd_blon <='1';
rs <='1';
rw <='0';
db <=d5;							
nx_state <= Writedata29;

when WriteData29 =>						-------Write data
lcd_on <='1';
lcd_blon <='1';
rs <='1';
rw <='0';
db <=d4;							
nx_state <= Writedata30;

when WriteData30 =>						-------Write data
lcd_on <='1';
lcd_blon <='1';
rs <='1';
rw <='0';
db <=d3;							
nx_state <= Writedata31;

when WriteData31 =>						-------Write data
lcd_on <='1';
lcd_blon <='1';
rs <='1';
rw <='0';
db <=d2;							
nx_state <= Writedata32;

when WriteData32 =>						-------Write data
lcd_on <='1';
lcd_blon <='1';
rs <='1';
rw <='0';
db <=d1;							
nx_state <= ReturnHome;

when ReturnHome =>								
lcd_on <='1';
lcd_blon <='1';
rs <='0';
rw <='0';
db <="10000000";					         -------Return Cursor Home
nx_state <=WriteData1;
end case;
end process;
end behavioral;
