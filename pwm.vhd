library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;

entity PWM_Module is
	port(
			Clk		: in std_logic;							-- Clk Girisi
			A	 	: in std_logic_vector(15 downto 0);		-- Kontrol Girisleri
			B	 	: in std_logic_vector(15 downto 0);
			
			-- out --
			PWM_Out	: out std_logic							-- PWM Cikisi
	);
end PWM_Module;

architecture arch of PWM_Module is

begin

		-- PWM Sinyalinin Uretilecegi process --
		process(Clk, A, B)
		variable Sayac : unsigned(15 donwto 0) := (others => '0');
		begin
			if rising_edge(Clk) then
				-- Sayac, A'dan kucukse Sayaca +1 ekle
				if Sayac < unsigned(A) then
				Sayac := Sayac + 1;
				-- Degilse sifirla
				else Sayac := (others => '0');
			end if;
			
			-- Sayac, B den kucukse PWM_Out degeri '0' olsun
			if Sayac < unsigned(B) then
			PWM_Out <= '0';
			-- Degilse '1' olsun
			else
				PWM_Out <= '1';
			end if;
		end process;
end arch;		