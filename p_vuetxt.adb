package body p_vuetxt is

  procedure AfficheGrille(Grille : in TV_Grille) is
  -- {} => {la grille a été affichée selon les spécifications suivantes :
  -- * la sortie est indiquée par la lettre S
  -- * une case inactive ne contient aucun caractère
  -- * une case de couleur vide contient un point
  -- * une case de couleur blanche contient le caractère F (Fixe)
  -- * une case de la couleur d’une pièce mobile contient le chiffre correspondant à la
  -- position de cette couleur dans le type T_Coul}
  begin
    put_line("  A B C D E F G ");
    put_line(" S--------------");
    for i in Grille'range(1) loop
      put(integer'image(i)(2..integer'image(i)'last) & "|");
      for j in Grille'range(2) loop
        if (Grille(i,j) = v) then
          put("  ");
        elsif (Grille(i,j) = vide) then
          put(ASCII.ESC & "[38;5;" & "250" & "m" & "██" & ASCII.ESC & "[0m");
        elsif (Grille(i,j) = rouge) then
          put(ASCII.ESC & "[38;5;" & "9" & "m" & "██" & ASCII.ESC & "[0m");
        elsif (Grille(i,j) = turquoise) then
          put(ASCII.ESC & "[38;5;" & "6" & "m" & "██" & ASCII.ESC & "[0m");
        elsif (Grille(i,j) = orange) then
          put(ASCII.ESC & "[38;5;" & "166" & "m" & "██" & ASCII.ESC & "[0m");
        elsif (Grille(i,j) = rose) then
          put(ASCII.ESC & "[38;5;" & "13" & "m" & "██" & ASCII.ESC & "[0m");
        elsif (Grille(i,j) = marron) then
          put(ASCII.ESC & "[38;5;" & "3" & "m" & "██" & ASCII.ESC & "[0m");
        elsif (Grille(i,j) = bleu) then
          put(ASCII.ESC & "[38;5;" & "12" & "m" & "██" & ASCII.ESC & "[0m");
        elsif (Grille(i,j) = violet) then
          put(ASCII.ESC & "[38;5;" & "5" & "m" & "██" & ASCII.ESC & "[0m");
        elsif (Grille(i,j) = vert) then
          put(ASCII.ESC & "[38;5;" & "2" & "m" & "██" & ASCII.ESC & "[0m");
        elsif (Grille(i,j) = jaune) then
          put(ASCII.ESC & "[38;5;" & "11" & "m" & "██" & ASCII.ESC & "[0m");
        elsif (Grille(i,j) = blanc) then
          put(ASCII.ESC & "[38;5;" & "255" & "m" & "██" & ASCII.ESC & "[0m");
        end if;
      end loop;
      new_line;
    end loop;
  end AfficheGrille;


  procedure ChConfig(reponse : out integer) is
  --{}=>{Demande a l'utilisateur de choisir une configuration}
  begin
    loop
    begin
      put("Choisir une configuration entre 1 et 20: "); get(reponse);
      exit when reponse in 1..20;
      exception
        when others => put_line("Mauvaise saisie");
        skip_line;
      end;
    end loop;
  end ChConfig;

  procedure ChCouleur(pieces : in TV_Pieces; reponse : out T_coulP) is
  --{}=>{}
  begin
    loop
    begin
      put("Choisir une couleur a deplacer: "); get(reponse);
      exit when pieces(reponse);
      exception
        when others => put_line("Mauvaise saisie");skip_line;
      end;
    end loop;
  end ChCouleur;

  procedure ChDir(dir : out T_Direction) is
  begin
    loop
    begin
      put("Choisir une direction pour deplacer la piece: "); get(dir);
      exit when dir'Valid;
    exception
      when others => put_line("Mauvaise saisie");skip_line;
    end;
    end loop;
  end ChDir;

  procedure commencerPartie(retour: in out boolean) is
    reponse : T_Rep;
  begin
    loop
    begin
      put("Voulez-vous commencer la partie ? (oui/non): "); get(reponse);
      exit when reponse'Valid;
      exception
        when others => put_line("Mauvaise saisie");skip_line;
      end;
    end loop;
    if reponse = non then
      retour:=false;
    end if;
  end commencerPartie;


  procedure Coup(Grille : in out TV_Grille; lastCoup : in out TV_Grille ; pieces : in TV_Pieces;continuer : out boolean ) is
    coul : T_Coul;
    dir : T_Direction;
    act : T_Action;
  begin
    loop
      begin
        put_line("Quelle action voulez-vous executer : ");
        put_line("  => "& ASCII.ESC & "[38;5;" & "9" & "m" & "Abandonner" & ASCII.ESC & "[0m" & " la partie.");
        put_line("  => "& ASCII.ESC & "[38;5;" & "9" & "m" & "Déplacer" & ASCII.ESC & "[0m" & " Une piece.");
        put_line("  => "& ASCII.ESC & "[38;5;" & "9" & "m" & "Annuler" & ASCII.ESC & "[0m" & " le coup precedent.");
        put("            > ");get(act);
        exit when act'Valid;
      exception
        when others => put_line("Mauvaise saisie");skip_line;
      end;
    end loop;

    case act is
      when abandonner => continuer:=false;
      put_line("-----------------------------------------");
      put_line("-----------------ABANDON-----------------");
      put_line("-----------------------------------------");
      when deplacer =>
        ChCouleur(Pieces, coul);
        ChDir(dir);
        if Possible(Grille, coul, dir) then
          lastCoup := Grille;
          MajGrille(Grille, coul, dir);
        else
          put_line("Déplacement impossible ! Une piece dois géner ou bien vous etes sur le bord du plateau");
        end if;
        continuer := true;
      when annuler =>
        AfficheGrille(Grille);
        Grille:=lastCoup;
        continuer := true;
    end case;
  end coup;

end p_vuetxt;
