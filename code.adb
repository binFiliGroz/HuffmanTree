with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Unchecked_Deallocation;

package body Code is

    type Element;
    type Liste_Bits is access Element;
    type Element is record
        B: Bit;
        Suiv: Liste_Bits;
    end record;

    type Code_Binaire_Interne is record
        Longueur: Natural;
        Bits: Liste_Bits;
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
            return C;
        end if;
        Copie.Bits := new Element;
        Cour := Copie.Bits;

        Cour.B := C.Bits.B;

        Cpos := C.Bits;
        for I in Integer range 1..(C.Longueur - 1) loop
            Cour.Suiv := new Element;
            Cour := Cour.Suiv;
            CPos := CPos.Suiv;
            Cour.B := CPos.B;
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
        C.Longueur := C.Longueur + 1;
    end Ajoute_Avant;

    procedure Ajoute_Apres(B: in Bit; C: in out Code_Binaire) is
        Cour: Liste_Bits;
    begin
        Cour := C.Bits;
        if (C.Longueur > 0) then
            if (C.Longueur > 1) then
                for I in Integer range 0..(C.Longueur - 2) loop
                    Cour := Cour.Suiv;
                end loop;
            end if;
            Cour.Suiv := new Element;
            Cour := Cour.Suiv;
            Cour.B := B;
            Cour.Suiv := null;
        else
            C.Bits := new Element;
            C.Bits.B := B;
            C.Bits.Suiv := null;
        end if;
        C.Longueur := C.Longueur + 1;
    end Ajoute_Apres;
    
    procedure Ajoute_Apres(C1: in Code_Binaire; C: in out Code_Binaire) is
        Cour, C1Cour: Liste_Bits;
	C1Pos: Natural;
    begin
	if (Longueur(C1) > 0) then
	    Cour := C.Bits;
	    if (Longueur(C) > 0) then
		if (Longueur(C) > 1) then
		    for I in Integer range 0..(Longueur(C) - 2) loop
			Cour := Cour.Suiv;
		    end loop;
		end if;
	        C1Cour := C1.Bits;
		C1Pos := 0;
		C1Cour := C1.Bits;
	    else
		C.Bits := new Element;
		Cour := C.Bits;
		Cour.B := C1.Bits.B;
		C1Pos := 1;
		C1Cour := C1.Bits.Suiv;
	    end if;
	    for I in Natural range C1Pos..(Longueur(C1) - 1) loop
		Cour.Suiv := new Element;
		Cour := Cour.Suiv;
		Cour.B := C1Cour.B;
		C1Cour := C1Cour.Suiv;
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
