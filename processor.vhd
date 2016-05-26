library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity processor is
  port(CLK, RST, clkin: in std_logic;
       Addr_ext: in unsigned(6 downto 0);
   		db :out Unsigned(7 downto 0);
        E: buffer STD_LOGIC;
		lcd_on, lcd_blon, RS, RW : out STD_LOGIC;
       reg_addr_ext: in unsigned(4 downto 0));
end processor;
 
architecture model of processor is 
  component MIPS is
  port(CLK, RST: in std_logic; 
       CS, WE: out std_logic;
	PC_out : out unsigned(31 downto 0);
       ADDR: out unsigned (31 downto 0);
       Mem_Bus: inout unsigned(31 downto 0);
       reg_addr_ext: in unsigned(4 downto 0);
       reg_output_ext: out unsigned(31 downto 0));
  end component;
  component Memory is
  port(CS, WE, Clk: in std_logic;
       ADDR: in unsigned(31 downto 0);
       Mem_Bus: inout unsigned(31 downto 0);
       Addr_ext: in unsigned(6 downto 0);
		Output_ext: out unsigned(31 downto 0));
  end component;
  
  COMPONENT lcddriver is
generic(clk_divider:integer :=50000);
port (clk,rst:in STD_LOGIC;
rs,rw:out STD_LOGIC;
E: buffer STD_LOGIC;
d1, d2, d3, d4, d5, d6, d7, d8: in UNSIGNED(7 downto 0);
X1,X2,X3,X4,X5,X6,X7,X8,Y1,Y2,Y3,Y4,Y5,Y6,Y7,Y8 : in UNSIGNED(7 downto 0);
db :out Unsigned(7 downto 0);
lcd_on, lcd_blon : out STD_LOGIC);
end COMPONENT; 
  
  signal CS, WE: std_logic;
  signal A_Out, D_Out: unsigned(31 downto 0);
  signal ADDR, Mem_Bus: unsigned(31 downto 0);
  signal Output_ext, reg_output_ext, PC_out:  unsigned(31 downto 0);
  SIGNAL D1,x1,y1 : unsigned(7 DOWNTO 0); 
SIGNAL D2,x2,y2 : unsigned(7 DOWNTO 0); 
SIGNAL D3,x3,y3 : UNSIGNED(7 DOWNTO 0); 
SIGNAL D4,x4,y4 : UNSIGNED(7 DOWNTO 0); 
SIGNAL D5,x5,y5 : UNSIGNED(7 DOWNTO 0); 
SIGNAL D6,x6,y6 : UNSIGNED(7 DOWNTO 0); 
SIGNAL D7,x7,y7 : UNSIGNED(7 DOWNTO 0); 
SIGNAL D8,x8,y8 : UNSIGNED(7 DOWNTO 0);
  
FUNCTION binary_to_ascii (SIGNAL input: UNSIGNED(3 DOWNTO 0)) RETURN UNSIGNED 
 IS VARIABLE output: UNSIGNED(7 DOWNTO 0); 
 BEGIN 
 CASE input IS 
 WHEN "0000" => output:="00110000";
 WHEN "0001" => output:="00110001";
 WHEN "0010" => output:="00110010";
 WHEN "0011" => output:="00110011";
 WHEN "0100" => output:="00110100";
 WHEN "0101" => output:="00110101";
 WHEN "0110" => output:="00110110"; 
 WHEN "0111" => output:="00110111";
 WHEN "1000" => output:="00111000";
 WHEN "1001" => output:="00111001";
 WHEN "1010" => output:=X"41";
 WHEN "1011" => output:=X"42";
 WHEN "1100" => output:=X"43";
 WHEN "1101" => output:=X"44";
 WHEN "1110" => output:=X"45";
 WHEN "1111" => output:=X"46";
 WHEN OTHERS => output:=x"2D";
 END CASE; 
 RETURN output; 
 END binary_to_ascii;
  
begin
  CPU: MIPS port map (CLK, RST, CS, WE, PC_out, ADDR, Mem_Bus, reg_addr_ext, reg_output_ext);
  MEM: Memory port map (CS, WE, CLK, ADDR, Mem_Bus,Addr_ext, Output_ext);
  A_Out <= Addr;
  D_Out <= Mem_Bus;
  
 D1<= binary_to_ascii(Output_ext(3 DOWNTO 0));
 D2<= binary_to_ascii(Output_ext(7 DOWNTO 4));
 D3<= binary_to_ascii(Output_ext(11 DOWNTO 8));
 D4<= binary_to_ascii(Output_ext(15 DOWNTO 12));
 D5<= binary_to_ascii(Output_ext(19 DOWNTO 16));
 D6<= binary_to_ascii(Output_ext(23 DOWNTO 20));
 D7<= binary_to_ascii(Output_ext(27 DOWNTO 24));
 D8<= binary_to_ascii(Output_ext(31 DOWNTO 28));

 X1<= binary_to_ascii(PC_out(3 DOWNTO 0));
 X2<= binary_to_ascii(PC_out(7 DOWNTO 4));
 X3<= binary_to_ascii(PC_out(11 DOWNTO 8));
 X4<= binary_to_ascii(PC_out(15 DOWNTO 12));
 X5<= binary_to_ascii(PC_out(19 DOWNTO 16));
 X6<= binary_to_ascii(PC_out(23 DOWNTO 20));
 X7<= binary_to_ascii(PC_out(27 DOWNTO 24));
 X8<= binary_to_ascii(PC_out(31 DOWNTO 28));
 
 Y1<= binary_to_ascii(reg_output_ext(3 DOWNTO 0));
 Y2<= binary_to_ascii(reg_output_ext(7 DOWNTO 4));
 Y3<= binary_to_ascii(reg_output_ext(11 DOWNTO 8));
 Y4<= binary_to_ascii(reg_output_ext(15 DOWNTO 12));
 Y5<= binary_to_ascii(reg_output_ext(19 DOWNTO 16));
 Y6<= binary_to_ascii(reg_output_ext(23 DOWNTO 20));
 Y7<= binary_to_ascii(reg_output_ext(27 DOWNTO 24));
 Y8<= binary_to_ascii(reg_output_ext(31 DOWNTO 28));
 
  LCD: LCDDRIVER port map(
			clk=>clkin,
			rst=>rst,
			rs=>rs,rw=>rw,e=>e,
			db=>db, lcd_on=>lcd_on,	lcd_blon=>lcd_blon, 
			D1=>D1, D2=>D2,D3=>D3,D4=>D4,D5=>D5,D6=>D6,D7=>D7,D8=>D8,
			X1=>X1, X2=>X2, X3=>X3, X4=>X4,X5=>X5,X6=>X6,X7=>X7,X8=>X8,
			Y1=>Y1, Y2=>Y2,Y3=>Y3,Y4=>Y4,Y5=>Y5,Y6=>Y6,Y7=>Y7,Y8=>Y8);
  
end model;
