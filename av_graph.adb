with p_vuegraph; use p_vuegraph;
with p_fenbase; use p_fenbase;
with p_virus; use p_virus;
with text_io; use text_io;
with Ada.Strings.unbounded; use Ada.Strings.unbounded;
use p_vuegraph.p_bin_io;

procedure av_graph is
  jouer, recommencer : boolean := true;
  config : integer;
  grille : TV_Grille;
  pieces : TV_Pieces;
  temps : float;
  nbcoup : integer;
  s : p_bin_io.file_type;
  acceuil : TR_Fenetre;
begin
  open(s, in_file,"score.bin");
  InitialiserFenetres;
  loop
    reset(s,in_file);
    acceuilWindow(s, acceuil, jouer, recommencer);
    while jouer loop
      choixWindow(acceuil,config,jouer,recommencer,grille,pieces);
      if jouer then
        jeuWindow(grille, pieces, temps, nbcoup,jouer,recommencer);
      end if;
      if Guerison(grille) then
        finPartie(s,config,temps,nbcoup,recommencer,jouer,acceuil);
        if not recommencer then
          jouer := false;
        end if;
      end if;
    end loop;
  exit when recommencer = false and jouer = false;
  end loop;
end av_graph;
