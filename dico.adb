with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Text_Io; use Ada.Text_Io;
with Ada.Unchecked_Deallocation;

package body Dico is

    type Tableau_Caracteres is array (integer range 0..254) of Info_Caractere;
    type Tableau_Index is array (integer range 0..254) of integer;

    type Dico_Caracteres_Interne is record
        I: Tableau_Index;
        Dernier_Elem: integer;
        C: Tableau_Caracteres;
    end record;

    procedure Libere_Dico_Caracteres_Interne is new Ada.Unchecked_Deallocation(Dico_Caracteres_Interne, Dico_Caracteres);

    function Cree_Dico return Dico_Caracteres is
        D: Dico_Caracteres;
    begin
        D := new Dico_Caracteres_Interne;
        for J in Integer range 0..254 loop
            D.I(J) := -1;
	        D.C(J).Nb_Occ := 0; 
        end loop;
        D.Dernier_Elem := -1;
        return D;
    end Cree_Dico;

    procedure Libere(D: in out Dico_Caracteres) is
    	procedure Libere_Info_Caractere(I: in out Info_Caractere) is
	    begin
	        Libere_Code(I.Code);
	    end Libere_Info_Caractere;
    begin
	    for J in Integer range 0..D.Dernier_Elem loop
		    Libere_Info_Caractere(D.C(J));
	    end loop;
        Libere_Dico_Caracteres_Interne(D);
    end Libere;

    procedure Affiche(D : in Dico_Caracteres) is
        procedure Affiche_Info_Caractere(I: Info_Caractere) is 
        begin
            Put("["); Put(I.Caractere); Put("] ");
            Put("Code : "); Code.Affiche(I.Code); 
	        Put(", Nb Occ : "); Put(I.Nb_Occ);
        end Affiche_Info_Caractere;
    begin
        for J in Integer range 0..254 loop
            if (D.I(J) >= 0) then
		        Affiche_Info_Caractere(D.C(D.I(J)));
		        New_Line;
            end if;
        end loop;
    end Affiche;

    procedure Set_Code(C : in Character; Code : in Code_Binaire; D : in out Dico_Caracteres) is
    begin
        if (D.I(Character'Pos(C)) = -1) then
            D.Dernier_Elem := D.Dernier_Elem + 1;
            D.I(Character'Pos(C)) := D.Dernier_Elem;
            D.C(D.Dernier_Elem).Caractere := C;
        end if;
	    D.C(D.I(Character'Pos(C))).Code := Code;
    end Set_Code;

    procedure Set_Infos(C : in Character; Infos : in Info_Caractere; D : in out Dico_Caracteres) is
    begin
        if (D.I(Character'Pos(C)) = -1) then
            D.Dernier_Elem := D.Dernier_Elem + 1; 
            D.I(Character'Pos(C)) := D.Dernier_Elem;
        end if;
        D.C(D.I(Character'Pos(C))) := Infos;
    end Set_Infos;

    procedure Incremente_Nb_Occurences(C : in Character; D : in out Dico_Caracteres) is
    begin
	    D.C(D.I(Character'Pos(C))).Nb_Occ := D.C(D.I(Character'Pos(C))).Nb_Occ + 1;
    end Incremente_Nb_Occurences;

    function Est_Present(C : Character; D : Dico_Caracteres) return Boolean is
    begin
	    return D.I(Character'Pos(C)) >= 0;
    end Est_Present;

    function Get_Code(C : Character; D : Dico_Caracteres) return Code_Binaire is
    begin
	    return D.C(D.I(Character'Pos(C))).Code;
    end Get_Code;

    function Get_Infos(C : Character; D : Dico_Caracteres) return Info_Caractere is
    begin
        return  D.C(D.I(Character'Pos(C)));
    end Get_Infos;

    function Get_Nb_Occurences(C : in Character; D : in Dico_Caracteres) return Natural is
    begin
        return  D.C(D.I(Character'Pos(C))).Nb_Occ;
    end Get_Nb_Occurences;

    function Nb_Caracteres_Differents(D : in Dico_Caracteres) return Natural is
    begin
	    return D.Dernier_Elem + 1;
    end Nb_Caracteres_Differents;

    function Nb_Total_Caracteres(D : in Dico_Caracteres) return Natural is
	    S: Natural;
    begin
	    S := 0;
	    for J in Natural range 0..D.Dernier_Elem loop
		    S := S + D.C(J).Nb_Occ;
	    end loop;
	    return S;
    end Nb_Total_Caracteres;

    function Genere_Tableau_Stockage(D: in Dico_Caracteres) return Stockage_Dico is
        Tab: Stockage_Dico(0..D.Dernier_Elem);
    begin
        for J in Natural range 0..D.Dernier_Elem loop
            Tab(J).C := D.C(J).Caractere;
            Tab(J).L := Code.Longueur(D.C(J).Code);
        end loop;
        return Tab;
    end Genere_Tableau_Stockage;
end Dico;
