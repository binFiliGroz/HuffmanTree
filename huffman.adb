with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Ada.Text_Io; use Ada.Text_Io;
with File_Priorite;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;

function Est_Prioritaire (P1, P2: Integer) return boolean is
begin
	return P1>P2;
end Est_Prioritaire;

package File_Priorite_Arbre is new File_Priorite(Arbre, Integer, Est_Prioritaire); 
use File_Priorite_Arbre;

type Noeud is record 
	Char: Character;
	Fd, Fg : Arbre;
	end record;

type Tableau_Char is array of Integer;
	

	-- Procedure recursive sur les Arbres (Huffman Tree : Contient 1 arbre et des données)
	procedure Libere_Arbre(A : in out Arbre) is
		begin
			Libere_Arbre(A.Fd);
			Libere_Arbre(A.Fg);
			Free(A);
	end procedure;


	procedure Libere(H :in out Arbre_Huffman) is
		begin
			Libere_Arbre(H.A);
			Free(H.Nb_Total_Caracteres));
	end procedure;

	-- Procedure recursive syr les Arbres 	
	procedure Affiche_Arbre(A : in Arbre) is
		begin
			Put(A.Char);
			Affiche(A.Fg);
			Affiche(A.Fd);
	end procedure;


	procedure Affiche(H : in Arbre_Huffman) is
		begin
			Put("le nb de caracteres est :");
			New_Line;
			Put(Nb_Total_Caracteres);
			New_Line;
			Affiche_Arbre(H.A);
	end procedure;

	
	
	function Cree_Huffman(Nom_Fichier : in String) is
		Fichier : Ada.Streams.Stream_IO.File_Type;
		Flux : Ada.Streams.Stream_IO.Stream_Access;
		C : Character;
		i,j : Integer;
		prio1, prio2 : Integer;
		Nb_Total_Caracteres : Natural := 0;
		A : Arbre;
		Dico : Dico := Cree_Dico;
		File_Prio : File_Priorite_Arbre := Cree_File(256);
		File_Pleine : exception;
		Arbre_Huffman : Arbre_Huffman;





		begin

			Open(Fichier, In_File, Nom_Fichier);
			Flux := Stream(Fichier);

			Put("Lecture  des Données");
			
			Put(Integer'Input(Flux));
			Put(", ");
			Put(Integer(Octet'Input(Flux))); -- cast necessaire Octet -> Integer

			-- lecture tant qu'il reste des caracteres
			

			-- Lecture et creation d'un dictionnaire
			while not End_Of_File(Fichier) loop
				C := Character'Input(Flux);
				Incremente_Dico(C,Dico);
				Nb_Total_Caracteres := Nb_Total_caracteres + 1;
			end loop;

			-- Cree la liste de priorite
			for (i in 0..255) loop
				if (Est_Present(,Dico) then
					j=Get_nb_occurences(Character'Val(i), Dico);
					A := new Arbre;
					A.Char = Character'Val(i);
					if Est_Pleine(File_Prio) then
						raise File_Pleine;
					else
						Insere(File_Prio, A, j);
					end if;
				end if;
			end loop;


			-- A partir de la liste, on cree l'arbre
			while not Est_Vide(File_Prio) loop
				A := new Arbre;
				A.Fg := new Arbre;
				Supprime(File_Prio, Fg, prio1);
				if not Est_Vide(File_Prio) then
					A.Fd := new Arbre;
					Supprime(File_Prio, Fd, prio2);
				end if;
				if Est_Vide(File_Prio) then
					Arbre_Huffman.A := A;
					Arbre_Huffman.Nb_Total_Caracteres := Nb_Total_Caracteres;
				else
					Insere(File_Prio, A, prio1+prio2);
				end if;
			end loop;



			Close(Fichier);
			return Arbre_Huffman;
	end function;


	
	function Ecrit_Huffman(H : in Arbre_Huffman ; Flux : Ada.Streams_IO.Stream_Access) is
		Fichier : Ada.Streams.Stream_IO.File_Type;
		Dictionnaire : Dico;
		Code_Bin : Code_Binaire := Cree_Code;
		A : Arbre := H.A;
		Positive : Positive := 0;
		Infos : Info_Caractere;
		begin
			Create(Fichier, Out_File, Nom_Fichier);
			Flux := Stream(Fichier);

			-- On cree le dictionnaire associe a l'arbre afin de le stocker
			Dictionnaire := Genere_Dictionnaire(H);

			-- On ecrit ce dictionnaire dans le fichier ouvert
			

			
			return Positive;
	end function;



	function Lit_Huffman(Flux : Ada.Streams.Stream_IO.Stream_Access)
		begin
			
			return Arbre_Huffman;
	end function;


	function Est_Feuille(A : Arbre) is
	begin 
		if (A.Fg=null & A.Fd=null) then
			return True;
		else
			return False;
		end if;
	end function;

	function Genere_Dictionnaire(H : in Arbre_Huffman)
	Dico : Dico_Caracteres := Cree_Dico; 
	begin
		Genere_Dictionnaire(H.A, Dico, File);
		return Dico;
	end function;


	procedure Genere_Dictionnaire(A: Arbre; D: Dico_Caracteres; F: File) is
    		Code: Code_Binaire;
    		Caractere: Character;
		begin
    		if (Est_Feuille(A) then
        		Caractere := A.Char; -- a recuperer dans l'arbre
        		Code := File_vers_Code(F);
        		--stockage du caractere dans le dictionnaire
        		Set_Code(Caractere, Code, D);
    		else
        		GenereDictionnaire(A.Fg, D, File_Plus_Zero(F));
        		GenereDictionnaire(A.Fd, D, File_Plus_Un(F));
    		end if;
	end Genere_Dictionnaire;


	procedure Get_Caractere(It_Code : in Iterateur_Code; A : in out Arbre; Caractere_Trouve : out Boolean; Caractere : out Character);
			begin

	end procedure;
