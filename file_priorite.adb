

package body File_Prio is
    type Donnee is new Integer;
    type Priorite is new Natural;
 
    type Element is record
        D: Donnee;
        P: Priorite;   
    end record;

    type Tableau_Tas is array (integer range <>) of Element ;

    type File_Interne is record
        Capacite: Positive;
        Tab: Tableau_Tas;
    end record;

    function Cree_File(Capacite: Positive) return File_Prio is
        F: File_Prio;
    begin
        F := new File_Interne;
        F.all.Capacite := Capacite;
        F.all.Tab := Tableau_Tas(0..(Capacite-1));
        return F;
    end Cree_File;


end File_Prio;
