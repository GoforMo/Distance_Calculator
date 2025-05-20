----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/11/2024 05:10:07 PM
-- Design Name: 
-- Module Name: tb - sim
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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb is
--  Port ( );
end tb;

architecture sim of tb is
begin
--    block_1 : block
   
--        signal clk : std_logic := '1';
--        constant clkperiod : time := 10 ns;
        
--        signal X2,X1,Y2,Y1,Z2,Z1                  : std_logic_vector(7 downto 0);
--        signal dataIn                             : std_logic_vector(23 downto 0);
--        signal enable                             : std_logic := '0';
--        signal strobeIn                           : std_logic;
--        signal reset,busy,strobeOut               : std_logic; 
--        signal dataOut                            : std_logic_vector(4 downto 0);  
        
--    begin
--        Clk <= not clk after clkperiod/2;  --simulation clk
--        --strobeIn    <= not strobeIn after clkperiod when enable = '1' else '0'; --gated strobeIn
        
--        DUT : entity work.Distance(behavioral)
--        port map(
--                DataIn      => dataIn,
--                CLK         => clk,
--                StrobeIN    => strobeIn,
--                Reset       => reset,
--                DataOut     => dataOut,
--                Busy        => busy,
--                StrobeOut   => strobeOut
--        );
        
--        --X2 = 8 , X1 = 4, Y2 = 18, Y1 = 9, Z2 = 7, Z1 = 4
--        --need to send in 24 bits per clock cycle.
--        process is
--        begin
            
--            wait for clkperiod*2;
--            wait until rising_edge(clk);
            
--            X2          <= std_logic_vector(to_unsigned(8,dataIn'length/3));
--            X1          <= std_logic_vector(to_unsigned(4,dataIn'length/3));
--            Y2          <= std_logic_vector(to_unsigned(18,dataIn'length/3));
--            Y1          <= std_logic_vector(to_unsigned(9,dataIn'length/3));
--            Z2          <= std_logic_vector(to_unsigned(7,dataIn'length/3));
--            Z1          <= std_logic_vector(to_unsigned(4,dataIn'length/3));    
            
--            reset       <= '1';
--            wait for clkperiod*10;
--            reset       <= '0';
--            --enable      <= '1';
--            wait for clkperiod*2;
--            wait until rising_edge(clk); 
--            strobeIn    <= '1';           
--            dataIn      <= X2 & X1 & Y2;
--            wait until rising_edge(clk);
--            dataIn      <= Y1 & Z2 & Z1;
--            wait until rising_edge(clk);
--            wait until busy = '0';
--            wait for clkperiod*2;
--            assert false;
--            report "Simulation stopped." severity failure;     
--            wait;  
--          end process;
--    end block block_1;
    
    block_2 : block
   
        signal clk : std_logic := '1';
        constant clkperiod : time := 10 ns;
        
        signal dataIn : std_logic_vector(23 downto 0);
        signal enable : std_logic := '0';
        signal strobeIn : std_logic := '0';
        signal reset : std_logic := '0';
        signal busy, strobeOut : std_logic;
        signal dataOut : std_logic_vector(4 downto 0);  
        
     -- Declare a 6x10 matrix of integers
        type int_matrix is array (0 to 5, 0 to 9) of integer;
    
        -- Initialize the matrix with some negative values
        constant matrix : int_matrix := (
            (-8, -10, 0, 0, 0, 0, 0, 0, 0, 0),
            (4, 5, 0, 0, 0, 0, 0, 0, 0, 0),
            (-18, 7, 0, 0, 0, 0, 0, 0, 0, 0),
            (9, 13, 0, 0, 0, 0, 0, 0, 0, 0),
            (7, -9, 0, 0, 0, 0, 0, 0, 0, 0),
            (4, 6, 0, 0, 0, 0, 0, 0, 0, 0)
        );
        
        -- Test vector arrays (6 vectors) for second example
        type test_vector_array is array (0 to 5) of std_logic_vector(7 downto 0);
        type integer_vector_array is array (0 to 5) of integer;
        type slv_vector_array is array (0 to 5) of std_logic_vector(7 downto 0);
        signal X2_slv_array,X1_slv_array,Y2_slv_array,Y1_slv_array,Z2_slv_array,Z1_slv_array : slv_vector_array;  
        
--        signal X2_vectors : test_vector_array := (
--            "00001000", "00001101", "00010101", "00010110", "00010111", "00011000"
--        );
        
--        signal X1_vectors : test_vector_array := (
--            "00000100", "11110110", "00000011", "00000100", "00000101", "00000110"
--        );

--        signal Y2_vectors : test_vector_array := (
--            "00010010", "11110111", "00011011", "00011100", "00011101", "00011110"
--        );
        
--        signal Y1_vectors : test_vector_array := (
--            "00001001", "00000101", "00001001", "00001010", "00001011", "00001100"
--        );
        
--        signal Z2_vectors : test_vector_array := (
--            "00000111", "00000110", "00100001", "00100010", "00100011", "00100100"
--        );
        
--        signal Z1_vectors : test_vector_array := (
--            "00000100", "00000111", "00001111", "00010000", "00010001", "00010010"
--        );
        
        signal X2_vectors_int : integer_vector_array := (
            -8, -127, 100, -20, -55, 5
        );    
        
        signal X1_vectors_int : integer_vector_array := (
            4, -127, 65, 8, 2, -3
        );     
 
        signal Y2_vectors_int : integer_vector_array := (
            -18, 33, 6, 17, -6, 37
        );      
        
        signal Y1_vectors_int : integer_vector_array := (
            9, -6, 19, 31, -25, -120
        );
        
        signal Z2_vectors_int : integer_vector_array := (
            7, 0, 19, -1, 9, 11
        ); 
        
        signal Z1_vectors_int : integer_vector_array := (
            4, 15, 10, 2, 77, 23
        );         
           
        -- Function to convert an integer to std_logic_vector
        function int_to_slv(value : integer; size : integer) return std_logic_vector is
        begin
            return std_logic_vector(to_signed(value, size));
        end function;
    
        -- Declare a 6x10 matrix of std_logic_vectors
        type slv_matrix is array (0 to 5, 0 to 9) of std_logic_vector(7 downto 0);
        signal slv_mat : slv_matrix;
            
    begin
        -- Clock generation
        clk <= not clk after clkperiod/2;
        
        -- Device Under Test (DUT)
        DUT : entity work.Distance_v2(rtl)
            port map(
                DataIn      => dataIn,
                CLK         => clk,
                StrobeIN    => strobeIn,
                Reset       => reset,
                DataOut     => dataOut,
                Busy        => busy,
                StrobeOut   => strobeOut
            );
        
        -- Test process
        
        -- Process to convert int_matrix to slv_matrix
        matrix_fsm:process
        begin
            -- Convert each element in the integer matrix to std_logic_vector
            for i in 0 to 5 loop
                for j in 0 to 9 loop
                    slv_mat(i, j) <= int_to_slv(matrix(i, j), 8);
                end loop;
            end loop;
    
            -- Simulate some delay
            wait for 10 ns;
            wait;
        end process;
        
        int2slv_array_fsm:process
        begin
            -- Convert each element in the integer matrix to std_logic_vector
            for i in 0 to 5 loop
                X2_slv_array(i) <= int_to_slv(X2_vectors_int(i), 8);
                X1_slv_array(i) <= int_to_slv(X1_vectors_int(i), 8);
                Y2_slv_array(i) <= int_to_slv(Y2_vectors_int(i), 8);
                Y1_slv_array(i) <= int_to_slv(Y1_vectors_int(i), 8);
                Z2_slv_array(i) <= int_to_slv(Z2_vectors_int(i), 8);
                Z1_slv_array(i) <= int_to_slv(Z1_vectors_int(i), 8);
            end loop;
    
            -- Simulate some delay
            wait for 10 ns;
            wait;
        end process;
        
--        DUT_FSM:process
--        begin
--            -- Initialize signals
--            reset <= '1';
--            strobeIn <= '0';
--            dataIn <= (others => '0');
            
--            wait for clkperiod*2;
--            wait until rising_edge(clk);
            
--            -- Deassert reset after a few clock cycles
--            reset <= '0';
            
            
--            -- Wait for a few clock cycles after reset
--            wait for clkperiod*2;
--            wait until rising_edge(clk);
--                    -- Convert each element in the integer matrix to std_logic_vector
                    
--            -- Send first 24-bit data (X2, X1, Y2)
--            wait for clkperiod;
--            strobeIn    <= '1';
--            for i in 0 to 9 loop
--                wait until rising_edge(clk);
--                dataIn      <= slv_mat(0,i) & slv_mat(1,i) & slv_mat(2,i);
--                wait until rising_edge(clk);
--                dataIn      <= slv_mat(3,i) & slv_mat(4,i) & slv_mat(5,i);
                
--            end loop;
--            strobeIn    <= '0';
--            wait until rising_edge(clk);
            
--            -- Send second 24-bit data (Y1, Z2, Z1)

--            wait until rising_edge(clk);
----            strobeIn <= '0';
            
--            -- Wait for DUT to finish processing
----            wait until busy = '0';            
--            -- Wait a few more clock cycles and then finish
--            wait for clkperiod*2;
--            assert false report "Simulation stopped." severity failure;
--            wait;
--        end process;
         -- Stimulus process
        process
        begin
            -- Initialize
            reset <= '1';
            wait for clkperiod * 10;
            reset <= '0';
            wait for clkperiod * 2;
            wait until falling_edge(clk);
            strobeIn <= '1';

            for i in 0 to 5 loop

                   
                -- Send X1, Y1, Z1
                
                dataIn <= Z2_slv_array(i) & Z1_slv_array(i) & X2_slv_array(i);
                wait until falling_edge(clk);
    
                -- Send X2, Y2, Z2
                dataIn <= X1_slv_array(i) & Y2_slv_array(i) & Y1_slv_array(i);
                wait until falling_edge(clk);
    
--                -- Wait for Busy to clear
--                wait until busy = '0';
            end loop;
            strobeIn    <= '0';
            wait for clkperiod*2;
            -- End simulation
            assert false
            report "Simulation completed successfully." severity failure;
            wait;
        end process;
    end block block_2;
end sim;
