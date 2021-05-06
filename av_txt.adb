with p_virus; use p_virus;
with text_io; use text_io;
use p_virus.p_int_io;
use p_virus.p_piece_io;
use p_virus.p_coul_io;
use p_virus.p_dir_io;
with p_vuetxt; use p_vuetxt;

procedure av_txt is
  Grille, lastCoup : TV_Grille;
  Pieces : TV_Pieces;
  rep : integer;
  f : p_piece_io.file_type;
  cont,cp:boolean:=true;
  nbCoup:integer:=0;
begin
  open(f, in_file, "Parties");
  InitPartie(Grille, Pieces);
  put_line("-----------------------------------------");
  put_line("----------------ANTI-VIRUS---------------");
  put_line("-----------------(le jeu)----------------");
  put_line("-----------------------------------------");
  new_line;
  loop
    commencerPartie(CP);
    exit when not cp;
    ChConfig(rep);
    Configurer(f, rep, Grille, Pieces);
    lastCoup:=grille;


    while not Guerison(Grille) and cont loop
      PUT(ASCII.ESC & "[2J");
      PUT(ASCII.ESC & "[1;1f");
      for i in rouge..blanc loop
        PosPiece(Grille, i);
      end loop;
      AfficheGrille(Grille);
      coup(grille,lastCoup,pieces,cont);
      nbCoup:=nbCoup+1;
    end loop;
    if Guerison(grille) then
      put_line("-----------------------------------------");
      put_line("--------------VIRUS ELIMINÉ--------------");
      put_line("-------(point faible: trop fort)---------");
      put_line("-----------------------------------------");
    end if;
    cont:=true;
  end loop;
  put_line("-----------------------------------------");
  put_line("----------------AU REVOIR----------------");
  put_line("-------(A bientot sur anti-virus)--------");
  put_line("-----------------------------------------");
end av_txt;
