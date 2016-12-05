with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Ada.Text_Io; use Ada.Text_Io;
with Ada.Command_Line; use Ada.Command_Line;
with Huffman; use Huffman;
with Code; use Code;
with Dico; use Dico;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;


procedure tp_huffman is

------------------------------------------------------------------------------
-- COMPRESSION
------------------------------------------------------------------------------

	procedure Compresse(Nom_Fichier_In, Nom_Fichier_Out : in String) is
	Fichier_In, Fichier_Out : Ada.Streams.Stream_IO.File_Type;
	Flux_In, Flux_Out : Ada.Streams.Stream_IO.Stream_Access;
	Huf_Tree : Arbre_Huffman;
	Choix : Character := 'A';
	C : Character;
	P : Positive;
	Noms_De_Fichier_Similaires : exception;
	Code : Code_Binaire := Cree_Code;
	Dico : Dico_Caracteres := Cree_Dico;
	It_Code : Iterateur_Code;

	B : Bit;
	Nb_Total : Integer := 0;
	N : Integer := 0;
	L : Integer := 0;

	begin
		if (Nom_Fichier_In = Nom_Fichier_Out) then
			raise Noms_De_Fichier_Similaires;
			return;
		end if;
		Put("Ouverture du fichier en entree ...");
		New_Line;
		Open(Fichier_In, In_File, Nom_Fichier_In);
		Flux_In := Stream(Fichier_In);

		Put("Creation de l'arbre de Huffman associe ...");
		New_Line;
		Huf_Tree := Cree_Huffman(Nom_Fichier_In);
		
		While (((Choix /= 'Y') and then (Choix /= 'y')) and then ((Choix /= 'n') and then (Choix /= 'N'))) loop
			Put("Souhaitez-vous afficher cet arbre pour le verifier ? (Yy/Nn)");
			New_Line;
			Get_Immediate(Choix);
			New_Line;
		end loop;

		if ((Choix = 'Y') or (Choix = 'y')) then
			Affiche(Huf_Tree);
		end if;
		New_Line;
		
		Put("Creation du fichier de sortie et son flux associe ...");
		New_Line;
		Create(Fichier_Out, Out_File, Nom_Fichier_Out);
		Flux_Out := Stream(Fichier_Out);

		Put("Ecriture du Dictionnaire dans le fichier ...");
		New_Line;
		P := Ecrit_Huffman(Huf_Tree, Flux_Out);
		Put(Positive'Image(Integer(P)) & " Octets ont ete ecrits dans le fichier (pour les stats)");
		New_Line;

		Put("Generation du dictionnaire associe a l'arbre construit ...");
		New_Line;
		Dico := Genere_Dictionnaire(Huf_Tree);

		Put("Compression du fichier en entree dans celui de sortie ...");
		New_Line;



		While not End_Of_File(Fichier_In) loop
			Nb_Total := Nb_Total + 1;
			C := Character'Input(Flux_In);
			Ajoute_Apres( Get_Code(C,Dico) , Code );
		end loop;

		Close(Fichier_In);


		-- Code contient tout le fichier compresse en code binaire
		-- Il reste à le mettre sous forme d'octets
		-- Puis à le stocker dans le fichier de sortie
		It_Code := Cree_Iterateur(Code);
		While Has_Next(It_Code) loop
			While (L /= 8 and Has_Next(It_Code))  loop
				B := Next(It_Code);
				if (B = 1) then
					N := N + 2**(7-L);
				end if;
				L := L + 1;
			end loop;
			C := Character'Val(N);
			Character'Output(Flux_Out, C);
			N := 0;
			L := 0;
		end loop;

		-- Notons qu'on ne tombe pas forcement sur un dernier octet complet : on stocke la longueur valide
		-- Nombre total de caracteres : Nb_Total
		Character'Output(Flux_Out, Character'Val(Nb_Total));


		-- Le fichier compresse est maintenant stocke;

		Close(Fichier_Out);
		
		Put("Le Fichier compresse est disponible.");
		New_Line;

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

