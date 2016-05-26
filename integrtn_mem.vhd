library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Complete_MIPS is
  port(CLK, RST: in std_logic;
       A_Out, D_Out: out unsigned(31 downto 0);
       Addr_ext: in unsigned(6 downto 0);
	 PC_out: out unsigned(31 downto 0);
       Output_ext: out unsigned(31 downto 0);
       reg_addr_ext: in unsigned(4 downto 0);
       reg_output_ext: out unsigned(31 downto 0));
end Complete_MIPS;
 
architecture model of Complete_MIPS is 
  component MIPS is
    port(CLK, RST: in std_logic;
         CS, WE: out std_logic;
	 PC_out: out unsigned(31 downto 0);
         ADDR: out unsigned(31 downto 0);
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
  signal CS, WE: std_logic;
  signal ADDR, Mem_Bus: unsigned(31 downto 0);
begin
  CPU: MIPS port map (CLK, RST, CS, WE, PC_out, ADDR, Mem_Bus, reg_addr_ext, reg_output_ext);
  MEM: Memory port map (CS, WE, CLK, ADDR, Mem_Bus,Addr_ext, Output_ext);
  A_Out <= Addr;
  D_Out <= Mem_Bus;
end model;