library ieee;
use ieee.std_logic_1164.all;
use work.Common.all;

entity System_sim is
end System_sim;

architecture Behavioral of System_sim is
  component CPU
    port (
      clk   : in std_logic;
      rst   : in std_logic;

      -- RAM
      ram_rw       : out RwType;
      ram_length   : out LenType;
      ram_addr     : out std_logic_vector (31 downto 0);
      ram_data_in  : out std_logic_vector (31 downto 0);
      ram_data_out : in  std_logic_vector (31 downto 0));
  end component;
  component MemoryVirtual
    port (
      clk      : in  std_logic;
      rst      : in  std_logic;
      rw       : in  RwType;
      length   : in  LenType;
      addr     : in  std_logic_vector (31 downto 0);
      data_in  : in  std_logic_vector (31 downto 0);
      data_out : out std_logic_vector (31 downto 0));
  end component;

  signal clk : std_logic;
  signal rst : std_logic;

  --RAM
  signal ram_rw       : RwType;
  signal ram_length   : LenType;
  signal ram_addr     : std_logic_vector (31 downto 0);
  signal ram_data_in  : std_logic_vector (31 downto 0);
  signal ram_data_out : std_logic_vector (31 downto 0);

  constant clk_period : time := 100 ns;
  
begin

  CPU_1 : CPU
    port map (
      clk          => clk,
      rst          => rst,
      ram_rw       => ram_rw,
      ram_length   => ram_length,
      ram_addr     => ram_addr,
      ram_data_in  => ram_data_in,
      ram_data_out => ram_data_out);

  MemoryVirtual_1 : MemoryVirtual
    port map (
      clk      => clk,
      rst      => rst,
      rw       => ram_rw,
      length   => ram_length,
      addr     => ram_addr,
      data_in  => ram_data_in,
      data_out => ram_data_out);

  -- clock generation, print debug messages
  process
  begin
    -- boot up
    rst <= '0', '1' after clk_period;
    clk <= '0';
    wait for 2*clk_period;

    -- tick
    loop
      clk <= '1', '0' after 0.5*clk_period;
      wait for clk_period;
    end loop;
  end process;
  

end Behavioral;