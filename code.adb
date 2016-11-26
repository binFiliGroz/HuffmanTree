with Ada.Unchecked_Deallocation;

package body code is

    type Element is record
        B: Bit;
        Suiv: Liste_Bits;
    end record;

    type Liste_Bits is access Element;

    type Code_Binaire_Interne is record
        Longueur: Natural;
        Bits: Liste_Bits;
    end record;

    procedure Libere_Elem is new Ada.Unchecked_Deallocation(Element, Liste_Bits);

    procedure Libere_Code_Binaire_Interne is new Ada.Unchecked_Deallocation(Code_Binaire_Internet, Code_Binaire);

    function Cree_Code() return Code_Binaire is
        C: Code_Binaire;
    begin
        C.Longueur := 0;
        C.Bits := null;
        return C;
    end Cree_Code;

    function Cree_Code(C: in Code_Binaire) return Code_Binaire
        Copie: Code_Binaire;
        Cour, CPos: Liste_Bits;
    begin
        Copie := Cree_Code();

        if (C.Longueur = 0) then
            return C;
        end if;
        Copie.Bits := new Element;
        Cour := Copie.Bits;

        Cour.B := C.B;

        Cpos := C.Bits;
        for I in Integer range 1..(C.Longueur - 1) loop
            Cour.Suiv := new Element;
            Cour := Cour.Suiv;
            CPos := CPos.Suiv;
            Cour.B := CPos.B;
        end loop;
        Copie.Longueur := C.Longueur;
    end Cree_Code;

    procedure Libere_Code(C: in Code_Binaire) is 
        Cour, Suiv: Liste_Bits;
    begin
        Cour := C.Bits;
        Suiv := Cour.Suiv;
        for I in Integer range 0..(C.Longueur - 1) loop
            Libere_Elem(Cour);
            Cour := Suiv;
            Suiv := Suiv.Suiv;
        end loop;
        Libere_Code_Binaire_Interne(C);
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
        Liste: Liste_Bits
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
        Cour: Liste_Bits;
    begin
        Cour := C.Bits;
        if (C.Longueur > 0) then
            if (C.Longueur > 1) then
                for I in Integer range 0..(C.Longueur - 2) loop
                    Cour := Cour.Suiv;
                end loop;
            end if;
            Cour.Suiv := C1.Bits;
        else
            C.Bits := C1.Bits;
        end if;
        C.Longueur := C.Longueur + C1.Longueur;
    end Ajoute_Apres;

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
        return C.Bits;
    end Cree_Iterateur;

    procedure Libere_Iterateur(It : in out Iterateur_Code) is
    begin
        Libere_Iterateur_Code_Interne(It);
    end Libere_Iterateur;

    function Has_Next(It: Iterateur_Code) return Boolean is
    begin
        return It.Pos < C.Longueur - 1;
    end Has_Next;

    function Next(It: Iterateur_Code) return Bit is
    begin
    end Next;



end code;
