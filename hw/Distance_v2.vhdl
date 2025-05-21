
-- Company: 
-- Engineer: mowly k 
-- 
-- Create Date: 08/14/2024 03:36:36 PM
-- Design Name: 
-- Module Name: Distance_v2 - rtl
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
--library EXTMATH;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
--use ieee.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Distance_v2 is
  Port (
    DataIn : in STD_LOGIC_VECTOR (23 downto 0); -- Data Input
    CLK : in STD_LOGIC; -- Clock
    StrobeIN : in STD_LOGIC; -- Strobe In for control
    Reset : in STD_LOGIC; -- Reset
    DataOut : out STD_LOGIC_VECTOR (4 downto 0) := (others => '0'); -- Data Output
    Busy : out STD_LOGIC; -- Busy stage
    StrobeOut : out STD_LOGIC); -- Strobe out   
end Distance_v2;

architecture rtl of Distance_v2 is
    -- Signals for Data Vector for Storing
    SIGNAL X2 : STD_LOGIC_VECTOR ( 7 DOWNTO 0 );
    SIGNAL X1 : STD_LOGIC_VECTOR ( 7 DOWNTO 0 );
    SIGNAL Y2 : STD_LOGIC_VECTOR ( 7 DOWNTO 0 );
    SIGNAL Y1 : STD_LOGIC_VECTOR ( 7 DOWNTO 0 );
    SIGNAL Z2 : STD_LOGIC_VECTOR ( 7 DOWNTO 0 );
    SIGNAL Z1 : STD_LOGIC_VECTOR ( 7 DOWNTO 0 );
    -- Registers for store temporary first read (Since Cycle time is = 2 c.c)
    SIGNAL Z2_reg : STD_LOGIC_VECTOR ( 7 DOWNTO 0 );
    SIGNAL Z1_reg : STD_LOGIC_VECTOR ( 7 DOWNTO 0 );
    SIGNAL X2_reg : STD_LOGIC_VECTOR ( 7 DOWNTO 0 );
    -- Register for output data
    SIGNAL out_reg : STD_LOGIC_VECTOR ( 8 DOWNTO 0 );    
    -- Enable logic for enabling ROOT operator
    SIGNAL rt1_en : std_logic := '0';    
    -- Enable logic for enabling MUL operators
    SIGNAL mul1_en : std_logic := '0';
    SIGNAL mul2_en : std_logic := '0';
    SIGNAL mul3_en : std_logic := '0'; 
    -- Square root data out valid
    SIGNAL sqrt_valid : std_logic;
    
    SIGNAL res_pre : std_logic := '0';
    -- Busy and strobe_out signals for internal use
    SIGNAL strobe_out : std_logic := '0';
    -- Stobe in signal for internal use
    SIGNAL strobe_in_internal: std_logic := '0';
    --Registers for each operation separately
    SIGNAL op1_reg : STD_LOGIC_VECTOR ( 7 DOWNTO 0 ) := (others => '0');
    SIGNAL op2_reg : STD_LOGIC_VECTOR ( 7 DOWNTO 0 ) := (others => '0');
    SIGNAL op3_reg : STD_LOGIC_VECTOR ( 7 DOWNTO 0 ) := (others => '0');
    SIGNAL op4_reg : STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) := (others => '0');
    SIGNAL op5_reg : STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) := (others => '0');
    SIGNAL op6_reg : STD_LOGIC_VECTOR ( 15 DOWNTO 0 ) := (others => '0');
    SIGNAL op7_reg : STD_LOGIC_VECTOR ( 16 DOWNTO 0 ) := (others => '0');
    SIGNAL op8_reg : STD_LOGIC_VECTOR ( 17 DOWNTO 0 ) := (others => '0');
    
    --Register to hold value for a floor
    SIGNAL A_reg  : std_logic_vector(15 downto 0);
    
    -- State indicator
    type t_state is (INIT,S_1,S_2,S_3,S_4,S_5,S_6);
    SIGNAL state : t_state;
    
    --Counter for Latency indicator
    signal counter : unsigned(2 downto 0) := (others => '0');
    signal latency : integer := 6;
    signal opn_done : std_logic := '0';
    signal strobeIn_prev : std_logic := '0';
    
        
    COMPONENT mult
    PORT (
        CLK : IN STD_LOGIC;
        A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        CE : IN STD_LOGIC;
        P : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
    END COMPONENT;
    
    component sqrtROM is
        port (
            Clk    : in  std_logic;                       -- Clock signal
            en     : in  std_logic;
            Addr   : in  std_logic_vector(17 downto 0);   -- 18-bit Address input
            SqRoot : out std_logic_vector(8 downto 0);     -- 9-bit Square Root output
            data_valid : out std_logic
        );
    end component;
begin
    StrobeOut <= strobe_out;

    Data_load: process(CLK, StrobeIN)
        variable internal_mux : std_logic := '1';
    begin
        
        if(CLK'Event and CLK ='1') then
            if(StrobeIN ='1') then
                if(internal_mux = '1') then
                    Z2   <= DataIn(23 downto 16);
                    Z1   <= DataIn(15 downto 8);
                    X2   <= DataIn(7 downto 0);
                else 
--                    Z2 <= Z2_reg;
--                    Z1 <= Z1_reg;
--                    X2 <= X2_reg;
                    X1 <= DataIn(23 downto 16);
                    Y2 <= DataIn(15 downto 8);
                    Y1 <= DataIn(7 downto 0);
                    strobe_in_internal <= '1'; 
                          
                end if;  
                internal_mux := not internal_mux;       
           elsif opn_done = '1' then
                strobe_in_internal <= '0';    
            end if;            
        end if;
    end process;

    RESULT_COMB: process(all)
    begin
        if (res_pre = '0') then
            DataOut     <= '0' & out_reg(8 downto 5); --& "0";    
        elsif (res_pre = '1') then
                DataOut     <= out_reg(4 downto 0);
        end if;        
    end process;
    
    streamDone_prcs:process(clk)
    variable strobeIn_transition : std_logic;
    begin
        if clk'event and clk = '1' then 
            if strobeIn = '0' and strobeIn_prev = '1' then
                strobeIn_transition := '1';
--            else 
--                strobeIn_transition := '0';
            end if;
            
            if strobeIn_transition = '1' and counter < to_unsigned(latency,counter'length) then
                counter <= counter + 1;
            elsif strobeIn_transition = '1' then 
                counter <= (others => '0');
                opn_done <= '1';
                strobeIn_transition := '0';
            else
                opn_done <= '0';
            end if; 
            strobeIn_prev <= strobeIn;
        end if;           
    end process;
    
    
    FSM_SYNC: process(CLK, reset,strobe_in_internal)
    begin
        if(reset = '1')then -- if Reset is activated stages and signals is set to default
            state <= INIT;
--            busy  <= '0';
            mul1_en     <= '0';
            mul2_en     <= '0';
            mul3_en     <= '0';
            res_pre     <= '0';
            rt1_en      <= '0';
--            res_pos     <= '0';
            --busy_out <= '0';
            
        else 
            if(CLK'Event and CLK ='1') then
--                res_pre <= not res_pre;
                case state is 
                    when INIT => -- state 0, Stage 1
                        if strobe_in_internal = '1' then
                            busy        <= '1'; --start of operation
                            op1_reg     <= std_logic_vector(abs(signed(X2) - signed(X1)));  
                            op2_reg     <= std_logic_vector(abs(signed(Y2) - signed(Y1)));                        
                            op3_reg     <= std_logic_vector(abs(signed(Z2) - signed(Z1)));
                            mul1_en     <= '1';
                            mul2_en     <= '1';
                            mul3_en     <= '1';
                            state       <= S_1; 
                        else                             
                            busy        <= '0';
                            mul1_en     <= '0';
                            mul2_en     <= '0';
                            mul3_en     <= '0';
                            res_pre     <= '0';
                            rt1_en      <= '0';  
                            state <= INIT;
                        end if;                                  
                    when S_1 =>  --State 1, Stage 2
                        op3_reg     <= std_logic_vector(abs(signed(Z2) - signed(Z1))); --second vector of Z.  
                        state       <= S_2;
                    when S_2 =>  --State 2, Stage 3
                        op1_reg     <= std_logic_vector(abs(signed(X2) - signed(X1)));  --second Vector of X and Y. 
                        op2_reg     <= std_logic_vector(abs(signed(Y2) - signed(Y1)));    
                        state       <= S_3;
                    when S_3 => -- State 3, Stage 4
                        op3_reg     <= std_logic_vector(abs(signed(Z2) - signed(Z1))); --third Vector of Z
                        A_reg       <= op6_reg;
                        op7_reg     <= ('0' & op4_reg) + ('0' & op5_reg);  -- first vector calc.
                        state       <= S_4;
                    when S_4 => --State 4, Stage 5
                        op1_reg     <= std_logic_vector(abs(signed(X2) - signed(X1))); --Third Vector of X and Y.
                        op2_reg     <= std_logic_vector(abs(signed(Y2) - signed(Y1)));
                        op8_reg     <= ('0' & op7_reg) + ('0' & A_reg);  -- first vector calc.     
                        rt1_en      <= '1';
    --                    res_pre     <= '1';                
                        state       <= S_5;
                    when S_5 => -- State 5, Stage 6
                        op7_reg     <= ('0' & op4_reg) + ('0' & op5_reg); -- second vector calc.
                        op3_reg     <= std_logic_vector(abs(signed(Z2) - signed(Z1)));  -- fourth vector of Z
                        A_reg       <= op6_reg;
                        res_Pre     <= '1';
                        state       <= S_6;
                    when S_6 =>  -- State 6, Stage 7
                        op8_reg     <= ('0' & op7_reg) + ('0' & A_reg);  -- second vector calc.              
                        op1_reg     <= std_logic_vector(abs(signed(X2) - signed(X1))); -- Fourth Vector of X and Y. 
                        op2_reg     <= std_logic_vector(abs(signed(Y2) - signed(Y1)));
                        res_Pre     <= not res_pre;
                        if strobe_in_internal = '0' then
                            state <= INIT ;
                            busy <= '0';
                        else 
                            state <= S_5;  
                        end if; 
                    end case;           
            end if;
        end if;
    end process;                       
     -- Component MUL1 for Square Multiplier of first vector substuction
    MUL1: mult
    port map (
        clk => CLK,
        ce => mul1_en,
        a => op1_reg,
        b => op1_reg,
        p => op4_reg);
    -- Component MUL2 for Square Multiplier of Second vector substuction
    MUL2: mult
    port map (
        clk => CLK,
        ce => mul2_en,
        a => op2_reg,
        b => op2_reg,
        p => op5_reg);
-- Component MUL1 for Square Multiplier of Third vector substuction
    MUL3: mult
    port map (
        clk => CLK,
        ce => mul2_en,
        a => op3_reg,
        b => op3_reg,
        p => op6_reg);  
         
   -- Component RT1 for Square Root of Final Result        
    RT1: sqrtROM
    port map (
        clk => CLK,
        en  => RT1_en,
        Addr => op8_reg,
        sqroot => out_reg,
        data_valid => sqrt_valid );         
        
end rtl;
