with Ada.Unchecked_Deallocation;

package body File_Priorite is
    type Element is record
        D: Donnee;
        P: Priorite;   
    end record;

    type Tableau_Tas is array (integer range <>) of Element ;
    type Tableau_Tas_A is access Tableau_Tas;

    type File_Interne is record
        Capacite: Positive;
	    Dernier_Elem: Integer;
        Tab: Tableau_Tas_A;
    end record;

    procedure Libere_Tableau_Tas is new Ada.Unchecked_Deallocation (Tableau_Tas, Tableau_Tas_A);
    procedure Libere_File_Interne is new Ada.Unchecked_Deallocation (File_Interne, File_Prio);

    function Cree_File(Capacite: Positive) return File_Prio is
        F: File_Prio;
    begin
        F := new File_Interne;
        F.all.Capacite := Capacite;
        F.all.Tab := new Tableau_Tas(1..Capacite);
	F.all.Dernier_Elem := 0;
        return F;
    end Cree_File;

    procedure Libere_File(F : in out File_Prio) is
    begin
	Libere_Tableau_Tas(F.Tab);
	Libere_File_Interne(F);
    end Libere_File;

    function Est_Vide(F: in File_Prio) return Boolean is
    begin
	if (F.Dernier_Elem = 0) then
	    return true;
	end if;
	return false;
    end Est_Vide;

    function Est_Pleine(F: in File_Prio) return Boolean is 
    begin
	if (F.Dernier_Elem = F.Capacite) then
	return true;
    end if;
    return false;
    end Est_Pleine;

    procedure Echange_Elem(F: in File_Prio; I1: in Integer; I2: in Integer) is
	D: Donnee;
	P: Priorite;
    begin
	D := F.Tab(I2).D;
	P := F.Tab(I2).P;
	F.Tab(I2).D := F.Tab(I1).D;
	F.Tab(I2).P := F.Tab(I1).P;
	F.Tab(I1).D := D;
	F.Tab(I1).P := P;
    end Echange_Elem;

    procedure Insere(F: in File_Prio; D: in Donnee; P: in Priorite) is
	I: Integer;
	Pere: Integer;
    begin
	if (Est_Pleine(F)) then
	    raise File_Prio_Pleine;
	end if;
	F.Dernier_Elem := F.Dernier_Elem + 1;
	F.Tab(F.Dernier_Elem).D := D;
	F.Tab(F.Dernier_Elem).P := P;
	if (not Est_Vide(F)) then
	    I := F.Dernier_Elem;
	    Pere := I/2;
	    while (I > 1 and then Est_Prioritaire(F.Tab(I).P, F.Tab(Pere).P)) loop
		Echange_Elem(F, Pere, I);
		I := Pere;
		Pere := I/2;
	    end loop;
	end if;
    end Insere;

    procedure Supprime(F: in File_Prio; D: out Donnee; P: out Priorite) is
	function Max_Fils(F: in File_Prio; Pere: Integer) return Integer is
	    I: Integer;
	    P: Priorite;
	begin
	    if ((Pere * 2) <= F.Dernier_Elem) then
		I := 0;
		P := F.Tab(Pere).P;

		if (Est_Prioritaire(F.Tab(Pere * 2).P, P)) then
		    I := Pere * 2;
		    P := F.Tab(Pere * 2).P;
		end if;
		if ((Pere * 2 + 1) <= F.Dernier_Elem and then Est_Prioritaire(F.Tab(Pere * 2 + 1).P, P)) then
		    I := Pere * 2 + 1;
		    P := F.Tab(Pere * 2 + 1).P;
		end if;
		return I;
	    end if;
	    return 0;
	end Max_Fils;

	Pere: Integer;
	I: Integer;
    begin
	if (Est_Vide(F)) then
	    raise File_Prio_Vide;
	end if;
	D := F.Tab(1).D;
	P := F.Tab(1).P;
	F.Tab(1).D := F.Tab(F.Dernier_Elem).D;
	F.Tab(1).P := F.Tab(F.Dernier_Elem).P;
	F.Dernier_Elem := F.Dernier_Elem - 1;

	Pere := 1;

	loop
	    I := Max_Fils(F, Pere);
	    if (I = 0) then
		exit;
	    end if;
	    Echange_Elem(F, Pere, I);
	    Pere := I;
	end loop;
    end Supprime;

    procedure Prochain(F: in File_Prio; D: out Donnee; P: out Priorite) is
    begin
	D := F.Tab(1).D;
	P := F.Tab(1).P;
    end Prochain;
end File_Priorite;
