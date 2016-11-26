with Ada.Text_Io; use Ada.Text_Io;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Dico; use Dico;
with Code; use Code;

procedure Test_Dico is
    D: Dico_Caracteres;
    C: Code_Binaire;
begin
    Put_Line("Creation d'un dictionnaire");
    D  := Cree_Dico;
    Affiche(D);

    C := Cree_Code;
    Ajoute_Avant(ZERO, C);
    Ajoute_Avant(UN, C);
    Ajoute_Apres(UN, C);
    Set_Code('A', C, D);
    Incremente_Nb_Occurences('A', D);
    Incremente_Nb_Occurences('A', D);
    Affiche(D);

    C := Cree_Code;
    Ajoute_Avant(ZERO, C);
    Ajoute_Apres(UN, C);
    Set_Code('z', C, D);
    Incremente_Nb_Occurences('z', D);
    Affiche(D);
    
    Put("Code A :"); Code.Affiche(Get_Code('A', D));
    New_Line;

    Put("Nb Caracteres Differents : "); Put(Nb_Caracteres_Differents(D));
    New_Line;
    Put("Nb Total Caracteres : "); Put(Nb_Total_Caracteres(D)); 
    New_Line;

    Dico.Libere(D);
end Test_Dico;
