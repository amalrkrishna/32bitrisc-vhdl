library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Memory is
  port(CS, WE, Clk: in std_logic;
       ADDR: in unsigned(31 downto 0);
       Mem_Bus: inout unsigned(31 downto 0);
       Addr_ext: in unsigned(6 downto 0);
       Output_ext: out unsigned(31 downto 0));
       
end Memory;

architecture Internal of Memory is
  type RAMtype is array (0 to 127) of unsigned(31 downto 0);
  signal RAM1: RAMtype := (0 => x"00412022",
			1 => x"00222824",
			2 => X"AC030040",
			3 => x"10220001",
			4 => x"1000FFFD",
			others => (others => '0'));
  signal output: unsigned(31 downto 0);
begin
  Mem_Bus <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" when CS = '0' or WE = '1'
    else output;
Output_ext <= RAM1(to_integer(Addr_ext));
  process(Clk)
  begin
    if Clk = '0' and Clk'event then
      if CS = '1' and WE = '1' then
        RAM1(to_integer(ADDR(6 downto 0))) <= Mem_Bus;
      end if;
    output <= RAM1(to_integer(ADDR(6 downto 0)));
    end if;
  end process;
end Internal;