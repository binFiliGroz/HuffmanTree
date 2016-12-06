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

	package File_Priorite_Arbre is new File_Priorite(Arbre, Positive, Est_Prioritaire);
	use File_Priorite_Arbre;

	type Noeud is record
	    Char: Character;
	    Nb_Occ: Natural;
	    Fd, Fg: Arbre;
	end record;

	--type Tableau_Char is array (integer range 0..255) of Integer;

	procedure free_Arbre is new Ada.Unchecked_Deallocation(Noeud, Arbre);

	function Est_Feuille(A : Arbre) return boolean is
	begin
	    if (A.Fg = null and then A.Fd = null) then
		return True;
	    else
	        return False;
	    end if;
	end Est_Feuille;
		
	-- Procedure recursive sur les Arbres (Huffman Tree : Contient 1 arbre et des données)
	procedure Libere(H : in out Arbre_Huffman) is
	    procedure Libere_Noeud is new Ada.Unchecked_Deallocation(Noeud, Arbre);

	    procedure Libere_Arbre(A : in out Arbre) is
	    begin
		if (A /= null) then
		    Libere_Arbre(A.Fd);
		    Libere_Arbre(A.Fg);
		    Libere_Noeud(A);
		end if;
	    end Libere_Arbre;
	begin
	    Libere_Arbre(H.A);
	end Libere;

	-- Procedure recursive sur les Arbres
	procedure Affiche(H : in Arbre_Huffman) is
	    procedure Affiche_Arbre(A : in Arbre) is
	    begin
		if (A /= null) then
		    if (A.Fg = null and A.Fd = null) then
			Put(A.Char);
		    end if;
		    Affiche_Arbre(A.Fg);
		    Affiche_Arbre(A.Fd);
		end if;
	    end Affiche_Arbre;
	begin
	    Put("le nb de caracteres est :"); Put(H.Nb_Caracteres_Differents); New_Line;
	    Affiche_Arbre(H.A);
	end Affiche;

    function Cree_Huffman_Depuis_Dico(Dico : Dico_Caracteres) return Arbre_Huffman is
        Prio1, Prio2 : Integer; 
        C : Character;
        Nb_Occurences : Natural;
        File : File_Prio;
        A : Arbre;
        Arbre_H : Arbre_Huffman;
    begin
    	-- Cree la liste de priorite
		File := Cree_File(Nb_Caracteres_Differents(Dico));
		for I in integer range 0..255 loop
			C := Character'Val(I);
			if (Est_Present(C, Dico)) then
				Nb_Occurences := Get_Nb_Occurences(C, Dico);
				A := new Noeud;
				A.Char := C;
				A.Nb_Occ := Nb_Occurences;
				Insere(File, A, Nb_Occurences);
			end if;
		end loop;


		-- A partir de la liste, on cree l'arbre
		while not Est_Vide(File) loop
			A := new Noeud;
			A.Fg := new Noeud;
			Supprime(File, A.Fg, Prio1);
			if not Est_Vide(File) then
				A.Fd := new Noeud;
				Supprime(File, A.Fd, Prio2);
			end if;
			if Est_Vide(File) then
				Arbre_H.A := A;
				Arbre_H.Nb_Caracteres_Differents := Nb_Caracteres_Differents(Dico);
			else
				Insere(File, A, Prio1+Prio2);
			end if;
		end loop;

        Libere_File(File);

        return Arbre_H;
    end Cree_Huffman_Depuis_Dico;

	function Cree_Huffman(Nom_Fichier : in String) return Arbre_Huffman is
	    Fichier : Ada.Streams.Stream_IO.File_Type;
	    Flux : Ada.Streams.Stream_IO.Stream_Access;
	    C : Character;
	    Dico : Dico_Caracteres := Cree_Dico;
	    Arbre_H : Arbre_Huffman;
	begin
		Open(Fichier, In_File, Nom_Fichier);
		Flux := Stream(Fichier);

		-- Lecture et creation d'un dictionnaire
		while not End_Of_File(Fichier) loop
			C := Character'Input(Flux);
			Incremente_Nb_Occurences(C, Dico);
		end loop;

        Arbre_H := Cree_Huffman_Depuis_Dico(Dico);

		Close(Fichier);
        Libere(Dico);

		return Arbre_H;
	end Cree_Huffman;

	function Ecrit_Huffman(H : Arbre_Huffman ; Flux : Ada.Streams.Stream_IO.Stream_Access) return Positive is
		Dico : Dico_Caracteres;
		Code_Bin : Code_Binaire;
		A : Arbre := H.A;
		Nb_Octets_Ecrits : Natural := 0;
		C : Character;
		begin
			-- On cree le dictionnaire associe a l'arbre afin de le stocker
			Dico := Genere_Dictionnaire(H);

			-- On ecrit ce dictionnaire dans le fichier ouvert
			Natural'Output(Flux, Nb_Caracteres_Differents(Dico));

			for I in Natural range 0..255 loop
			    C := Character'Val(I);
			    if (Est_Present(C, Dico)) then
				Character'Output(Flux, C);
				Natural'Output(Flux, Get_Nb_Occurences(C, Dico));
			    end if;
			end loop;

			-- on retourne le nb d'octets ecrits
			return Nb_Caracteres_Differents(Dico) * (Character'Size
			+Natural'Size)  + Natural'Size;
	end Ecrit_Huffman;

	function Lit_Huffman(Flux : Ada.Streams.Stream_IO.Stream_Access) return Arbre_Huffman is
	    C : Character;
	    F : Natural;
	    H : Arbre_Huffman;
	    Nb_Caracteres_Diff : Natural;
	    Dico : Dico_Caracteres;
	begin
	    Nb_Caracteres_Diff := Natural'Input(Flux);
        
        Dico := Cree_Dico;

	    for I in integer range 0..(Nb_Caracteres_Diff-1) loop
		    C := Character'Input(Flux);
		    F := Natural'Input(Flux);
		    Set_Nb_Occurences(C, F, Dico);
	    end loop;

        H := Cree_Huffman_Depuis_Dico(Dico); 

        Libere(Dico);
	    return H;
	end Lit_Huffman;

	function Genere_Dictionnaire(H : in Arbre_Huffman) return Dico_Caracteres is
	    procedure Genere_Dico(A: in Arbre; D: in out Dico_Caracteres; Code: in out Code_Binaire) is
		CodeG, CodeD : Code_Binaire;
	    begin
		if (A /= null) then
		    if (Est_Feuille(A)) then
                Set_Nb_Occurences(A.Char, A.Nb_Occ, D);
			Set_Code(A.Char, Code, D);
		    else
			CodeG := Cree_Code(Code);
			Ajoute_Apres(ZERO, CodeG);
			Genere_Dico(A.Fg, D, CodeG);

			CodeD := Cree_Code(Code);
			Ajoute_Apres(UN, CodeD);
			Genere_Dico(A.Fd, D, CodeD);
		    end if;
		else
		    Libere_Code(Code);
		end if;
	    end Genere_Dico;

	    CodeVide : Code_Binaire;
	    Dico : Dico_Caracteres := Cree_Dico;
	begin
	    CodeVide := Cree_Code;
	    Genere_Dico(H.A, Dico, CodeVide);

	    return Dico;
	end Genere_Dictionnaire;

	procedure Get_Caractere(It_Code : in Iterateur_Code; A : in out Arbre; Caractere_Trouve : out Boolean; Caractere : out Character) is
	    B: Bit;
	begin
	    while (Has_Next(It_Code) and then (not Est_Feuille(A))) loop
		B := Next(It_Code);
	        if (B = ZERO) then
		   A := A.Fg;
		elsif  (B = UN) then
		   A := A.Fd;
		end if;
	    end loop;

	    if (Est_Feuille(A)) then
		Caractere := A.Char;
		Caractere_Trouve := True;
	    else
		Caractere_Trouve := False;
	    end if;
	end Get_Caractere;
end huffman;
