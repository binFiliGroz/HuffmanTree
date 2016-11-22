with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Ada.Text_Io; use Ada.Text_Io;

with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;

type Noeud is record 
	Char: String;
	Fd, Fg : Arbre;
	end record;
	

	procedure Libere(H :in out Arbre_Huffman) is
		begin
			Libere(H.Fd);
			Libere(H.Fg);
			Free(H);

	end procedure;

	
	
	procedure Affiche(H : in Arbre_Huffman) is
		begin
			Put(H.Char);
			Affiche(H.Fg);
			Affiche(H.Fd);
			
	end procedure;

	
	
	function Cree_Huffman(Nom_Fichier : in String) is
		begin
			...
			...
			...
			return Arbre_Huffman;
	end function;


	
	function Ecrit_Huffman(H : in Arbre_Huffman ; Flux : Ada.Streams_IO.Stream_Access) is
		begin
			...
			...
			...
			return Positive;
	end function;



	function Lit_Huffman(Flux : Ada.Streams.Stream_IO.Stream_Access)
		begin
			...
			...
			...
			return Arbre_Huffman;
	end function;



	function Genere_Dictionnaire(H : in Arbre_Huffman) return Dico_Caracteres;



	procedure Get_Caractere(It_Code : in Iterateur_Code; A : in out Arbre;
	        Caractere_Trouve : out Boolean;
			Caractere : out Character);
			begin

	end procedure;
