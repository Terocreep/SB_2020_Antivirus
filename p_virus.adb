package body p_virus is


procedure InitPartie (Grille : in out TV_Grille ; Pieces : in out TV_Pieces) is
-- {} => {Tous les éléments de Grille ont été initialisés avec la couleur vide
-- y compris les cases inutilisables
-- Tous les éléments de Pieces ont été initialisés à false}
begin
  for i in Grille'range(1) loop
    for j in Grille'range(2) loop
    if (i mod 2 = 0 and T_Col'pos(j) mod 2 = 1) or else (i mod 2 = 1 and T_Col'pos(j) mod 2 = 0) then
        Grille(i,j) := v;
      else
        Grille(i,j) := vide;
      end if;
    end loop;
  end loop;
  for i in Pieces'range loop
    Pieces(i) := false;
  end loop;
end InitPartie;


procedure Configurer (f : in out p_piece_io.file_type; nb : in positive; Grille : in out TV_Grille ; Pieces : in out TV_Pieces) is
-- {f ouvert,nb est un numéro de configuration (appelé numéro de partie),
-- une configuration décrit le placement des pièces du jeu, pour chaque configuration :
-- * les éléments d’une même pièce (même couleur) sont stockés consécutivement
-- * il n’y a pas deux pièces mobiles ayant la même couleur
-- * les deux éléments constituant le virus (couleur rouge) terminent la configuration}
-- => {Grille a été mis à jour par lecture dans f de la configuration de numéro nb
-- Pieces a été initialisé en fonction des pièces de cette configuration}
-- pour test configuration…
  elem, elemPrec : TR_ElemP;
  i : integer := 1;
begin
  reset(f, in_file);
  while not end_of_file(f) and i <= nb loop
    read(f, elem);
    if i = nb then
      Grille(elem.ligne, elem.colonne) := elem.couleur;
      Pieces(elem.couleur) := true;
    end if;
    if elemPrec.couleur = rouge and elem.couleur = rouge then
      i := i+1;
    end if;
    elemPrec := elem;
  end loop;
end Configurer;


procedure PosPiece (Grille : in TV_Grille ; coul : in T_coulP) is
-- {} => {la position de la pièce de couleur coul a été affichée si cette pièce est dans Grille
-- exemple : ROUGE : F4 G5}
begin
  for i in Grille'range(1) loop
    for j in Grille'range(2) loop
      if Grille(i, j) = coul then
        if (coul = v) then
          put(" ");
        elsif (coul = vide) then
          put(ASCII.ESC & "[38;5;" & "250" & "m" & "█" & ASCII.ESC & "[0m");
        elsif (coul= rouge) then
          put(ASCII.ESC & "[38;5;" & "9" & "m" & "█" & ASCII.ESC & "[0m");
        elsif (coul = turquoise) then
          put(ASCII.ESC & "[38;5;" & "6" & "m" & "█" & ASCII.ESC & "[0m");
        elsif (coul = orange) then
          put(ASCII.ESC & "[38;5;" & "166" & "m" & "█" & ASCII.ESC & "[0m");
        elsif (coul = rose) then
          put(ASCII.ESC & "[38;5;" & "13" & "m" & "█" & ASCII.ESC & "[0m");
        elsif (coul = marron) then
          put(ASCII.ESC & "[38;5;" & "3" & "m" & "█" & ASCII.ESC & "[0m");
        elsif (coul = bleu) then
          put(ASCII.ESC & "[38;5;" & "12" & "m" & "█" & ASCII.ESC & "[0m");
        elsif (coul = violet) then
          put(ASCII.ESC & "[38;5;" & "5" & "m" & "█" & ASCII.ESC & "[0m");
        elsif (coul = vert) then
          put(ASCII.ESC & "[38;5;" & "2" & "m" & "█" & ASCII.ESC & "[0m");
        elsif (coul = jaune) then
          put(ASCII.ESC & "[38;5;" & "11" & "m" & "█" & ASCII.ESC & "[0m");
        elsif (coul = blanc) then
          put(ASCII.ESC & "[38;5;" & "255" & "m" & "█" & ASCII.ESC & "[0m");
        end if;
        put(" => ");
        put(coul); put(" : ");
        put_line("(" & j & "," & integer'image(i)(2..integer'image(i)'last) & ")");
      end if;
    end loop;
  end loop;
end PosPiece;


function Direction(Grille : in TV_Grille; Pos : in out TV_Pos; Dir : in T_Direction; coul : in T_CoulP) return boolean is
  Postmp : TV_Pos := Pos;
begin
  case Dir is
    when bg =>
      for i in Postmp'range loop
        Postmp(i).x := Postmp(i).x + 1;
        Postmp(i).y := T_Col'Pred(Postmp(i).y);
        if Grille(Postmp(i).x, Postmp(i).y) /= vide and Grille(Postmp(i).x, Postmp(i).y) /= coul then
          return false;
        end if;
      end loop;
    when hg =>
      for i in Postmp'range loop
        Postmp(i).x := Postmp(i).x - 1;
        Postmp(i).y := T_Col'Pred(Postmp(i).y);
        if Grille(Postmp(i).x, Postmp(i).y) /= vide and Grille(Postmp(i).x, Postmp(i).y) /= coul then
          return false;
        end if;
      end loop;
    when bd =>
      for i in Postmp'range loop
        Postmp(i).x := Postmp(i).x + 1;
        Postmp(i).y := T_Col'Succ(Postmp(i).y);
        if Grille(Postmp(i).x, Postmp(i).y) /= vide and Grille(Postmp(i).x, Postmp(i).y) /= coul then
          return false;
        end if;
      end loop;
    when hd =>
      for i in Postmp'range loop
        Postmp(i).x := Postmp(i).x - 1;
        Postmp(i).y := T_Col'Succ(Postmp(i).y);
        if Grille(Postmp(i).x, Postmp(i).y) /= vide and Grille(Postmp(i).x, Postmp(i).y) /= coul then
          return false;
        end if;
      end loop;
  end case;
  return true;
end Direction;


function Possible (Grille : in TV_Grille; coul : in T_CoulP; Dir : in T_Direction) return boolean is
-- {coul /= blanc}
-- => {résultat = vrai si la pièce de couleur coul peut être déplacée dans la direction Dir}
  nbP, i : integer := 0;
begin
  for x in Grille'range(1) loop
    for y in Grille'range(2) loop
      if Grille(x,y) = coul then
        nbP := nbP + 1;
      end if;
    end loop;
  end loop;
  declare
    pos : TV_Pos(1..nbP);
  begin
    for x in Grille'range(1) loop
      for y in Grille'range(2) loop
        if Grille(x,y) = coul then
          i := i + 1;
          pos(i) := (x,y);
        end if;
      end loop;
    end loop;
    return Direction(Grille, pos, Dir, coul);
  end;
exception
  when others => return false;
end Possible;


procedure MajGrille (Grille : in out TV_Grille; coul : in T_coulP; Dir :in T_Direction) is
-- {la pièce de couleur coul peut être déplacée dans la direction Dir}
-- => {Grille a été mis à jour suite au déplacement}
nbP, i : integer := 0;
begin
  for x in Grille'range(1) loop
    for y in Grille'range(2) loop
      if Grille(x,y) = coul then
        nbP := nbP + 1;
      end if;
    end loop;
  end loop;
  declare
    pos : TV_Pos(1..nbP);
  begin
    for x in Grille'range(1) loop
      for y in Grille'range(2) loop
        if Grille(x,y) = coul then
          i := i + 1;
          pos(i) := (x,y);
        end if;
      end loop;
    end loop;
      case Dir is
        when bg =>
	for k in reverse pos'range loop
          Grille(pos(k).x+1,T_col'Pred(pos(k).y)) := coul;
          Grille(pos(k).x,pos(k).y) := vide;
	end loop;
        when hg =>
	for k in pos'range loop
          Grille(pos(k).x-1,T_col'Pred(pos(k).y)) := coul;
          Grille(pos(k).x,pos(k).y) := vide;
	end loop;
        when bd =>
	for k in reverse pos'range loop
          Grille(pos(k).x+1,T_col'Succ(pos(k).y)) := coul;
          Grille(pos(k).x,pos(k).y) := vide;
	end loop;
        when hd =>
	for k in pos'range loop
          Grille(pos(k).x-1,T_col'Succ(pos(k).y)) := coul;
          Grille(pos(k).x,pos(k).y) := vide;
	end loop;
      end case;
  end;
exception
  when others =>put("");
end MajGrille;

function Guerison (Grille : in TV_Grille) return boolean is
-- {} => {résultat = le virus (pièce rouge) est prêt à sortir (position coin haut gauche)}
begin
  return (Grille(1,'A') = rouge and Grille(2,'B') = rouge);
end Guerison;

function nbConfig(f : p_piece_io.file_type) return integer is
  nbC : integer := 0;
  elem, elemPrec : TR_ElemP;
begin
  while not end_of_file(f) loop
    read(f, elem);
    if elemPrec.couleur = rouge and elem.couleur = rouge then
      nbC := nbC+1;
    end if;
    elemPrec := elem;
  end loop;
  return nbC;
end nbConfig;

end p_virus;
