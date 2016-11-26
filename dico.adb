with Ada.Unchecked_Deallocation;

package body Dico is

    type Element is record
        P: Boolean;
        I: Info_Caractere;
    end record;

    type Dico_Caracteres_Interne is array (integer range 0..254) of Element;

    procedure Libere_Dico_Caracteres_Interne is new Ada.Unchecked_Deallocation(Dico_Caracteres_Interne, Dico_Caracteres);

    function Cree_Dico() return Dico_Caracteres
        D: Dico_Caracteres;
    begin
        D := new Dico_Caractere_Interne;
        for I in Integer range 0..254 loop
            D.P := false;
        end loop;
        return D;
    end Cree_Dico;

    procedure Libere(D: in out Dico_Caracteres) is
    begin
        Libere_Dico_Caracteres_Interne(D);
    end Libere;

    procedure Affiche(D : in Dico_Caracteres) is
        procedure Affiche_Info_Caractere(I: Info_Caractere) is 
        begin
            Put("Code : "); 
        end Affiche_Info_Caractere;
    begin
        for I in Integer range 0..254 loop
            if (D(I).P) then
                Affiche_Info_Caractere(D(I));
            end if;
        end loop;
    end Affiche;


end Dico;
