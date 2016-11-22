with Ada.Text_Io; use Ada.Text_Io;

procedure test_file_priorite is

    procedure Verifie_Valeur(F: in File_Prio; D: in Donnee; P: in Priorite) is
        D1 : Donnee;
        P1 : Priorite;
    begin
        Prochain(F, D1, P1);
        if (D1 = D and P1 = P) then
            Supprime(F, D1, P1);
            if (D1 = D and P1 = P) then
                Put_Line("Sorties valides");
            else
                Put_Line("ERREUR : Supprime() a renvoyée une valeur erronée");
            end if;
        else
            Put_Line("ERREUR : Prochain() a renvoyée une valeur erronée");
        end if;
    end Verifie_Valeur;

    F: File_Prio;
    P: Priorite;
    D: Donnee;
begin
    Put_Line("Creation d'une file de priorité");
    F := Cree_File(8);
    if (Est_Vide(F)) then
        Put_Line("La file créée est bien vide");
    else
        Put_Line("ERREUR : la file n'est pas vide");
    end if;
    Put_Line("Insertion de quelques données");
    Insere(F, 42, 42);
    Insere(F, 112, 112);
    Insere(F, 1, 1);
    Insere(F, 697, 697);
    Insere(F, 3, 3);
    Insere(F, 351, 351);
    Insere(F, 415, 415);
    Insere(F, 88, 88);
    if (Est_Pleine(F)) then
        Put_Line("La file est maintenant pleine");
    else
        Put_Line("ERREUR : la file devrait être pleine");
    end if;
    --Insere(F, 0, 0);
    Verifie_Valeur(F, 697, 697);
    Verifie_Valeur(F, 415, 415);
    Verifie_Valeur(F, 351, 351);
    Verifie_Valeur(F, 112, 112);
    Verifie_Valeur(F, 88, 88);
    Verifie_Valeur(F, 42, 42);
    Verifie_Valeur(F, 3, 3); 
    Verifie_Valeur(F, 1, 1);
    --Supprime(F, D, P);
    if (Est_Vide(F)) then   
        Put_Line("La file est maintenant vide"); 
    else
        Put_Line("ERREUR : la file n'est pas vide");
    end if;
    Libere_File(F);
    if (F = null) then
        Put_Line("F = null");
    else 
        Put_Line("ERREUR : F != null");
    end if;
end test_file_priorite;
