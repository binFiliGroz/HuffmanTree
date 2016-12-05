with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Ada.Text_Io; use Ada.Text_Io;
with File_Priorite;
with Dico; use Dico;
with Code; use Code;
with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Ada.Unchecked_Deallocation;


package body huffman is 


	type Octet is new Integer range 0..255;
	for Octet'Size use 8;



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

type Tableau_Char is array (integer range 0..255) of Integer;
	
	procedure free_Arbre is new Ada.Unchecked_Deallocation(Noeud, Arbre);

	-- Procedure recursive sur les Arbres (Huffman Tree : Contient 1 arbre et des données)
	procedure Libere(H : in out Arbre_Huffman) is
		procedure Libere_Arbre(A : in out Arbre) is
			begin
				if (A.Fd /= null) then
					Libere_Arbre(A.Fd);
				elsif (A.Fg /=null) then
					Libere_Arbre(A.Fg);
				end if;
				free_Arbre(A);
		end Libere_Arbre;

		begin
			Libere_Arbre(H.A);
			free(H.Nb_Total_Caracteres);
			Free(H);
	end Libere;

	-- Procedure recursive sur les Arbres 	
	
	
	procedure Affiche(H : in Arbre_Huffman) is
		procedure Affiche_Arbre(A : in Arbre) is
			begin
				Put(A.Char);
				Affiche_Arbre(A.Fg);
				Affiche_Arbre(A.Fd);
		end Affiche_Arbre;

		begin
			Put("le nb de caracteres est :");
			New_Line;
			Put(H.Nb_Total_Caracteres);
			New_Line;
			Affiche_Arbre(H.A);
	end Affiche;

	
	
	function Cree_Huffman(Nom_Fichier : in String) return Arbre_Huffman is
		
		
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
		Arbre_H : Arbre_Huffman;

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

				Incremente_Nb_Occurences(C, Dico);
				Nb_Total_Caracteres := Nb_Total_caracteres + 1;
			end loop;

			-- Cree la liste de priorite
			for i in integer range 0..255 loop
				if (Est_Present(Character'Val(i),Dico)) then
					j:=Get_nb_occurences(Character'Val(i), Dico);
					A := new Noeud;
					A.Char := Character'Val(i);
					if Est_Pleine(File_Prio) then
						raise File_Pleine;
					else
						Insere(File_Prio, A, j);
					end if;
				end if;
			end loop;


			-- A partir de la liste, on cree l'arbre
			while not Est_Vide(File_Prio) loop
				A := new Noeud;
				A.Fg := new Noeud;
				Supprime(File_Prio, A.Fg, prio1);
				if not Est_Vide(File_Prio) then
					A.Fd := new Noeud;
					Supprime(File_Prio, A.Fd, prio2);
				end if;
				if Est_Vide(File_Prio) then
					Arbre_H.A := A;
					Arbre_H.Nb_Total_Caracteres := Nb_Total_Caracteres;
				else
					Insere(File_Prio, A, prio1+prio2);
				end if;
			end loop;

			Close(Fichier);
			return Arbre_H;
	end Cree_Huffman;


	
	function Ecrit_Huffman(H : in Arbre_Huffman ; Flux : Ada.Streams.Stream_IO.Stream_Access) return Positive is

		Dictionnaire : Dico_Caracteres;
        i : Integer;
		Code_Bin : Code_Binaire := Cree_Code;
		A : Arbre := H.A;
		Nb_Octets_Ecrits : Integer := 0;
		Nb_Caracteres_Diff : Natural := Nb_Caracteres_Differents(Dictionnaire);
		Infos : Info_Caractere;
		Stock_Dico : Stockage_Dico := new Stockage_Dico;
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



	function Lit_Huffman(Flux : Ada.Streams.Stream_IO.Stream_Access) return Arbre_Huffman is
		
		Procedure Recree_Arbre(It_Code : in out Iterateur_Code; Caractere : in Character; A : in out  Arbre) is 
		B : Bit;
		begin
			while Has_Next(It_Code) loop
				B := Next(It_Code);
				if (B = 0) then

					if (A.Fg = null) then
						A.Fg := new Noeud;
					end if;
					A := A.Fg;
				
				elsif (B = 1) then
					
					if (A.Fd = null) then
						A.Fg := new Noeud;
					end if;
					A := A.Fd;
				
				end if;
			end loop;
			A.Char := Caractere;

		end Recree_Arbre;
			

		Nb_Caracteres_Diff : Natural := Natural'Input(Flux);
		H : Arbre_Huffman;
		Caractere : Character;
		Longueur : Natural;
		Stock_Dico : Stockage_Dico(0..Nb_Caracteres_Diff);
		Dictionnaire : Dico_Caracteres := Cree_Dico;
		It_Code : Iterateur_Code;
		i : Integer;
		begin
			H.A := new Noeud;

		-- on recree le dictionnaire
			for i in integer range 0..Nb_Caracteres_Diff loop
				Caractere := Character'Input(Flux);
				Longueur := Natural'Input(Flux);
				Stock_Dico(i).C := Caractere;
				Stock_Dico(i).L := Longueur;
			end loop;
			
		-- Procedure en attente
			--Recree_Dico(Stock_Dico, Dictionnaire);
		
		-- On cree l'arbre a partir du dictionnaire et des codes binaires
			for i in integer range 0..Nb_Caracteres_Diff loop
				It_Code := Cree_Iterateur(Dictionnaire.C(i).Code);
				Recree_Arbre(It_Code , Stock_Dico(i).C , H.A);
			end loop;

		return H;
	end Lit_Huffman;


	function Est_Feuille(A : Arbre) return boolean is
	begin
		if (A.Fg = null and then A.Fd = null) then
			return True;
		else
			return False;
		end if;
	end Est_Feuille;

	function Genere_Dictionnaire(H : in Arbre_Huffman) return Dico_Caracteres is
	Dico : Dico_Caracteres := Cree_Dico; 
	begin
		Genere_Dico(H.A, Dico, File);
		return Dico;
	end Genere_Dictionnaire;


	procedure Genere_Dico(A: in Arbre; D: in out Dico_Caracteres; F: in out File) is
    		Code: Code_Binaire;
    		Caractere: Character;
		begin
		-- Utiliser Code
    		if (Est_Feuille(A)) then
        		Caractere := A.Char; 
				-- a recuperer dans l'arbre
        		Code := File_vers_Code(F);
        		--stockage du caractere dans le dictionnaire
        		Set_Code(Caractere, Code, D);
    		else
        		Genere_Dico(A.Fg, D, File_Plus_Zero(F));
        		Genere_Dico(A.Fd, D, File_Plus_Un(F));
    		end if;
	end Genere_Dico;


	procedure Get_Caractere(It_Code : in Iterateur_Code; A : in out Arbre; Caractere_Trouve : out Boolean; Caractere : out Character) is
			i : Integer;
			begin
				i := i + 1;
	end Get_Caractere;
end huffman;
