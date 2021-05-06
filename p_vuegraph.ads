with p_fenbase; use p_fenbase;
with P_virus; use p_virus;
use p_virus.p_piece_io;
with Forms; use Forms;
with text_io; use text_io;
with p_esiut; use p_esiut;
with Ada.Strings.unbounded; use Ada.Strings.unbounded;
with sequential_io;

package p_vuegraph is

type TR_Score is record
  config: integer;
  scoreF: integer;
  nomJoueur: string(1..30);
end record;

type TV_Partie is array (integer range <>) of TR_Score;

package p_bin_io is new sequential_io(TR_Score); use p_bin_io;

procedure AfficheGrille(fenetre : in out TR_Fenetre; grille : in TV_Grille);

procedure ModGrille(fenetre : in out TR_Fenetre; Grille : in out TV_Grille);

procedure jeuWindow(Grille: in out TV_Grille; Pieces : in TV_Pieces; temps : in out float; nbcoup : in out integer; jouer,recommencer : in out boolean);

procedure acceuilWindow(s : in out p_bin_io.file_type; acceuil : in out TR_Fenetre; jouer, recommencer : in out boolean);

procedure choixWindow(acceuil : in TR_Fenetre; config : out integer; jouer, recommencer : in out boolean; grille : out TV_Grille; Pieces : out TV_Pieces);

procedure finPartie(s : in out p_bin_io.file_type; config : in integer; temps : in float; nbcoup : in integer; recommencer, jouer : in out boolean; acceuil : in out TR_Fenetre);

procedure statWindow(s : in out p_bin_io.file_type; jouer,recommencer : in out boolean);

procedure InitializeF(s : in out p_bin_io.file_type);

procedure InsertF(s : in out p_bin_io.file_type; score : in TR_Score);

end p_vuegraph;
