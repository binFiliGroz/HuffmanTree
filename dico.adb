with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Text_Io; use Ada.Text_Io;
with Ada.Unchecked_Deallocation;

package body Dico is

    type Element is record
        P: Boolean;
        I: Info_Caractere;
    end record;

    type Dico_Caracteres_Interne is array (integer range 0..254) of Element;

    procedure Libere_Dico_Caracteres_Interne is new Ada.Unchecked_Deallocation(Dico_Caracteres_Interne, Dico_Caracteres);

    function Cree_Dico return Dico_Caracteres is
        D: Dico_Caracteres;
    begin
        D := new Dico_Caracteres_Interne;
        for J in Integer range 0..254 loop
            D(J).P := false;
	    D(J).I.Nb_Occ := 0; 
        end loop;
        return D;
    end Cree_Dico;

    procedure Libere(D: in out Dico_Caracteres) is
	procedure Libere_Info_Caractere(I: in out Info_Caractere) is
	begin
	    Libere_Code(I.Code);
	end Libere_Info_Caractere;
    begin
	for J in Integer range 0..254 loop
	    if (D(J).P) then
		Libere_Info_Caractere(D(J).I);
	    end if;
	end loop;
        Libere_Dico_Caracteres_Interne(D);
    end Libere;

    procedure Affiche(D : in Dico_Caracteres) is
        procedure Affiche_Info_Caractere(I: Info_Caractere) is 
        begin
            Put("Code : "); Code.Affiche(I.Code); 
	    Put(", Nb Occ : "); Put(I.Nb_Occ);
        end Affiche_Info_Caractere;
    begin
        for J in Integer range 0..254 loop
            if (D(J).P) then
		Put("["); Put(Character'Val (J)); Put("] "); 
		Affiche_Info_Caractere(D(J).I);
		New_Line;
            end if;
        end loop;
    end Affiche;

    procedure Set_Code(C : in Character; Code : in Code_Binaire; D : in out Dico_Caracteres) is
    begin
	D(Character'Pos(C)).P := true;
	D(Character'Pos(C)).I.Code := Code;
    end Set_Code;

    procedure Set_Infos(C : in Character; Infos : in Info_Caractere; D : in out Dico_Caracteres) is
    begin
	D(Character'Pos(C)).P := true;
	D(Character'Pos(C)).I := Infos;
    end Set_Infos;

    procedure Incremente_Nb_Occurences(C : in Character; D : in out Dico_Caracteres) is
    begin
	D(Character'Pos(C)).I.Nb_Occ := D(Character'Pos(C)).I.Nb_Occ + 1;
    end Incremente_Nb_Occurences;

    function Est_Present(C : Character; D : Dico_Caracteres) return Boolean is
    begin
	return D(Character'Pos(C)).P;
    end Est_Present;

    function Get_Code(C : Character; D : Dico_Caracteres) return Code_Binaire is
    begin
	return D(Character'Pos(C)).I.Code;
    end Get_Code;

    function Get_Infos(C : Character; D : Dico_Caracteres) return Info_Caractere is
    begin
	return D(Character'Pos(C)).I;
    end Get_Infos;

    function Get_Nb_Occurences(C : in Character; D : in out Dico_Caracteres) return Natural is
    begin
	return D(Character'Pos(C)).I.Nb_Occ;
    end Get_Nb_Occurences;

    function Nb_Caracteres_Differents(D : in Dico_Caracteres) return Natural is
	S: Natural;
    begin
	S := 0;
	for I in Natural range 0..254 loop
	    if (D(I).P) then
		S := S + 1;
	    end if;
	end loop;
	return S;
    end Nb_Caracteres_Differents;

    function Nb_Total_Caracteres(D : in Dico_Caracteres) return Natural is
	S: Natural;
    begin
	S := 0;
	for J in Natural range 0..254 loop
	    if (D(J).P) then
		S := S + D(J).I.Nb_Occ;
	    end if;
	end loop;
	return S;
    end Nb_Total_Caracteres;
end Dico;
