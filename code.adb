with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Text_Io; use Ada.Text_Io;
with Ada.Unchecked_Deallocation;

package body Code is

    -- Code implemente par une liste chainne de bits
    type Element;
    type Liste_Bits is access Element;
    type Element is record
        B: Bit;
        Suiv: Liste_Bits;
    end record;

    type Code_Binaire_Interne is record
        Longueur: Natural;
        Bits: Liste_Bits;
	Dernier_Bit: Liste_Bits;
    end record;

    procedure Libere_Elem is new Ada.Unchecked_Deallocation(Element, Liste_Bits);

    procedure Libere_Code_Binaire_Interne is new Ada.Unchecked_Deallocation(Code_Binaire_Interne, Code_Binaire);

    function Cree_Code return Code_Binaire is
        C: Code_Binaire;
    begin
	C := new Code_Binaire_Interne;
        C.Longueur := 0;
        return C;
    end Cree_Code;

    function Cree_Code(C: in Code_Binaire) return Code_Binaire is
        Copie: Code_Binaire;
        Cour, CPos: Liste_Bits;
    begin
        Copie := Cree_Code;

        if (C.Longueur = 0) then
            return Copie;
        end if;
        Copie.Bits := new Element;
        Cour := Copie.Bits;
        Cour.B := C.Bits.B;

	Copie.Dernier_Bit := Cour;

        Cpos := C.Bits;
        for I in Integer range 1..(C.Longueur - 1) loop
            Cour.Suiv := new Element;
            Cour := Cour.Suiv;
            CPos := CPos.Suiv;
            Cour.B := CPos.B;
	    if (I = (C.Longueur - 1)) then
		Copie.Dernier_Bit := Cour;
	    end if;
        end loop;
        Copie.Longueur := C.Longueur;
	return Copie;
    end Cree_Code;

    procedure Libere_Code(C: in out Code_Binaire) is 
        Cour, Suiv: Liste_Bits;
    begin
        if (C /= null) then
        Cour := C.Bits;
        for I in Integer range 0..(C.Longueur - 1) loop
	    Suiv := Cour.Suiv;
            Libere_Elem(Cour);
            Cour := Suiv;
        end loop;
        Libere_Code_Binaire_Interne(C);
    end if;
    end Libere_Code;

    function Longueur(C: Code_Binaire) return Natural is
    begin
        return C.Longueur;
    end Longueur;

    procedure Affiche(C: in Code_Binaire) is
        Cour: Liste_Bits;
    begin
        Cour := C.Bits;
        for I in Integer range 0..(C.Longueur - 1) loop
            Put(Cour.B);
            Cour := Cour.Suiv;
        end loop;
    end Affiche;

    procedure Ajoute_Avant(B: in Bit; C: in out Code_Binaire) is
        Liste: Liste_Bits;
    begin
        Liste := C.Bits;
        C.Bits := new Element;
        C.Bits.B := B;
        C.Bits.Suiv := Liste;
	if (Longueur(C) = 0) then
	    C.Dernier_Bit := C.Bits;
	end if;
        C.Longueur := C.Longueur + 1;
    end Ajoute_Avant;

    procedure Ajoute_Apres(B: in Bit; C: in out Code_Binaire) is
    begin
	if (Longueur(C) > 0) then
	    C.Dernier_Bit.Suiv := new Element;
	    C.Dernier_Bit := C.Dernier_Bit.Suiv;
	    C.Dernier_Bit.B := B;
	else
	    C.Bits := new Element;
	    C.Bits.B := B;
	    C.Dernier_Bit := C.Bits;
	end if;
	C.Longueur := C.Longueur + 1;
    end Ajoute_Apres;
    
    -- copie les bits de C1 à la fin de ceux de C
    procedure Ajoute_Apres(C1: in Code_Binaire; C: in out Code_Binaire) is
        Cour, C1Cour: Liste_Bits;
    begin
	if (Longueur(C1) > 0) then
	    C1Cour := C1.Bits;
	    Cour := C.Dernier_Bit;
	    for I in Natural range 0..(Longueur(C1) - 1) loop
		if (I = 0 and then Longueur(C) = 0) then
		    C.Bits := new Element;
		    Cour := C.Bits;
		else
		    Cour.Suiv := new Element;
		    Cour := Cour.Suiv;
		end if;
		Cour.B := C1Cour.B;
		C1Cour := C1Cour.Suiv;
		if (I = (Longueur(C1) - 1)) then
		    C.Dernier_Bit := Cour;
		end if;
	    end loop;
	    C.Longueur := Longueur(C) + Longueur(C1);
	end if;
    end Ajoute_Apres;

    function Character_Vers_Code(C : Character) return Code_Binaire is
        Code: Code_Binaire;
    begin
        Code := Cree_Code;
        for I in Natural range 0..7 loop
            if ((Character'Pos(C) / 2**I) = 1) then
                Ajoute_Avant(UN, Code);
            else
                Ajoute_Avant(ZERO, Code);
            end if;
        end loop;
        return Code;
    end Character_Vers_Code;

    -- iterateur implemente par un lien vers le code a iterer
    -- ainsi qu'une reference sur l'element suivant
    -- et un compteur
    type Iterateur_Code_Interne is record
        C: Code_Binaire;
        Pos: Natural;
        Bits: Liste_Bits;
    end record;

    procedure Libere_Iterateur_Code_Interne is new Ada.Unchecked_Deallocation(Iterateur_Code_Interne, Iterateur_Code);

    function Cree_Iterateur(C : Code_Binaire) return Iterateur_Code is
        It: Iterateur_Code;
    begin
        It := new Iterateur_Code_Interne;
        It.C := C;
        It.Pos := 0;
        It.Bits := C.Bits;
        return It;
    end Cree_Iterateur;

    procedure Libere_Iterateur(It : in out Iterateur_Code) is
    begin
        Libere_Iterateur_Code_Interne(It);
    end Libere_Iterateur;

    function Has_Next(It: Iterateur_Code) return Boolean is
    begin
        return It.Pos < It.C.Longueur;
    end Has_Next;

    function Next(It: Iterateur_Code) return Bit is
	B: Bit;
    begin
	if (not Has_Next(It)) then
	    raise Code_Entierement_Parcouru;
	end if;
	B := It.Bits.B;
	It.Bits := It.Bits.Suiv;
	It.Pos := It.Pos + 1;
	return B;
    end Next;
end Code;
