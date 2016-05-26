library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity REG is
  port(CLK, RST: in std_logic;
       RegW: in std_logic;
       DR, SR1, SR2: in unsigned(4 downto 0);
       Reg_In: in unsigned(31 downto 0);
       ReadReg1, ReadReg2: out unsigned(31 downto 0);
       reg_addr_ext: in unsigned(4 downto 0);
       reg_output_ext: out unsigned(31 downto 0));
end REG;

architecture Behavioral of REG is
  type RAM is array (0 to 31) of unsigned(31 downto 0);
  signal Regs: RAM := (others => (others => '0'));  -- set all reg bits to '1'
begin
  process(clk)
  begin
    if CLK = '1' and CLK'event then
 IF (RST = '0') THEN 
 --Reset Registers to own Register Number 
 --Used for testing ease. 
 FOR i IN 0 TO 31 LOOP 
 Regs(i) <= to_unsigned(i,32); 
 END LOOP; 
      elsif RegW = '1' and DR/=0 then
        Regs(to_integer(DR)) <= Reg_In;
      end if;
    end if;
  end process;
  ReadReg1 <= Regs(to_integer(SR1)); --asynchronous read
  ReadReg2 <= Regs(to_integer(SR2)); --asynchronous read
  reg_output_ext <= Regs(to_integer(reg_addr_ext));
end Behavioral;