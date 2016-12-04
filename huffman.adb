with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Ada.Text_Io; use Ada.Text_Io;
with File_Priorite;
with Dico; use Dico;
with Code; use Code;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;

package body huffman is 

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
	end Libere_Arbre;


	procedure Libere(H :in out Arbre_Huffman) is
		begin
			Libere_Arbre(H.A);
			Free(H.Nb_Total_Caracteres));
			Free(H);
	end Libere;

	-- Procedure recursive syr les Arbres 	
	procedure Affiche_Arbre(A : in Arbre) is
		begin
			Put(A.Char);
			Affiche(A.Fg);
			Affiche(A.Fd);
	end Affiche_Arbre;


	procedure Affiche(H : in Arbre_Huffman) is
		begin
			Put("le nb de caracteres est :");
			New_Line;
			Put(Nb_Total_Caracteres);
			New_Line;
			Affiche_Arbre(H.A);
	end Affiche;

	
	
	function Cree_Huffman(Nom_Fichier : in String) is
		Fichier : Ada.Streams.Stream_IO.File_Type;
		Flux : Ada.Streams.Stream_IO.Stream_Access;
		C : Character;
		i,j : Integer;
		prio1, prio2 : Integer;
		Nb_Total_Caracteres : Natural := 0;
		A : Arbre;
		Dico : Dico_Caracteres := Cree_Dico;
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
	end Cree_Huffman;


	
	function Ecrit_Huffman(H : in Arbre_Huffman ; Flux : Ada.Streams_IO.Stream_Access) is

		Dictionnaire : Dico_Caracteres;
        i : Integer;
		Code_Bin : Code_Binaire := Cree_Code;
		A : Arbre := H.A;
		Nb_Octets_Ecrits : Positive := 0;
		Nb_Caracteres_Diff : Natural := Nb_Caracteres_Differents(D);
		Infos : Info_Caractere;
		Stock_Dico : Stockage_Dico
		begin
		
			-- On cree le dictionnaire associe a l'arbre afin de le stocker
			Dictionnaire := Genere_Dictionnaire(H);

			-- On ecrit ce dictionnaire dans le fichier ouvert
			Stock_Dico := Genere_Tableau_Stockage(Dictionnaire);
			Natural'Output(Flux, Nb_Caracteres_Diff);

			for i in Stock_Dico'Range loop --si ca ne marche pas : for i in 0..Nb_Caracteres_Diff loop
				Character'Output(Flux, Stock_Dico(i).C);
				Natural'Output(Flux, Stock_Dico(i).L);
				Nb_Octets_Ecrits := Nb_Octets_Ecrits + Natural'size + Character'size;
			end loop;


			-- on ecrit le nb d'octets
			Positive'Output(Flux, Nb_Octets_Ecrits);
			-- on retourne le nb d'octets ecrits
			return Nb_Octets_Ecrits;
	end Ecrit_Huffman;



	function Lit_Huffman(Flux : Ada.Streams.Stream_IO.Stream_Access)
		Nb_Caracteres_Diff : Natural;
		H : Arbre_Huffman;
		begin
			Nb_Caracteres_Diff := Natural'Input(Flux);
			for i : Integer in 0..Nb_Caracteres_Diff loop
				
			end loop;

			

			return Arbre_Huffman;
	end Ecrit_Huffman;


	function Est_Feuille(A : Arbre) is
	begin 
		if (A.Fg=null & A.Fd=null) then
			return True;
		else
			return False;
		end if;
	end Est_Feuille;

	function Genere_Dictionnaire(H : in Arbre_Huffman)
	Dico : Dico_Caracteres := Cree_Dico; 
	begin
		Genere_Dictionnaire(H.A, Dico, File);
		return Dico;
	end Genere_Dictionnaire;


	procedure Genere_Dictionnaire(A: in Arbre; D: in out Dico_Caracteres; F: in out File) is
    		Code: Code_Binaire;
    		Caractere: Character;
		begin
    		if (Est_Feuille(A) then
        		Caractere := A.Char; 
				-- a recuperer dans l'arbre
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

	end Get_Caractere;
end huffman;
