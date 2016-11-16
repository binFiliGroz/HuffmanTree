with Ada.Text_Io; use Ada.Text_Io;
with Ada.Command_Line; use Ada.Command_Line;


procedure tp_huffman is

------------------------------------------------------------------------------
-- COMPRESSION
------------------------------------------------------------------------------

	procedure Compresse(Nom_Fichier_In, Nom_Fichier_Out : in String) is
	begin
		-- A COMPLETER!
		return;
	end Compresse;



------------------------------------------------------------------------------
-- DECOMPRESSION
------------------------------------------------------------------------------

	procedure Decompresse(Nom_Fichier_In, Nom_Fichier_Out : in String) is
	begin
		-- A COMPLETER!
		return;
	end Decompresse;


------------------------------------------------------------------------------
-- PG PRINCIPAL
------------------------------------------------------------------------------

begin

	if (Argument_Count /= 3) then
		Put_Line("utilisation:");
		Put_Line("  compression : ./huffman -c fichier.txt fichier.comp");
		Put_Line("  decompression : ./huffman -d fichier.comp fichier.comp.txt");
		Set_Exit_Status(Failure);
		return;
	end if;

	if (Argument(1) = "-c") then
		Compresse(Argument(2), Argument(3));
	else
		Decompresse(Argument(2), Argument(3));
	end if;

	Set_Exit_Status(Success);

end tp_huffman;

