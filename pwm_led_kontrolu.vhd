library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;

entity PWM_Led is
	port(
			Clk 	: in std_logic;			
			
			-- Out
			Led		: out std_logic_vector(15 downto 0) 
	);
end PWM_Led;

architecture arc of PWM_Led is

	-- PWM komponentini cagiralim
	component PWM_Module 
	port(
			Clk		: in std_logic;							-- Clk Girisi
			A	 	: in std_logic_vector(15 downto 0);		-- Kontrol Girisleri
			B	 	: in std_logic_vector(15 downto 0);
			
			-- out --
			PWM_Out	: out std_logic							-- PWM Cikisi
	);
end component;

	-- Ara sinyalleri tanimlayalim
	signal PWM_Out : std_logic;
	signal B : std_logic_vector(15 downto 0) := (others => '0');

begin
	
	-- PWM frekansı hesaplama	Clk/A
	-- 50Mhz / 0x01F4 = 100Khz olarak ayarlandı PWM Frekansı
	PWM : PWM_Module
		port map(
			
		--	baglanti sekli: sirali baglama 
					Clk		  	=>	 	Clk , 																
					x"01F4"	  	=>	 	A	,                 		-- decimal 500 sayisi                                       
					B		  	=>	 	B	,                                                              
					PWM_Out     =>	  PWM_Out                                                    
		
		--  ayni manaya gelen farkli bir baglanti sekli : pozisyonel baglama

				--	Clk, 	
				--	x"01F4", 
				--	B,       
				--	PWM_Out 
		
		);

	process(Clk)
	variable sayac			 : integer range 0 to 25000 := 0;
	variable yukari_asagi	 : boolean := true;
	begin
			-- 100Khz cikisli clk bolucu
		if rising_edge(clk) then
				if sayac < 24999 then
					sayac := sayac + 1;
				else
					sayac := 0;
			
			-- Duty Cycle Hesabi
			
			-- yukari_asagi degiskeni true ise B sinyalinin degerini 1 arttir
			if yukari_asagi then
				B <= std_logic_vector(unsigned(B) + 1 );
			
			-- degilse yani false ise 1 azalt
			else
				B <= std_logic_vector(unsigned(B) - 1);
				
			end if;
			end if;
			
			-- Duty Cycle = 1 - B/A formulunden hesaplanir asagidaki if-else bloguna göre:
			-- Duty Cycle orani % 10-80 arasinda degismekte
			
			if unsigned(B) > 449 then 	
			yukari_asagi := false;
			
			elsif unsigned(B) < 101 then
			yukari_asagi := true;
			end if;
		end if;
	end process;
	
	-- Butun ledleri PWM_Out sinyaline bagla
	Leds : for i in 0 to 15 generate
		Led(i) <= PWM_Out;
	end generate;	
			
end arc;	