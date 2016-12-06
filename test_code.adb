with Ada.Text_Io; use Ada.Text_Io;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Code; use Code;

procedure test_code is
    C, Copie: Code_Binaire;
    It: Iterateur_Code;
begin
    Put_Line("Creation d'un code binaire");
    C := Cree_Code;
    if (Longueur(C) = 0) then
        Put_Line("Longueur nulle");
    else
        Put_Line("ERREUR : longueur non nulle");
    end if;
    Affiche(C);
    Put_Line("Insertion de quelques bits");
    Ajoute_Avant(ZERO, C);
    Affiche(C); New_Line;
    Ajoute_Avant(UN, C);
    Affiche(C); New_Line;
    Ajoute_Apres(UN, C);
    Affiche(C); New_Line;
    Put_Line("Copie du code");
    Copie := Cree_Code(C);
    Affiche(Copie); New_Line;
    Put_Line("Modification de la copie");
    Ajoute_Avant(UN, C); New_Line;
    Ajoute_Apres(UN, C); New_Line;
    Put_Line("Affichage de la copie");
    Affiche(Copie); New_Line;
    Put_Line("Affichage de l'original");
    Affiche(C); New_Line;
    Put_Line("Ajout de C à la suite de Copie");
    Ajoute_Apres(C, Copie); New_Line;
    Affiche(Copie); New_Line;
    if (Longueur(C) = 5 and Longueur(Copie) = 8) then
	Put_Line("Longueurs conformes");
    else
	Put_Line("ERREUR : longueurs non conformes");
    end if;
    -- Tests Iterateur
    It := Cree_Iterateur(Copie);
    while Has_Next(It) loop
	Put(Next(It));
    end loop;
    Libere_Iterateur(It);
    Libere_Code(C);
    Libere_Code(Copie);

    New_Line;
    Put_Line("Test conversion entier vers binaire");
    C := Character_Vers_Code(Character'Val(2));
    Affiche(C);
    Libere_Code(C);
end test_code;
