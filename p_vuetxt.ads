with text_io; use text_io;
with p_virus; use p_virus;
use p_virus.p_int_io;
use p_virus.p_piece_io;
use p_virus.p_coul_io;
use p_virus.p_dir_io;

package p_vuetxt is

  type T_Rep is (oui,non);
  package p_rep_io is new enumeration_io(T_Rep); use p_rep_io;

  type T_Action is (annuler,deplacer,abandonner);
  package p_act_io is new enumeration_io(T_Action); use p_act_io;

procedure AfficheGrille(Grille : in TV_Grille);
  -- {} => {la grille a été affichée selon les spécifications suivantes :
  -- * la sortie est indiquée par la lettre S
  -- * une case inactive ne contient aucun caractère
  -- * une case de couleur vide contient un point
  -- * une case de couleur blanche contient le caractère F (Fixe)
  -- * une case de la couleur d’une pièce mobile contient le chiffre correspondant à la
  -- position de cette couleur dans le type T_Coul}

  procedure ChConfig(reponse : out integer);

  procedure ChCouleur(pieces : in TV_Pieces; reponse : out T_coulP);

  procedure ChDir(dir : out T_Direction);

  procedure commencerPartie(retour: in out boolean);

  procedure Coup(Grille : in out TV_Grille; lastCoup : in out TV_Grille ; pieces : in TV_Pieces;continuer : out boolean);
end p_vuetxt;
