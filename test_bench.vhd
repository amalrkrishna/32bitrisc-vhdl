library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MIPS_Testbench is
end MIPS_Testbench;

architecture test of MIPS_Testbench is
  component MIPS
    port(CLK, RST: in std_logic; 
         CS, WE: out std_logic;
         ADDR: out unsigned (31 downto 0);
         Mem_Bus: inout unsigned(31 downto 0));
  end component;
  component Memory
    port(CS, WE, CLK: in std_logic;
         ADDR: in unsigned(31 downto 0);
         Mem_Bus: inout unsigned(31 downto 0));
  end component;
  
  constant N: integer := 8;
  constant W: integer := 26;
  type Iarr is array(1 to W) of unsigned(31 downto 0);
  constant Instr_List: Iarr := (
    x"30000000", -- andi $0, $0, 0  => 0. $0 = 0  
    x"20010006", -- addi $1, $0, 6  => 1. $1 = 6
    x"34020012", -- ori $2, $0, 18  => 2. $2 = 18
    x"00221820", -- add $3, $1, $2  => 3. $3 = $1 + $2 = 24
    x"00412022", -- sub $4, $2, $1  => 4. $4 = $2 - $1 = 12
    x"00222824", -- and $5, $1, $2  => 5. $5 = $1 and $2 = 2
    x"00223025", -- or $6, $1, $2   => 6. $6 = $1 or $2 = 22
    x"0022382A", -- slt $7, $1, $2  => 7. $7 = 1 because $1<$2
    x"00024100", -- sll $8, $2, 4   => 8. $8 = 18 * 16 = 288
    x"00014842", -- srl $9, $1, 1   => 9. $9 = 6/2 = 3
    x"10220001", -- beq $1, $2, 1   => 10. Will not branch. $10 incorrect if fails.
    x"8C0A0004", -- lw $10, 4($0)   => 11. $10 = 5th instr = x"00412022" = 4268066
    x"14620001", -- bne $1, $2, 1   => 12. Will branch to PC+1+1. $1 wrong if fails
    x"30210000", -- andi $1, $1, 0  => 13. $1 = 0 (skipped)
    x"08000010", -- j 16            => 14. PC = 16 = PC+1+1. $2 wrong if fails
    x"30420000", -- andi $2, $2, 0  => 15. $2 = 0 (skipped)
    x"00400008", -- jr $2           => 16. PC = $2 = 18 = PC+1+1. $3 wrong if fails
    x"30630000", -- andi $3, $3, 0  => 17. $3 = 0 (skipped)
    x"AC030040", -- sw $3, 64($0)   => 18. Mem(64) = $3
    x"AC040041", -- sw $4, 65($0)   => Mem(65) = $4
    x"AC050042", -- sw $5, 66($0)   => Mem(66) = $5
    x"AC060043", -- sw $6, 67($0)   => Mem(67) = $6
    x"AC070044", -- sw $7, 68($0)   => Mem(68) = $7
    x"AC080045", -- sw $8, 69($0)   => Mem(69) = $8
    x"AC090046", -- sw $9, 70($0)   => Mem(70) = $9
    x"AC0A0047"  -- sw $10, 71($0)  => Mem(71) = $10
);
    -- The last instructions perform a series of sw operations that store 
    -- registers 3-10 to memory. During the memory write stage, the testbench 
    -- will compare the value of these registers (by looking at the bus value) 
    -- with the expected output. No explicit check/assertion for branch 
    -- instructions, however if a branch does not execute as expected, an error 
    -- will be detected because the assertion for the instruction after the 
    -- branch instruction will be incorrect.
  type output_arr is array(1 to N) of integer;
  constant expected: output_arr:= (24, 12, 2, 22, 1, 288, 3, 4268066);
  signal CS, WE, CLK: std_logic := '0';
  signal Mem_Bus, Address, AddressTB, Address_Mux: unsigned(31 downto 0);
  signal RST, init, WE_Mux, CS_Mux, WE_TB, CS_TB: std_logic;
begin
  CPU: MIPS port map (CLK, RST, CS, WE, Address, Mem_Bus);
  MEM: Memory port map (CS_Mux, WE_Mux, CLK, Address_Mux, Mem_Bus);

  CLK <= not CLK after 10 ns;
  Address_Mux <= AddressTB when init = '1' else Address; 
  WE_Mux <= WE_TB when init = '1' else WE;
  CS_Mux <= CS_TB when init = '1' else CS;

  process
  begin
    rst <= '1';
    wait until CLK = '1' and CLK'event;

    --Initialize the instructions from the testbench
    init <= '1';
    CS_TB <= '1'; WE_TB <= '1';
    for i in 1 to W loop
      wait until CLK = '1' and CLK'event;
      AddressTB <= to_unsigned(i-1,32);
      Mem_Bus <= Instr_List(i);
    end loop; 
    wait until CLK = '1' and CLK'event;
    Mem_Bus <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
    CS_TB <= '0'; WE_TB <= '0';
    init <= '0';
    wait until CLK = '1' and CLK'event;
    rst <= '0';
    
    for i in 1 to N loop
      wait until WE = '1' and WE'event;  -- When a store word is executed
      wait until CLK = '0' and CLK'event;
      assert(to_integer(Mem_Bus) = expected(i))
        report "Output mismatch:" severity error;
    end loop;

    report "Testing Finished:";
  end process;
end test;