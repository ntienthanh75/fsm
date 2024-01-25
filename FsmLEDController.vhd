LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY fsm IS
PORT (
   clk         : IN  STD_LOGIC;
   reset       : IN  STD_LOGIC;
   ledOutput_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
   buzz        : out STD_LOGIC --buzz output
   );
END ENTITY fsm;

ARCHITECTURE Behavior OF fsm IS
   SIGNAL clk1         : STD_LOGIC;
   SIGNAL clk2         : STD_LOGIC;

   TYPE StateType IS (StateA, StateB, StateC, StateD, StateE, StateF);
   SIGNAL currentState : StateType;

   SIGNAL ledOutput_r  : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN
   ledOutput_o <= ledOutput_r;
   buzz <= '1';

   gen_clk1 : PROCESS (clk)
   VARIABLE count : INTEGER RANGE  0 TO 9999999;
   BEGIN
      IF clk'event AND clk = '1' THEN
         IF count <= 4999999 THEN
            clk1  <= '0';
            count := count+1;
         ELSIF count >= 4999999 AND count <= 9999999 THEN
            clk1  <='1';
            count := count+1;
         ELSE 
            count := 0;
         END IF;
      END IF;
   END PROCESS gen_clk1;

   gen_clk2 : PROCESS(clk1)   
   begin
      IF clk1'event AND clk1 = '1' THEN  
         clk2 <= not clk2;
      END IF; 
   END PROCESS gen_clk2;

   fsm_process : PROCESS (clk2, reset)
   BEGIN
      IF (reset = '0') THEN
         currentState <= StateE;
      ELSIF clk2'event AND clk2='1' THEN
         CASE currentState IS
            WHEN StateA =>
               currentState <= StateB;
            WHEN StateB =>
               currentState <= StateC;
            WHEN StateC =>
               currentState <= StateD;
            WHEN StateD =>
               currentState <= StateA;
            WHEN StateE =>
               currentState <= StateF;
            WHEN others => 
               currentState <= StateA;
         END CASE;
      END IF;
   END PROCESS fsm_process;

   -- Output assignment for 4 LEDs based on currentState
   CTRL : PROCESS (clk2, reset)
   BEGIN
      IF (reset = '0') THEN
         ledOutput_r <= (others => '0');

      ELSIF clk2'event AND clk2='1'THEN
         IF currentState = StateA THEN
            ledOutput_r <= "0001";
         END IF;

         IF currentState = StateB THEN
            ledOutput_r <= "0010";
         END IF;

         IF currentState = StateC THEN
            ledOutput_r <= "0100";
         END IF;
         
         IF currentState = StateD THEN
            ledOutput_r <= "1000";
         END IF;
      END IF;
   END PROCESS CTRL;

END ARCHITECTURE Behavior;
